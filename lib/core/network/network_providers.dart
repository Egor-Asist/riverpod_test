import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/sources/coin_desk_api.dart';
import '../../data/sources/exchange_api.dart';

part 'network_providers.g.dart';

@riverpod
Dio dio(Ref ref) => Dio();

@riverpod
ExchangeApi exchangeApi(Ref ref) {
  return ExchangeApi(ref.watch(dioProvider));
}

@riverpod
CoinDeskApi coinDeskApi(Ref ref) {
  return CoinDeskApi(ref.watch(dioProvider));
}