import 'package:custom_phone_field/src/ui/phone_picker_dialog.dart';
import 'package:flutter/material.dart';

import '../helpers/countries.dart';
import '../models/country_model.dart';

class PhoneField extends StatefulWidget {
  final String initialCountry;
  final List<String> availableCountries;
  final String languageCode;
  final Widget Function(
    BuildContext context,
    Country country,
    VoidCallback openPicker,
  ) builder;

  /// Callback when country is changed
  final void Function(Country country)? onCountryChanged;

  const PhoneField({
    super.key,
    required this.builder,
    this.initialCountry = 'EG',
    this.languageCode = 'en',
    this.availableCountries = const [],
    this.onCountryChanged,
  });

  @override
  _PhoneFieldState createState() => _PhoneFieldState();
}

class _PhoneFieldState extends State<PhoneField> {
  List<Country> countryList = countries;
  late Country _selectedCountry;

  @override
  void initState() {
    super.initState();
    countryList = countries
        .where((country) => widget.availableCountries.contains(country.code))
        .toList();
    debugPrint('countryList $countryList');

    _selectedCountry = countryList.firstWhere(
      (country) => country.code == widget.initialCountry,
      orElse: () =>
          countries.first, // Fallback to the first country if not found
    );
  }

  @override
  void didUpdateWidget(PhoneField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.availableCountries != widget.availableCountries) {
      countryList = countries
          .where((country) => widget.availableCountries.contains(country.code))
          .toList();
    }
    if (oldWidget.initialCountry != widget.initialCountry) {
      _selectedCountry = countryList.firstWhere(
        (country) => country.code == widget.initialCountry,
        orElse: () =>
            countries.first, // Fallback to the first country if not found
      );
    }
  }

  Future<void> _pickCountry() async {
    final Country? selected = await showDialog<Country>(
      context: context,
      builder: (context) => PhonePickerDialog(
        countries: countryList,
        languageCode: widget.languageCode,
        onSelect: (country) {
          Navigator.pop(context, country);
        },
      ),
    );

    if (selected != null) {
      setState(() {
        _selectedCountry = selected;
      });

      // Call the callback when country changes
      widget.onCountryChanged?.call(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _selectedCountry, _pickCountry);
  }
}
