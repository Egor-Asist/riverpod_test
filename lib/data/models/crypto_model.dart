import 'package:freezed_annotation/freezed_annotation.dart';

part 'crypto_model.freezed.dart';
part 'crypto_model.g.dart';

@freezed
class CryptoResponse with _$CryptoResponse {
  const factory CryptoResponse({
    required Bpi bpi,
  }) = _CryptoResponse;

  factory CryptoResponse.fromJson(Map<String, dynamic> json) =>
      _$CryptoResponseFromJson(json);
}

@freezed
class Bpi with _$Bpi {
  const factory Bpi({
    @JsonKey(name: 'USD') required Usd usd,
  }) = _Bpi;

  factory Bpi.fromJson(Map<String, dynamic> json) => _$BpiFromJson(json);
}

@freezed
class Usd with _$Usd {
  const factory Usd({
    @JsonKey(name: 'rate_float') required double rate,
  }) = _Usd;

  factory Usd.fromJson(Map<String, dynamic> json) => _$UsdFromJson(json);
}

