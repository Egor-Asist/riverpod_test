import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'repository_provider.dart';
import '../data/models/fiat_model.dart';

part 'rates_provider.g.dart';

@riverpod
Future<FiatResponse> latestRates(LatestRatesRef ref, String base) {
  final repository = ref.watch(currencyRepositoryProvider);
  return repository.getFiatRates(base);
}