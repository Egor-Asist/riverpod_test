import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'selected_cryptos_provider.dart';
import 'repository_provider.dart';
import 'dart:async';

part 'chart_notifier.g.dart';

@riverpod
class BitcoinHistory extends _$BitcoinHistory {
  Timer? _timer;

  @override
  List<double> build() {
    final selectedCrypto = ref.watch(selectedCryptoProvider);
    final repository = ref.watch(currencyRepositoryProvider);

    state = [];

    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 10), (_) async {
      try {
        final prices = await repository.getCryptoPrices([selectedCrypto]);
        if (prices.containsKey(selectedCrypto)) {
          _addPrice(prices[selectedCrypto]!);
        }
      } catch (e) {
        print('Ошибка при загрузке цены: $e');
      }
    });

    _loadInitialPrice(repository, selectedCrypto);

    ref.onDispose(() {
      _timer?.cancel();
    });

    return [];
  }

  void _addPrice(double price) {
    final newList = [...state, price];
    if (newList.length > 20) {
      state = newList.sublist(newList.length - 20);
    } else {
      state = newList;
    }
  }

  Future<void> _loadInitialPrice(dynamic repository, String crypto) async {
    try {
      final prices = await repository.getCryptoPrices([crypto]);
      if (prices.containsKey(crypto)) {
        _addPrice(prices[crypto]!);
      }
    } catch (e) {
      print('Ошибка при загрузке цены: $e');
    }
  }
}

@riverpod
class CurrentCryptoPrice extends _$CurrentCryptoPrice {
  Timer? _timer;

  @override
  Future<double> build() async {
    final selectedCrypto = ref.watch(selectedCryptoProvider);
    final repository = ref.watch(currencyRepositoryProvider);

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 10), (_) async {
      try {
        final prices = await repository.getCryptoPrices([selectedCrypto]);
        if (prices.containsKey(selectedCrypto)) {
          state = AsyncValue.data(prices[selectedCrypto]!);
        }
      } catch (e) {
        print('Ошибка при загрузке цены: $e');
      }
    });

    ref.onDispose(() {
      _timer?.cancel();
    });

    try {
      final prices = await repository.getCryptoPrices([selectedCrypto]);
      if (prices.containsKey(selectedCrypto)) {
        return prices[selectedCrypto]!;
      }
      return 0.0;
    } catch (e) {
      print('Ошибка при загрузке цены: $e');
      rethrow;
    }
  }
}
