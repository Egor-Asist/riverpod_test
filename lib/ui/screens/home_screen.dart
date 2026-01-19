import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_test/providers/converter_provider.dart';
import 'package:riverpod_test/providers/chart_notifier.dart';
import 'package:riverpod_test/providers/selected_cryptos_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../data/models/fiat_model.dart';
import '../../providers/rates_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final baseCurrency = ref.watch(baseCurrencyProvider);
    final ratesAsync = ref.watch(latestRatesProvider(baseCurrency));
    final amount = ref.watch(amountProvider);
    final cryptoHistory = ref.watch(bitcoinHistoryProvider);
    final currentPrice = ref.watch(currentCryptoPriceProvider);
    final selectedCrypto = ref.watch(selectedCryptoProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Finance Tracker ($baseCurrency)'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (code) =>
                ref.read(baseCurrencyProvider.notifier).set(code),
            itemBuilder: (context) => [
              'USD',
              'EUR',
              'RUB',
              'GBP',
            ].map((c) => PopupMenuItem(value: c, child: Text(c))).toList(),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Сумма',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.calculate),
              ),
              onChanged: (value) =>
                  ref.read(amountProvider.notifier).update(value),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12.0),
            child: _buildCryptoSelector(ref, selectedCrypto),
          ),

          _buildCryptoChart(currentPrice, cryptoHistory, selectedCrypto),

          Expanded(
            child: ratesAsync.when(
              data: (fiat) => _buildFiatList(ref, fiat, amount),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => Center(child: Text('Ошибка API: $e')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCryptoSelector(WidgetRef ref, String selectedCrypto) {
    final availableCryptos = SelectedCrypto.availableCryptos;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Выберите криптовалюту:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: availableCryptos.map((crypto) {
              final isSelected = selectedCrypto == crypto;
              final cryptoColor = Color(
                SelectedCrypto.cryptoColors[crypto] ?? 0xFFFF9500,
              );

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: FilterChip(
                  label: Text(crypto),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      ref
                          .read(selectedCryptoProvider.notifier)
                          .setCrypto(crypto);
                    }
                  },
                  backgroundColor: Colors.grey[200],
                  selectedColor: cryptoColor.withOpacity(0.3),
                  side: BorderSide(
                    color: isSelected ? cryptoColor : Colors.grey[300]!,
                    width: isSelected ? 2 : 1,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildCryptoChart(
    AsyncValue<double> currentPrice,
    List<double> history,
    String selectedCrypto,
  ) {
    final cryptoColor = Color(
      SelectedCrypto.cryptoColors[selectedCrypto] ?? 0xFFFF9500,
    );

    return Container(
      height: 200,
      width: double.infinity,
      color: Colors.black87,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$selectedCrypto / USD LIVE',
                style: const TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                ),
              ),
              currentPrice.when(
                data: (price) => Text(
                  '\$${price.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: cryptoColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                loading: () => const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                error: (_, __) =>
                    const Text('Error', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: history.isEmpty
                ? const Center(
                    child: Text(
                      'Ожидание данных...',
                      style: TextStyle(color: Colors.white24),
                    ),
                  )
                : LineChart(
                    LineChartData(
                      minY: history.reduce((a, b) => a < b ? a : b) - 5,
                      maxY: history.reduce((a, b) => a > b ? a : b) + 5,
                      gridData: const FlGridData(show: false),
                      titlesData: const FlTitlesData(show: false),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: history
                              .asMap()
                              .entries
                              .map((e) => FlSpot(e.key.toDouble(), e.value))
                              .toList(),
                          isCurved: true,
                          color: cryptoColor,
                          barWidth: 3,
                          dotData: const FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            color: cryptoColor.withOpacity(0.1),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiatList(WidgetRef ref, FiatResponse fiat, double amount) {
    final availableFiats = fiat.rates.keys.toList();
    ref.watch(fiatFilterProvider);
    final filteredFiats = ref
        .read(fiatFilterProvider.notifier)
        .getFiltered(availableFiats);

    final rates = fiat.rates;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Поиск валюты...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              isDense: true,
            ),
            onChanged: (value) {
              ref.read(fiatFilterProvider.notifier).setFilter(value);
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredFiats.length,
            itemBuilder: (context, index) {
              final code = filteredFiats[index];
              final rate = rates[code] ?? 0.0;
              final convertedValue = rate * amount;

              return ListTile(
                title: Text(code),
                subtitle: Text('Курс: ${rate.toStringAsFixed(4)}'),
                trailing: Text(
                  convertedValue.toStringAsFixed(2),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.green,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
