import 'dart:io';
import 'package:dio/io.dart';
import 'package:dio/dio.dart';
import '../models/crypto_model.dart';

class CoinDeskApi {
  final Dio _dio;
  CoinDeskApi(this._dio) {
    (_dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback = (cert, host, port) => true;
      return client;
    };
  }

  Future<CryptoResponse> getPrice(String apiKey) async {
    try {
      final response = await _dio.get(
        'https://data-api.coindesk.com/index/cc/v1/latest/tick',
        queryParameters: {
          'market': 'ccix',
          'instruments': 'BTC-USD',
        },
        options: Options(
          headers: {
            'x-api-key': apiKey,
          },
        ),
      );

      return _parseNewResponse(response.data);
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
}