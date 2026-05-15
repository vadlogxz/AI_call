import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:elia/core/network/client/api_client.dart';
import 'package:elia/core/network/config/api_endpoints.dart';
import 'package:elia/feature/vocabulary/domain/models/word_entry.dart';
import 'package:elia/feature/vocabulary/domain/repositories/vocabulary_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VocabularyRepositoryImpl implements VocabularyRepository {
  VocabularyRepositoryImpl({required FirebaseFirestore firestore, required ApiClient apiClient, required FirebaseAuth firebaseAuth})
      : _firestore = firestore,
        _apiClient = apiClient,
        _firebaseAuth = firebaseAuth;

  final FirebaseFirestore _firestore;
  final ApiClient _apiClient;
  final FirebaseAuth _firebaseAuth;


  @override
  Future<WordEntry> getWord(String word) async {
    // TODO: homonyms — the first generated meaning overwrites all others.
    // Needs disambiguation UI or a composite key like {word}_{type}. Post-MVP.
    final id = word.toLowerCase().trim();
    final query = word.trim();

    final doc = await _firestore
        .collection('vocabulary_cache')
        .doc(id)
        .get();

    if (doc.exists) {
      return WordEntry.fromJson(doc.data()!);
    }

    final token = await _firebaseAuth.currentUser!.getIdToken();
    if (token == null) throw Exception('No auth token');

    final response = await _apiClient.postJson(
      ApiEndpoints.wordGenerateEndpoint,
      data: {'word': query},
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    final data = response.data;
    if (data is Map<String, dynamic>) {
      return WordEntry.fromJson(data);
    }
    throw Exception('Unexpected response format: $data');
  }
}