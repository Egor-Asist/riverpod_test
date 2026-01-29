import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../core/network/network_providers.dart';
import '../core/config/app_config.dart';
import '../domain/repositories/currency_repository_impl.dart';
import '../domain/repositories/currency_repository.dart';
import 'app_config_provider.dart';

part 'repository_provider.g.dart';

@riverpod
CurrencyRepository currencyRepository(Ref ref) {
  final appConfig = ref.watch(appConfigProvider).valueOrNull;
  if (appConfig == null) {
    throw Exception('AppConfig not initialized');
  }

  final exchangeApi = ref.watch(exchangeApiProvider);
  final coinDeskApi = ref.watch(coinDeskApiProvider);

  return CurrencyRepositoryImpl(
    appConfig: appConfig,
    exchangeApi: exchangeApi,
    coinDeskApi: coinDeskApi,
  );
}
