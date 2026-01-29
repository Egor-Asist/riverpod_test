import 'dart:io';
import 'package:dio/io.dart';
import 'package:dio/dio.dart';
import '../models/crypto_model.dart';

class CoinDeskApi {
  CoinDeskApi(this._dio) {
    (_dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback = (cert, host, port) => true;
      return client;
    };
  }
  final Dio _dio;


  Future<Map<String, double>> getPricesForCryptos(
    String apiKey,
    List<String> cryptoCodes,
  ) async {
    try {
      final instruments = cryptoCodes.map((code) => '$code-USD').join(',');
      final response = await _dio.get(
        'https://data-api.coindesk.com/index/cc/v1/latest/tick',
        queryParameters: {'market': 'ccix', 'instruments': instruments},
        options: Options(headers: {'x-api-key': apiKey}),
      );

      return _parsePricesResponse(response.data, cryptoCodes);
    } catch (e) {
      print('Ошибка API: $e');
      rethrow;
    }
  }

  CryptoResponse _parseNewResponse(dynamic data) {
    final dataMap = data['Data'] as Map<String, dynamic>;
    final btcData = dataMap['BTC-USD'] as Map<String, dynamic>;
    final price = (btcData['VALUE'] as num).toDouble();

    return CryptoResponse(
      bpi: Bpi(usd: Usd(rate: price)),
    );
  }

  Map<String, double> _parsePricesResponse(
    dynamic data,
    List<String> cryptoCodes,
  ) {
    final dataMap = data['Data'] as Map<String, dynamic>;
    final prices = <String, double>{};

    for (final code in cryptoCodes) {
      final key = '$code-USD';
      if (dataMap.containsKey(key)) {
        final cryptoData = dataMap[key] as Map<String, dynamic>;
        final price = (cryptoData['VALUE'] as num).toDouble();
        prices[code] = price;
      }
    }

    return prices;
  }
}
