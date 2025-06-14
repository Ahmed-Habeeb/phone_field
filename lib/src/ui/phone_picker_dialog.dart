import 'package:flutter/material.dart';

import '../models/country_model.dart';

class PhonePickerDialog extends StatefulWidget {
  final List<Country> countries;
  final Function(Country) onSelect;
  final String languageCode;

  const PhonePickerDialog({
    super.key,
    required this.countries,
    required this.onSelect,
    required this.languageCode,
  });

  @override
  _PhonePickerDialogState createState() => _PhonePickerDialogState();
}

class _PhonePickerDialogState extends State<PhonePickerDialog> {
  late List<Country> _filteredCountries;

  @override
  void initState() {
    super.initState();
    _filteredCountries = widget.countries;
  }

  void _filterCountries(String query) {
    setState(() {
      _filteredCountries = widget.countries
          .where((country) =>
              country.name.toLowerCase().contains(query.toLowerCase()) ||
              country.dialCode.contains(query) ||
              country.code.toLowerCase().contains(query.toLowerCase()) ||
              country.nameTranslations.values.any(
                  (name) => name.toLowerCase().contains(query.toLowerCase())))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(
          horizontal: MediaQuery.sizeOf(context).width * 0.07),
      title: TextField(
        onChanged: _filterCountries,
        decoration: const InputDecoration(
          hintText: 'Search',
          prefixIcon: Icon(Icons.search),
        ),
      ),
      content: SizedBox(
        width: double.maxFinite,
        height: 400, // Restrict dialog height
        child: _filteredCountries.isEmpty
            ? const Center(child: Text("No countries found"))
            : ListView.builder(
                itemCount: _filteredCountries.length,
                itemBuilder: (context, index) {
                  final country = _filteredCountries[index];
                  return ListTile(
                    onTap: () {
                      widget.onSelect(country);
                      // Navigator.pop(context);
                    },
                    leading: Text(country.flag,
                        style: const TextStyle(
                          fontSize: 25,
                        )),
                    title: Text(
                      country.localizedName(
                        widget.languageCode,
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: Text("${country.dialCode}+",
                        style: const TextStyle(fontSize: 16)),
                  );
                },
              ),
      ),
    );
  }
}
