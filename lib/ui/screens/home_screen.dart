import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_test/providers/converter_provider.dart';
import 'package:riverpod_test/providers/crypto_stream_provider.dart';
import 'package:riverpod_test/providers/chart_notifier.dart';
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
    final btcHistory = ref.watch(bitcoinHistoryProvider);
    final currentBtcPrice = ref.watch(bitcoinPriceStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Finance Tracker ($baseCurrency)'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (code) =>
                ref.read(baseCurrencyProvider.notifier).set(code),
            itemBuilder: (context) =>
                ['USD', 'EUR', 'RUB', 'GBP']
                    .map((c) => PopupMenuItem(value: c, child: Text(c)))
                    .toList(),
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

          Expanded(
            child: ratesAsync.when(
              data: (fiat) => _buildList(fiat, amount),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => Center(child: Text('Ошибка API: $e')),
            ),
          ),

          _buildCryptoChart(currentBtcPrice, btcHistory),
        ],
      ),
    );
  }


  Widget _buildCryptoChart(AsyncValue<double> currentPrice,
      List<double> history) {
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
              const Text('BTC / USD LIVE', style: TextStyle(
                  color: Colors.white70, fontWeight: FontWeight.bold)),
              currentPrice.when(
                data: (price) =>
                    Text('\$${price.toStringAsFixed(2)}',
                        style: const TextStyle(color: Colors.orange,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                loading: () =>
                const SizedBox(width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2)),
                error: (_, __) =>
                const Text('Error', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: history.isEmpty
                ? const Center(child: Text(
                'Waiting for data...', style: TextStyle(color: Colors.white24)))
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
                    color: Colors.orange,
                    barWidth: 3,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                        show: true, color: Colors.orange.withOpacity(0.1)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(FiatResponse fiat, double amount) {
    final rates = fiat.rates;
    return ListView.builder(
      itemCount: rates.length,
      itemBuilder: (context, index) {
        final code = rates.keys.elementAt(index);
        final rate = rates.values.elementAt(index);
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
    );
  }
}
