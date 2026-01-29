import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_test/providers/selected_cryptos_provider.dart';

class CryptoSelector extends ConsumerWidget {

  const CryptoSelector({required this.selectedCrypto, super.key});

  final String selectedCrypto;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  onSelected: (val) => val
                      ? ref
                            .read(selectedCryptoProvider.notifier)
                            .setCrypto(crypto)
                      : null,
                  selectedColor: cryptoColor.withOpacity(0.3),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
