import 'package:freezed_annotation/freezed_annotation.dart';

part 'fiat_model.freezed.dart';
part 'fiat_model.g.dart';

@freezed
class FiatResponse with _$FiatResponse {
  const factory FiatResponse({
    @JsonKey(name: 'base_code') required String baseCode,
    @JsonKey(name: 'conversion_rates') required Map<String, double> rates,
  }) = _FiatResponse;

  factory FiatResponse.fromJson(Map<String, dynamic> json) => _$FiatResponseFromJson(json);
}