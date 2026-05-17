import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:elia/core/network/client/api_client.dart';
import 'package:elia/core/network/config/api_endpoints.dart';
import 'package:elia/feature/vocabulary/domain/models/word_entry.dart';
import 'package:elia/feature/vocabulary/domain/repositories/vocabulary_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VocabularyRepositoryImpl implements VocabularyRepository {
  VocabularyRepositoryImpl({
    required FirebaseFirestore firestore,
    required ApiClient apiClient,
    required FirebaseAuth firebaseAuth,
  })  : _firestore = firestore,
        _apiClient = apiClient,
        _firebaseAuth = firebaseAuth;

  final FirebaseFirestore _firestore;
  final ApiClient _apiClient;
  final FirebaseAuth _firebaseAuth;

  static const _cacheCollection = 'vocabulary_cache';
  static const _lookupCollection = 'vocabulary_lookup';

  // Only replace chars that break Firestore doc IDs — safe for umlauts, Cyrillic, etc.
  String _normalize(String input) => input
      .toLowerCase()
      .trim()
      .replaceAll(RegExp(r'[/\s]+'), '_');

  @override
  Future<WordEntry> getWord(String input) async {
    final key = _normalize(input);

    final lookupDoc = await _firestore.collection(_lookupCollection).doc(key).get();
    if (lookupDoc.exists) {
      final uuid = lookupDoc.data()!['wordId'] as String;
      final cacheDoc = await _firestore.collection(_cacheCollection).doc(uuid).get();
      if (cacheDoc.exists) return WordEntry.fromJson(cacheDoc.data()!);
    }

    final token = await _firebaseAuth.currentUser?.getIdToken();
    if (token == null) throw Exception('No auth token');

    final response = await _apiClient.postJson(
      ApiEndpoints.wordGenerateEndpoint,
      data: {'word': input.trim()},
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw Exception('Unexpected response format: $data');
    }

    final wordEntry = WordEntry.fromJson(data);

    final cacheRef = _firestore.collection(_cacheCollection).doc(wordEntry.id);
    final existing = await cacheRef.get();
    if (!existing.exists) {
      await cacheRef.set(wordEntry.toJson());
    }

    final batch = _firestore.batch();
    batch.set(
      _firestore.collection(_lookupCollection).doc(key),
      {'wordId': wordEntry.id},
    );
    final lemmaKey = _normalize(wordEntry.word);
    if (lemmaKey != key) {
      batch.set(
        _firestore.collection(_lookupCollection).doc(lemmaKey),
        {'wordId': wordEntry.id},
      );
    }
    await batch.commit();

    return wordEntry;
  }
}
