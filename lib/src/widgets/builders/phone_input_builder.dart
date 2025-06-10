import 'package:flutter/material.dart';
import '../../models/country.dart';
import '../../models/phone_number.dart';
import '../../phone_controller.dart';

/// A builder widget that provides phone input functionality with flexible UI customization.
/// 
/// This widget gives you complete control over the UI while handling all the phone input logic.
/// You can use this to build your own custom phone input UI.
class PhoneInputBuilder extends StatefulWidget {
  /// Creates a phone input builder.
  const PhoneInputBuilder({
    super.key,
    required this.controller,
    required this.builder,
    this.onChanged,
    this.onCountryChanged,
    this.onValidated,
    this.validator,
  });

  /// The controller for the phone input.
  final PhoneController controller;

  /// The builder function that creates the UI.
  /// 
  /// Provides access to:
  /// - Current phone number
  /// - Selected country
  /// - Validation state
  /// - Callback functions
  final Widget Function(
    BuildContext context,
    PhoneNumber? phoneNumber,
    Country? country,
    bool isValid,
    String? errorMessage,
    {
      required Function(String) onNumberChanged,
      required Function(Country) onCountrySelected,
      required VoidCallback onCountryPickerPressed,
    },
  ) builder;

  /// Callback when the phone number changes.
  final void Function(PhoneNumber)? onChanged;

  /// Callback when the country changes.
  final void Function(Country)? onCountryChanged;

  /// Callback when the validation status changes.
  final void Function(bool)? onValidated;

  /// Custom validator function.
  final String? Function(PhoneNumber?)? validator;

  @override
  State<PhoneInputBuilder> createState() => _PhoneInputBuilderState();
}

class _PhoneInputBuilderState extends State<PhoneInputBuilder> {
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleControllerChange);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleControllerChange);
    super.dispose();
  }

  void _handleControllerChange() {
    if (mounted) {
      setState(() {
        _errorMessage = widget.validator?.call(widget.controller.phoneNumber);
      });
      widget.onValidated?.call(widget.controller.isValid);
    }
  }

  void _handleNumberChanged(String number) {
    widget.controller.setNumber(number);
    widget.onChanged?.call(widget.controller.phoneNumber);
  }

  void _handleCountrySelected(Country country) {
    widget.controller.setCountry(country);
    widget.onCountryChanged?.call(country);
  }

  void _showCountryPicker() {
    // Implementation of country picker dialog
    // This can be customized by the developer
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(
      context,
      widget.controller.phoneNumber,
      widget.controller.country,
      widget.controller.isValid,
      _errorMessage,
      onNumberChanged: _handleNumberChanged,
      onCountrySelected: _handleCountrySelected,
      onCountryPickerPressed: _showCountryPicker,
    );
  }
} 