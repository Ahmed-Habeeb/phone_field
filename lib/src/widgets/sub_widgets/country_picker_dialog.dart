import 'package:flutter/material.dart';
import '../../models/country.dart';
import '../../storage/storage_service.dart';
import '../../utils/constants.dart';

/// A dialog for selecting a country.
class CountryPickerDialog extends StatefulWidget {
  /// Creates a country picker dialog.
  const CountryPickerDialog({
    super.key,
    required this.onCountrySelected,
    this.enableFavorites = false,
    this.enableRecent = false,
  });

  /// Callback when a country is selected.
  final void Function(Country) onCountrySelected;

  /// Whether to enable favorite countries.
  final bool enableFavorites;

  /// Whether to enable recent countries.
  final bool enableRecent;

  @override
  State<CountryPickerDialog> createState() => _CountryPickerDialogState();
}

class _CountryPickerDialogState extends State<CountryPickerDialog> {
  final _searchController = TextEditingController();
  final _storageService = StorageService();
  List<Country> _filteredCountries = [];
  List<Country> _favoriteCountries = [];
  List<Country> _recentCountries = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadCountries();
    _loadFavorites();
    _loadRecent();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCountries() async {
    final countries = await _storageService.getCountries();
    setState(() {
      _filteredCountries = countries;
    });
  }

  Future<void> _loadFavorites() async {
    if (!widget.enableFavorites) return;
    final favorites = await _storageService.getFavoriteCountries();
    setState(() {
      _favoriteCountries = favorites;
    });
  }

  Future<void> _loadRecent() async {
    if (!widget.enableRecent) return;
    final recent = await _storageService.getRecentCountries();
    setState(() {
      _recentCountries = recent;
    });
  }

  void _handleSearch(String query) {
    setState(() {
      _isSearching = query.isNotEmpty;
      if (_isSearching) {
        _filteredCountries = _storageService.searchCountries(query);
      } else {
        _loadCountries();
      }
    });
  }

  Future<void> _handleCountrySelected(Country country) async {
    if (widget.enableRecent) {
      await _storageService.addRecentCountry(country);
    }
    widget.onCountrySelected(country);
    Navigator.of(context).pop();
  }

  Future<void> _toggleFavorite(Country country) async {
    if (!widget.enableFavorites) return;
    final isFavorite = _favoriteCountries.contains(country);
    if (isFavorite) {
      await _storageService.removeFavoriteCountry(country);
    } else {
      await _storageService.addFavoriteCountry(country);
    }
    await _loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: double.maxFinite,
        height: 400,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Search field
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search countries',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _handleSearch,
            ),
            const SizedBox(height: 16),
            // Country list
            Expanded(
              child: ListView(
                children: [
                  if (widget.enableFavorites && _favoriteCountries.isNotEmpty) ...[
                    const Text(
                      'Favorites',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ..._buildCountryList(_favoriteCountries, true),
                    const Divider(),
                  ],
                  if (widget.enableRecent && _recentCountries.isNotEmpty) ...[
                    const Text(
                      'Recent',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ..._buildCountryList(_recentCountries, false),
                    const Divider(),
                  ],
                  if (!_isSearching) ...[
                    const Text(
                      'All Countries',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  ..._buildCountryList(_filteredCountries, false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCountryList(List<Country> countries, bool isFavorites) {
    return countries.map((country) {
      final isFavorite = _favoriteCountries.contains(country);
      return ListTile(
        leading: Image.asset(
          'assets/flags/${country.code.toLowerCase()}.png',
          width: 24,
          height: 24,
          package: 'phone_field',
        ),
        title: Text(country.name),
        subtitle: Text('+${country.dialCode}'),
        trailing: widget.enableFavorites
            ? IconButton(
                icon: Icon(
                  isFavorite ? Icons.star : Icons.star_border,
                  color: isFavorite ? Colors.amber : null,
                ),
                onPressed: () => _toggleFavorite(country),
              )
            : null,
        onTap: () => _handleCountrySelected(country),
      );
    }).toList();
  }
} 