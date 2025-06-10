import 'package:flutter/material.dart';
import '../../models/country.dart';

/// A widget that displays the selected country and allows opening the country picker.
class CountrySelector extends StatelessWidget {
  /// Creates a country selector.
  const CountrySelector({
    super.key,
    this.country,
    this.showFlag = true,
    this.showCode = true,
    required this.onTap,
  });

  /// The currently selected country.
  final Country? country;

  /// Whether to show the country flag.
  final bool showFlag;

  /// Whether to show the country code.
  final bool showCode;

  /// Callback when the selector is tapped.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (country != null) ...[
              if (showFlag) ...[
                Image.asset(
                  'assets/flags/${country!.code.toLowerCase()}.png',
                  width: 24,
                  height: 24,
                  package: 'phone_field',
                ),
                const SizedBox(width: 8),
              ],
              if (showCode)
                Text(
                  '+${country!.dialCode}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
            ] else
              Text(
                'Select Country',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).hintColor,
                    ),
              ),
            const Spacer(),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
} 