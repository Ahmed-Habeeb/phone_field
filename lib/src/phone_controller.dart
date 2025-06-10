import 'package:flutter/foundation.dart';
import '../models/country_model.dart';
import '../utils/phone_validator.dart';

/// A controller that manages the state of phone input
class PhoneController extends ChangeNotifier {
  Country? _selectedCountry;
  String _phoneNumber = '';
  bool _isValid = false;
  String? _errorMessage;
  final List<Country> _recentCountries = [];
  final List<Country> _favoriteCountries = [];
  final List<Country> _countries;

  /// Creates a [PhoneController]
  PhoneController({List<Country>? countries}) : _countries = countries ?? [];

  /// The currently selected country
  Country? get selectedCountry => _selectedCountry;

  /// The current phone number
  String get phoneNumber => _phoneNumber;

  /// Whether the current phone number is valid
  bool get isValid => _isValid;

  /// The current error message, if any
  String? get errorMessage => _errorMessage;

  /// List of recently used countries
  List<Country> get recentCountries => List.unmodifiable(_recentCountries);

  /// List of favorite countries
  List<Country> get favoriteCountries => List.unmodifiable(_favoriteCountries);

  /// List of all available countries
  List<Country> get countries => List.unmodifiable(_countries);

  /// Sets the selected country
  void setCountry(Country country) {
    if (_selectedCountry != country) {
      _selectedCountry = country;
      _addToRecentCountries(country);
      _validatePhoneNumber();
      notifyListeners();
    }
  }

  /// Sets the phone number
  void setPhoneNumber(String number) {
    if (_phoneNumber != number) {
      _phoneNumber = number;
      _validatePhoneNumber();
      notifyListeners();
    }
  }

  /// Toggles a country in the favorite list
  void toggleFavoriteCountry(Country country) {
    final index = _favoriteCountries.indexWhere((c) => c.code == country.code);
    if (index >= 0) {
      _favoriteCountries.removeAt(index);
    } else {
      _favoriteCountries.add(country);
    }
    notifyListeners();
  }

  /// Checks if a country is in the favorite list
  bool isFavoriteCountry(Country country) {
    return _favoriteCountries.any((c) => c.code == country.code);
  }

  /// Gets the formatted phone number
  String getFormattedNumber() {
    if (_selectedCountry == null || _phoneNumber.isEmpty) {
      return '';
    }
    return PhoneValidator.formatPhoneNumber(_phoneNumber, _selectedCountry!.code);
  }

  /// Gets the type of the phone number (mobile/landline)
  String getNumberType() {
    if (_selectedCountry == null || _phoneNumber.isEmpty) {
      return 'unknown';
    }
    return PhoneValidator.getPhoneNumberType(_phoneNumber, _selectedCountry!.code);
  }

  /// Validates the current phone number
  void _validatePhoneNumber() {
    if (_selectedCountry == null || _phoneNumber.isEmpty) {
      _isValid = false;
      _errorMessage = null;
      return;
    }

    final error = PhoneValidator.validatePhoneNumber(_phoneNumber, _selectedCountry!.code);
    _isValid = error == PhoneValidationError.none;
    _errorMessage = PhoneValidator.getErrorMessage(error, _selectedCountry!.code);
  }

  /// Adds a country to the recent countries list
  void _addToRecentCountries(Country country) {
    // Remove if already exists
    _recentCountries.removeWhere((c) => c.code == country.code);
    // Add to the beginning
    _recentCountries.insert(0, country);
    // Keep only the last 5
    if (_recentCountries.length > 5) {
      _recentCountries.removeLast();
    }
  }

  @override
  void dispose() {
    _recentCountries.clear();
    _favoriteCountries.clear();
    super.dispose();
  }
} 