import 'package:elia/core/logging/app_logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

base class AppProviderObserver extends ProviderObserver{

  @override
  void didUpdateProvider(ProviderObserverContext context, Object? previousValue, Object? newValue) {

    AppLogger.debug(
      'Updated: ${context.provider.name ?? context.provider.runtimeType} | $previousValue → $newValue',
      tag: LogTag.provider,
    );

    super.didUpdateProvider(context, previousValue, newValue);
  }

  @override
  void didDisposeProvider(ProviderObserverContext context) {

    AppLogger.debug(
      'Dispose: ${context.provider.name ?? context.provider.runtimeType}',
      tag: LogTag.provider,
    );

    super.didDisposeProvider(context);
  }

    @override
  void providerDidFail(ProviderObserverContext context, Object error, StackTrace stackTrace) {
      AppLogger.error(
        'Failed ${context.provider.name ?? context.provider.runtimeType}',
        tag: LogTag.provider,
        error: error,
        stackTrace: stackTrace,
      );
    super.providerDidFail(context, error, stackTrace);
  }
}