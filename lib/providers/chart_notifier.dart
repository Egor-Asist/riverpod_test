import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'crypto_stream_provider.dart';
import 'selected_cryptos_provider.dart';

part 'chart_notifier.g.dart';

class CryptoState {
  const CryptoState({required this.price, required this.history});

  final double price;
  final List<double> history;
}

@riverpod
class CryptoData extends _$CryptoData {
  @override
  CryptoState build() {
    ref.watch(selectedCryptoProvider);
    ref.listen(cryptoPriceStreamProvider, (previous, next) {
      final value = next.value;
      if (value != null && value > 0) {
        _update(value);
      }
    });

    return CryptoState(price: 0.0, history: []);
  }

  void _update(double newPrice) {
    final newHistory = [...state.history, newPrice];
    state = CryptoState(
      price: newPrice,
      history: newHistory.length > 20
          ? newHistory.sublist(newHistory.length - 20)
          : newHistory,
    );
  }
}