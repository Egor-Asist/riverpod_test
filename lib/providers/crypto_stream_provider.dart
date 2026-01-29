import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'selected_cryptos_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'repository_provider.dart';

part 'crypto_stream_provider.g.dart';

@riverpod
Stream<double> cryptoPriceStream(Ref ref) async* {
  final repository = ref.watch(currencyRepositoryProvider);
  final selectedCrypto = ref.watch(selectedCryptoProvider);

  yield* Stream.periodic(const Duration(seconds: 5)).asyncMap((_) async {
    try {
      final prices = await repository.getCryptoPrices([selectedCrypto]);
      return prices[selectedCrypto] ?? 0.0;
    } catch (e) {
      return 0.0;
    }
  });
}