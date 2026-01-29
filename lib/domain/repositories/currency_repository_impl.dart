import '../../../core/config/app_config.dart';
import 'currency_repository.dart';
import '../../data/sources/coin_desk_api.dart';
import '../../data/sources/exchange_api.dart';
import '../../data/models/fiat_model.dart';
import '../../data/models/crypto_model.dart';

class CurrencyRepositoryImpl implements CurrencyRepository {
  const CurrencyRepositoryImpl({
    required AppConfig appConfig,
    required ExchangeApi exchangeApi,
    required CoinDeskApi coinDeskApi,
  }) : _appConfig = appConfig,
       _coinDeskApi = coinDeskApi,
       _exchangeApi = exchangeApi;

  final AppConfig _appConfig;
  final ExchangeApi _exchangeApi;
  final CoinDeskApi _coinDeskApi;

  @override
  Future<FiatResponse> getFiatRates(String baseCurrency) {
    return _exchangeApi.getLatestRates(
      _appConfig.exchangeRateApiKey,
      baseCurrency,
    );
  }

  @override
  Future<Map<String, double>> getCryptoPrices(List<String> cryptoCodes) {
    return _coinDeskApi.getPricesForCryptos(
      _appConfig.coinDeskApiKey,
      cryptoCodes,
    );
  }
}
