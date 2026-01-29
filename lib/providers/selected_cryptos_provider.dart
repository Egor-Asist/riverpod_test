import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_cryptos_provider.g.dart';

@riverpod
class SelectedCrypto extends _$SelectedCrypto {
  static const availableCryptos = [
    'BTC',
    'ETH',
    'XRP',
    'SOL',
    'ADA',
    'DOGE',
    'MATIC',
    'LINK',
  ];

  static const cryptoColors = {
    'BTC': 0xFFFF9500,
    'ETH': 0xFF627EEA,
    'XRP': 0xFF23292F,
    'SOL': 0xFF14F195,
    'ADA': 0xFF0033AD,
    'DOGE': 0xFFD3A625,
    'MATIC': 0xFF8247E5,
    'LINK': 0xFF2A5ADA,
  };



  @override
  String build() {
    return 'BTC';
  }

  void setCrypto(String crypto) {
    state = crypto;
  }
}

@riverpod
class FiatFilter extends _$FiatFilter {
  @override
  String build() {
    return '';
  }

  void setFilter(String query) {
    state = query.toLowerCase();
  }

  List<String> getFiltered(List<String> fiats) {
    if (state.isEmpty) {
      return fiats;
    }
    return fiats.where((fiat) => fiat.toLowerCase().startsWith(state)).toList();
  }
}
