import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'currency_repository.dart';
import '../../data/sources/coin_desk_api.dart';
import '../../data/sources/exchange_api.dart';
import '../../data/models/fiat_model.dart';
import '../../data/models/crypto_model.dart';

class CurrencyRepositoryImpl implements CurrencyRepository {
  final ExchangeApi _exchangeApi;
  final CoinDeskApi _coinDeskApi;

  CurrencyRepositoryImpl(this._exchangeApi, this._coinDeskApi);

  @override
  Future<FiatResponse> getFiatRates(String baseCurrency) {
    final key = dotenv.env['EXCHANGE_RATE_API_KEY'] ?? '';
    return _exchangeApi.getLatestRates(key, baseCurrency);
  }

  @override
  Future<CryptoResponse> getBitcoinPrice() {
    final key = dotenv.env['COINDESK_API_KEY'] ?? '';
    return _coinDeskApi.getPrice(key);
  }
}