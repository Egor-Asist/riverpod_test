import 'package:flutter_dotenv/flutter_dotenv.dart';

final class AppConfig {
  const AppConfig({
    required this.exchangeRateApiKey,
    required this.coinDeskApiKey,
  });

  final String exchangeRateApiKey;
  final String coinDeskApiKey;

  static Future<AppConfig> initialize({String fileName = ".env"}) async {
    await dotenv.load(fileName: fileName);

    final exchangeRateApiKey = dotenv.env['EXCHANGE_RATE_API_KEY'] ?? '';
    final coinDeskApiKey = dotenv.env['COINDESK_API_KEY'] ?? '';

    if (exchangeRateApiKey.isEmpty) {
      throw Exception('EXCHANGE_RATE_API_KEY is not set in .env file');
    }
    if (coinDeskApiKey.isEmpty) {
      throw Exception('COINDESK_API_KEY is not set in .env file');
    }

    return AppConfig(
      exchangeRateApiKey: exchangeRateApiKey,
      coinDeskApiKey: coinDeskApiKey,
    );
  }
}
