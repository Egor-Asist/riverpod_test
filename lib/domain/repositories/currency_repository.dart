import '../../data/models/fiat_model.dart';
import '../../data/models/crypto_model.dart';

abstract class CurrencyRepository {
  Future<FiatResponse> getFiatRates(String baseCurrency);
  Future<CryptoResponse> getBitcoinPrice();
  Future<Map<String, double>> getCryptoPrices(List<String> cryptoCodes);
}
