import 'package:flutter/material.dart';

/// A widget that displays validation messages for the phone field.
class ValidationMessage extends StatelessWidget {
  /// Creates a validation message widget.
  const ValidationMessage({
    super.key,
    this.errorMessage,
  });

  /// The error message to display.
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    if (errorMessage == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        errorMessage!,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
      ),
    );
  }
} 