import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../core/network/network_providers.dart';
import '../domain/repositories/currency_repository_impl.dart';
import '../domain/repositories/currency_repository.dart';

part 'repository_provider.g.dart';

@riverpod
CurrencyRepository currencyRepository(CurrencyRepositoryRef ref) {
  final exchangeApi = ref.watch(exchangeApiProvider);
  final coinDeskApi = ref.watch(coinDeskApiProvider);

  return CurrencyRepositoryImpl(exchangeApi, coinDeskApi);
}