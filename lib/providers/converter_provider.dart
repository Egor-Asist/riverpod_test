import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'converter_provider.g.dart';

@riverpod
class Amount extends _$Amount {
  @override
  double build() => 1.0;

  void update(String value) {
    state = double.tryParse(value) ?? 0.0;
  }
}

@riverpod
class BaseCurrency extends _$BaseCurrency {
  @override
  String build() => 'USD';

  void set(String code) {
    state = code;
  }
}