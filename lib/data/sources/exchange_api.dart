import 'package:dio/dio.dart';
import '../models/fiat_model.dart';

class ExchangeApi {
  final Dio _dio;
  ExchangeApi(this._dio);

  Future<FiatResponse> getLatestRates(String key, String base) async {
    final response = await _dio.get('https://v6.exchangerate-api.com/v6/$key/latest/$base');
    return FiatResponse.fromJson(response.data as Map<String, dynamic>);
  }
}