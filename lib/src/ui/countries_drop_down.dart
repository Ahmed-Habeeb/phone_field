import 'package:flutter/material.dart';

import '../models/country_model.dart';
import '../helpers/countries.dart';

class CountriesDropDown extends StatefulWidget {
  final Function(Country) onSelect;
  final Country? selectedCountry;
  final String languageCode;
  final double maxHeight;
  final String hintText;
  final TextStyle? hintStyle;
  final Widget Function(BuildContext, Country, VoidCallback)? builder;

  const CountriesDropDown({
    super.key,
    required this.onSelect,
    required this.languageCode,
    this.builder,
    this.maxHeight = 300,
    this.selectedCountry,
    this.hintText = 'Select a country',
    this.hintStyle,
  });

  @override
  State<CountriesDropDown> createState() => _CountriesDropDownState();
}

class _CountriesDropDownState extends State<CountriesDropDown> {
  late List<Country> _filteredCountries;
  bool _isExpanded = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredCountries = countries;
  }

  void _filterCountries(String query) {
    setState(() {
      _filteredCountries = countries
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
    return Column(
      children: [
        GestureDetector(
          onTap: () => setState(() => _isExpanded = !_isExpanded),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.selectedCountry == null
                    ? widget.hintText
                    : widget.selectedCountry!
                        .localizedName(widget.languageCode)),
                Icon(_isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
        if (_isExpanded)
          Container(
            height: 300,
            margin: const EdgeInsets.only(top: 5),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _filterCountries,
                    decoration: InputDecoration(
                      hintText: 'Search country',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  _searchController.clear();
                                  _filteredCountries = countries;
                                });
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: _filteredCountries.isEmpty
                      ? const Center(child: Text("No countries found"))
                      : ListView.builder(
                          itemCount: _filteredCountries.length,
                          itemBuilder: (context, index) {
                            final country = _filteredCountries[index];
                            return widget.builder != null
                                ? widget.builder!(context, country, () {
                                    widget.onSelect(country);
                                    setState(() => _isExpanded = false);
                                  })
                                : ListTile(
                                    onTap: () {
                                      widget.onSelect(country);
                                      setState(() => _isExpanded = false);
                                    },
                                    leading: Text(
                                      country.flag,
                                      style: const TextStyle(fontSize: 25),
                                    ),
                                    title: Text(
                                      country
                                          .localizedName(widget.languageCode),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    trailing: Text(
                                      "${country.dialCode}+",
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  );
                          },
                        ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
