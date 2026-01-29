import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:riverpod_test/providers/selected_cryptos_provider.dart';

class CryptoChart extends StatelessWidget {
  const CryptoChart({
    required this.currentPrice,
    required this.history,
    required this.selectedCrypto,
    super.key,
  });

  final AsyncValue<double> currentPrice;
  final List<double> history;
  final String selectedCrypto;

  @override
  Widget build(BuildContext context) {
    final cryptoColor = Color(
      SelectedCrypto.cryptoColors[selectedCrypto] ?? 0xFFFF9500,
    );

    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$selectedCrypto / USD LIVE',
                style: const TextStyle(color: Colors.white70),
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
                      borderData: FlBorderData(show: false),
                      titlesData: const FlTitlesData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: history
                              .asMap()
                              .entries
                              .map((e) => FlSpot(e.key.toDouble(), e.value))
                              .toList(),
                          isCurved: true,
                          color: cryptoColor,
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
}
