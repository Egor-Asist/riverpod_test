import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_test/data/models/fiat_model.dart';
import 'package:riverpod_test/providers/converter_provider.dart';
import 'package:riverpod_test/providers/rates_provider.dart';
import 'package:riverpod_test/providers/selected_cryptos_provider.dart';

class FiatList extends ConsumerWidget {

  const FiatList({required this.ratesAsync, required this.amount, super.key});

  final AsyncValue<FiatResponse> ratesAsync;
  final double amount;


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ratesAsync.when(
      data: (fiat) {
        final rates = fiat.rates ?? {};
        final availableFiats = rates.keys.toList();

        final filterQuery = ref.watch(fiatFilterProvider).toLowerCase();

        final filteredFiats = availableFiats
            .where((code) => code.toLowerCase().contains(filterQuery))
            .toList();

        return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
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
          }, childCount: filteredFiats.length),
        );
      },
      loading: () => const SliverToBoxAdapter(
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, s) =>
          SliverToBoxAdapter(child: Center(child: Text('Ошибка API: $e'))),
    );
  }
}
