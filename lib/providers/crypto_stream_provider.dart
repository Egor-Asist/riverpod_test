import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'repository_provider.dart';

part 'crypto_stream_provider.g.dart';

@riverpod
Stream<double> bitcoinPriceStream(BitcoinPriceStreamRef ref) async* {
  final repository = ref.watch(currencyRepositoryProvider);

  while (true) {
    try {
      final response = await repository.getBitcoinPrice();
      yield response.bpi.usd.rate;
    } catch (e) {
      print("Ошибка: $e");
    }
    await Future.delayed(const Duration(seconds: 10));
  }
}