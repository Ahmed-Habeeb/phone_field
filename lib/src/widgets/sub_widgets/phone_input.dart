import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../phone_controller.dart';

/// A widget that handles phone number input.
class PhoneInput extends StatelessWidget {
  /// Creates a phone input field.
  const PhoneInput({
    super.key,
    required this.controller,
    this.decoration,
    this.style,
    this.enabled = true,
    this.autofocus = false,
    required this.onChanged,
  });

  /// The controller for the phone input.
  final PhoneController controller;

  /// The decoration for the input field.
  final InputDecoration? decoration;

  /// The style for the input text.
  final TextStyle? style;

  /// Whether the field is enabled.
  final bool enabled;

  /// Whether to focus the field automatically.
  final bool autofocus;

  /// Callback when the phone number changes.
  final void Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: TextEditingController(text: controller.number),
      decoration: decoration ?? const InputDecoration(
        labelText: 'Phone Number',
        border: OutlineInputBorder(),
      ),
      style: style,
      enabled: enabled,
      autofocus: autofocus,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      onChanged: onChanged,
      onEditingComplete: () {
        // Format the number when editing is complete
        if (controller.country != null) {
          final formatted = controller.formatNumber();
          if (formatted != controller.number) {
            onChanged(formatted);
          }
        }
      },
    );
  }
} 