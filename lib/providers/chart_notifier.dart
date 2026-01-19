import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'crypto_stream_provider.dart';

part 'chart_notifier.g.dart';

@riverpod
class BitcoinHistory extends _$BitcoinHistory {
  @override
  List<double> build() {
    ref.listen(bitcoinPriceStreamProvider, (previous, next) {
      if (next.hasValue) {
        _addPrice(next.value!);
      }
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
}