import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_test/providers/converter_provider.dart';
import 'package:riverpod_test/providers/chart_notifier.dart';
import 'package:riverpod_test/providers/selected_cryptos_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../data/models/fiat_model.dart';
import '../../providers/rates_provider.dart';
import '../../providers/chart_notifier.dart';
import '../../core/currency_enum.dart';
import 'package:flutter/services.dart';
import 'widgets/crypto_selector.dart';
import 'widgets/crypto_chart.dart';
import 'widgets/fiat_list.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final baseCurrency = ref.watch(baseCurrencyProvider);

    final ratesAsync = ref.watch(latestRatesProvider(baseCurrency.code));
    final amount = ref.watch(amountProvider);
    final cryptoData = ref.watch(cryptoDataProvider);
    final selectedCrypto = ref.watch(selectedCryptoProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text('Finance Tracker (${baseCurrency.code})'),
            floating: true,
            pinned: true,
            actions: [
              PopupMenuButton<CurrencyCode>(
                onSelected: (currency) =>
                    ref.read(baseCurrencyProvider.notifier).set(currency),
                itemBuilder: (context) => CurrencyCode.all
                    .map((c) => PopupMenuItem(value: c, child: Text(c.code)))
                    .toList(),
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                decoration: const InputDecoration(
                  labelText: 'Сумма',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calculate),
                ),
                onTapOutside: (_) =>
                    FocusManager.instance.primaryFocus?.unfocus(),
                onChanged: (value) =>
                    ref.read(amountProvider.notifier).update(value),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: CryptoSelector(selectedCrypto: selectedCrypto),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: CryptoChart(
                currentPrice: AsyncData(cryptoData.price),
                history: cryptoData.history,
                selectedCrypto: selectedCrypto,
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                maxLength: 3,
                decoration: InputDecoration(
                  hintText: 'Поиск валюты (например, USD)...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  isDense: true,
                  counterText: '',
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                  UpperCaseTextFormatter(),
                ],
                onTapOutside: (_) =>
                    FocusManager.instance.primaryFocus?.unfocus(),
                onChanged: (value) =>
                    ref.read(fiatFilterProvider.notifier).setFilter(value),
              ),
            ),
          ),

          FiatList(ratesAsync: ratesAsync, amount: amount),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(text: newValue.text.toUpperCase());
  }
}
