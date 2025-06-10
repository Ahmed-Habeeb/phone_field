import 'package:flutter/material.dart';
import '../builders/phone_input_builder.dart';
import '../../models/country.dart';
import '../../models/phone_number.dart';
import '../../phone_controller.dart';

/// A pre-built phone input field widget with country selection.
/// 
/// This widget provides a complete phone input experience with a pre-built UI.
/// For custom UI, use [PhoneInputBuilder] instead.
class PhoneInputField extends StatelessWidget {
  /// Creates a phone input field.
  const PhoneInputField({
    super.key,
    required this.controller,
    this.decoration,
    this.style,
    this.enabled = true,
    this.autofocus = false,
    this.showCountryFlag = true,
    this.showCountryCode = true,
    this.showValidationMessage = true,
    this.enableFavoriteCountries = false,
    this.enableRecentCountries = false,
    this.enableE164Format = false,
    this.onChanged,
    this.onCountryChanged,
    this.onValidated,
    this.validator,
  });

  /// The controller for the phone field.
  final PhoneController controller;

  /// The decoration for the input field.
  final InputDecoration? decoration;

  /// The style for the input text.
  final TextStyle? style;

  /// Whether the field is enabled.
  final bool enabled;

  /// Whether to focus the field automatically.
  final bool autofocus;

  /// Whether to show the country flag.
  final bool showCountryFlag;

  /// Whether to show the country code.
  final bool showCountryCode;

  /// Whether to show validation messages.
  final bool showValidationMessage;

  /// Whether to enable favorite countries.
  final bool enableFavoriteCountries;

  /// Whether to enable recent countries.
  final bool enableRecentCountries;

  /// Whether to use E.164 format.
  final bool enableE164Format;

  /// Callback when the phone number changes.
  final void Function(PhoneNumber)? onChanged;

  /// Callback when the country changes.
  final void Function(Country)? onCountryChanged;

  /// Callback when the validation status changes.
  final void Function(bool)? onValidated;

  /// Custom validator function.
  final String? Function(PhoneNumber?)? validator;

  @override
  Widget build(BuildContext context) {
    return PhoneInputBuilder(
      controller: controller,
      onChanged: onChanged,
      onCountryChanged: onCountryChanged,
      onValidated: onValidated,
      validator: validator,
      builder: (context, phoneNumber, country, isValid, errorMessage, {
        required onNumberChanged,
        required onCountrySelected,
        required onCountryPickerPressed,
      }) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Country selector
                Expanded(
                  flex: 2,
                  child: _buildCountrySelector(
                    context,
                    country,
                    onCountryPickerPressed,
                  ),
                ),
                const SizedBox(width: 8),
                // Phone input
                Expanded(
                  flex: 3,
                  child: _buildPhoneInput(
                    context,
                    phoneNumber,
                    onNumberChanged,
                  ),
                ),
              ],
            ),
            // Validation message
            if (showValidationMessage && errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  errorMessage,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildCountrySelector(
    BuildContext context,
    Country? country,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: enabled ? onTap : null,
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
              if (showCountryFlag) ...[
                Image.asset(
                  'assets/flags/${country.code.toLowerCase()}.png',
                  width: 24,
                  height: 24,
                  package: 'smart_phone_field',
                ),
                const SizedBox(width: 8),
              ],
              if (showCountryCode)
                Text(
                  '+${country.dialCode}',
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

  Widget _buildPhoneInput(
    BuildContext context,
    PhoneNumber? phoneNumber,
    Function(String) onChanged,
  ) {
    return TextFormField(
      initialValue: phoneNumber?.number ?? '',
      decoration: decoration ?? const InputDecoration(
        labelText: 'Phone Number',
        border: OutlineInputBorder(),
      ),
      style: style,
      enabled: enabled,
      autofocus: autofocus,
      keyboardType: TextInputType.phone,
      onChanged: onChanged,
    );
  }
} 