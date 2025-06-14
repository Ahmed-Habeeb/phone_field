import 'package:flutter/material.dart';
import '../../custom_phone_field.dart';

class CustomPhoneInput extends StatefulWidget {
  /// The initial country code to display
  final String initialCountry;

  /// List of country codes that should be available for selection
  final List<String> availableCountries;

  /// Language code for localization
  final String languageCode;

  /// Callback when country is changed
  final void Function(Country country)? onCountryChanged;

  /// Callback when phone number is changed
  final void Function(String phoneNumber)? onPhoneNumberChanged;

  /// Initial phone number value
  final String? initialValue;

  /// Whether the field is enabled
  final bool enabled;

  /// Whether the field is read-only
  final bool readOnly;

  /// The decoration for the input field
  final InputDecoration? decoration;

  /// The style for the input text
  final TextStyle? style;

  /// The validator callback for the input field
  final String? Function(String?)? validator;

  final TextEditingController? controller;

  const CustomPhoneInput({
    super.key,
    this.initialCountry = 'EG',
    this.languageCode = 'en',
    this.availableCountries = const [],
    this.onCountryChanged,
    this.onPhoneNumberChanged,
    this.initialValue,
    this.enabled = true,
    this.readOnly = false,
    this.decoration,
    this.style,
    this.validator,
    this.controller,
  });

  @override
  State<CustomPhoneInput> createState() => _CustomPhoneInputState();
}

class _CustomPhoneInputState extends State<CustomPhoneInput> {
  late TextEditingController controller;
  late FocusNode focusNode;
  String? errorText;

  @override
  void initState() {
    super.initState();
    controller = widget.controller??TextEditingController();
    // Set initial value if provided
    if (widget.initialValue != null) {
      controller.text = widget.initialValue!;
    }
    focusNode = FocusNode();

    // Listen to focus changes to update border color
    focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PhoneField(
      initialCountry: widget.initialCountry,
      languageCode: widget.languageCode,
      availableCountries: widget.availableCountries,
      onCountryChanged: widget.onCountryChanged,
      builder: (context, country, openPicker) {
        return Row(
          children: [
            // Country selector button
            GestureDetector(
              onTap: widget.enabled && !widget.readOnly ? openPicker : null,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: widget.enabled ? Colors.white : Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: errorText != null
                        ? Colors.red
                        : focusNode.hasFocus
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Country flag
                    Image.asset(
                      'assets/flags/${country.code.toLowerCase()}.png',
                      package: 'phone_field',
                      width: 24,
                      height: 24,
                      errorBuilder: (context, error, stackTrace) {
                        // Fallback if flag image is not found
                        return Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Center(
                            child: Text(
                              country.code,
                              style: const TextStyle(fontSize: 10),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    // Country code
                    Text(
                      '+${country.dialCode}',
                      style: widget.style?.copyWith(
                            fontWeight: FontWeight.bold,
                          ) ??
                          const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Phone number input field
            Expanded(
              child: TextFormField(
                controller: controller,
                focusNode: focusNode,
                enabled: widget.enabled,
                readOnly: widget.readOnly,
                style: widget.style,
                keyboardType: TextInputType.phone,
                decoration:
                    (widget.decoration ?? const InputDecoration()).copyWith(
                  errorText: errorText,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Colors.red,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                onChanged: (value) {
                  widget.onPhoneNumberChanged?.call(value);
                  // Clear error when user starts typing
                  if (errorText != null) {
                    setState(() {
                      errorText = null;
                    });
                  }
                },
                validator: (value) {
                  final validationResult = widget.validator?.call(value);
                  setState(() {
                    errorText = validationResult;
                  });
                  return validationResult;
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
