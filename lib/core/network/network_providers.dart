import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/sources/coin_desk_api.dart';
import '../../data/sources/exchange_api.dart';

part 'network_providers.g.dart';

@riverpod
Dio dio(DioRef ref) => Dio();

@riverpod
ExchangeApi exchangeApi(ExchangeApiRef ref) {
  return ExchangeApi(ref.watch(dioProvider));
}

@riverpod
CoinDeskApi coinDeskApi(CoinDeskApiRef ref) {
  return CoinDeskApi(ref.watch(dioProvider));
}