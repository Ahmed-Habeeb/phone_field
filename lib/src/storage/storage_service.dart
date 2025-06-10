import 'dart:convert';
import 'package:shared_preferences.dart';
import 'package:phone_field/phone_validator.dart';

class StorageService {
  static const String _recentCountriesKey = 'phone_field_recent_countries';
  static const String _favoriteCountriesKey = 'phone_field_favorite_countries';
  static const int _maxRecentCountries = 10;

  final SharedPreferences _prefs;

  StorageService(this._prefs);

  static Future<StorageService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return StorageService(prefs);
  }

  // Recent Countries
  Future<List<String>> getRecentCountryCodes() async {
    final json = _prefs.getString(_recentCountriesKey);
    if (json == null) return [];
    try {
      final List<dynamic> list = jsonDecode(json);
      return list.cast<String>();
    } catch (e) {
      return [];
    }
  }

  Future<void> addRecentCountry(Country country) async {
    final codes = await getRecentCountryCodes();
    codes.remove(country.code); // Remove if exists
    codes.insert(0, country.code); // Add to beginning
    if (codes.length > _maxRecentCountries) {
      codes.removeLast(); // Remove oldest
    }
    await _prefs.setString(_recentCountriesKey, jsonEncode(codes));
  }

  Future<void> clearRecentCountries() async {
    await _prefs.remove(_recentCountriesKey);
  }

  // Favorite Countries
  Future<List<String>> getFavoriteCountryCodes() async {
    final json = _prefs.getString(_favoriteCountriesKey);
    if (json == null) return [];
    try {
      final List<dynamic> list = jsonDecode(json);
      return list.cast<String>();
    } catch (e) {
      return [];
    }
  }

  Future<void> addFavoriteCountry(String countryCode) async {
    final codes = await getFavoriteCountryCodes();
    if (!codes.contains(countryCode)) {
      codes.add(countryCode);
      await _prefs.setString(_favoriteCountriesKey, jsonEncode(codes));
    }
  }

  Future<void> removeFavoriteCountry(String countryCode) async {
    final codes = await getFavoriteCountryCodes();
    codes.remove(countryCode);
    await _prefs.setString(_favoriteCountriesKey, jsonEncode(codes));
  }

  Future<void> clearFavoriteCountries() async {
    await _prefs.remove(_favoriteCountriesKey);
  }

  // User Preferences
  Future<void> saveUserPreferences({
    bool? showCountryFlag,
    bool? showCountryCode,
    bool? showValidationMessage,
    bool? enableFavoriteCountries,
    bool? enableRecentCountries,
  }) async {
    final prefs = {
      if (showCountryFlag != null) 'showCountryFlag': showCountryFlag,
      if (showCountryCode != null) 'showCountryCode': showCountryCode,
      if (showValidationMessage != null) 'showValidationMessage': showValidationMessage,
      if (enableFavoriteCountries != null) 'enableFavoriteCountries': enableFavoriteCountries,
      if (enableRecentCountries != null) 'enableRecentCountries': enableRecentCountries,
    };
    await _prefs.setString('phone_field_preferences', jsonEncode(prefs));
  }

  Future<Map<String, dynamic>> getUserPreferences() async {
    final json = _prefs.getString('phone_field_preferences');
    if (json == null) return {};
    try {
      final Map<String, dynamic> prefs = jsonDecode(json);
      return prefs;
    } catch (e) {
      return {};
    }
  }
} 