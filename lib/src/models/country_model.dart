/// Represents a country with its associated phone number information
/// and validation rules.
class Country {
  /// The name of the country
  final String name;

  /// Translations of the country name in different languages
  final Map<String, String> nameTranslations;

  /// The flag emoji or flag image path for the country
  final String flag;

  /// The ISO country code (e.g., 'US', 'GB')
  final String code;

  /// The country's dial code (e.g., '+1', '+44')
  final String dialCode;

  /// Optional region code for countries with multiple regions
  final String regionCode;

  /// Minimum length of valid phone numbers for this country
  final int minLength;

  /// Maximum length of valid phone numbers for this country
  final int maxLength;

  /// Regular expression pattern for phone number validation
  final String pattern;

  /// List of characters allowed in phone numbers
  final List<String> allowedCharacters;

  /// Whether the country requires an area code
  final bool requiresAreaCode;

  /// Pattern for validating area codes
  final String? areaCodePattern;

  /// Example phone number format for this country
  final String? exampleNumber;

  /// Creates a new Country instance
  const Country({
    required this.name,
    required this.flag,
    required this.code,
    required this.dialCode,
    required this.nameTranslations,
    required this.minLength,
    required this.maxLength,
    this.regionCode = "",
    this.pattern = "",
    this.allowedCharacters = const [
      '0',
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9'
    ],
    this.requiresAreaCode = false,
    this.areaCodePattern,
    this.exampleNumber,
  });

  /// Returns the full country code combining dial code and region code
  String get fullCountryCode {
    return dialCode + regionCode;
  }

  /// Returns the display format of the country code
  String get displayCC {
    if (regionCode.isNotEmpty) {
      return "$dialCode $regionCode";
    }
    return dialCode;
  }

  /// Validates a phone number against country-specific rules
  bool isValidPhoneNumber(String number) {
    if (number.isEmpty) return false;

    // Remove all non-digit characters
    final cleanedNumber = number.replaceAll(RegExp(r'[^\d]'), '');

    // Check length requirements
    if (cleanedNumber.length < minLength || cleanedNumber.length > maxLength) {
      return false;
    }

    // Check pattern if provided
    if (pattern.isNotEmpty) {
      final regex = RegExp(pattern);
      if (!regex.hasMatch(cleanedNumber)) {
        return false;
      }
    }

    return true;
  }

  /// Formats a phone number according to country-specific rules
  String formatPhoneNumber(String number) {
    if (number.isEmpty) return number;

    // Remove all non-digit characters
    final cleanedNumber = number.replaceAll(RegExp(r'[^\d]'), '');

    // Format the number based on pattern
    if (pattern.isNotEmpty) {
      final regex = RegExp(pattern);
      final match = regex.firstMatch(cleanedNumber);
      if (match != null) {
        return match.group(0) ?? cleanedNumber;
      }
    }

    // Default formatting
    return cleanedNumber;
  }

  /// Gets the localized name of the country
  String getDisplayName(String locale) {
    return nameTranslations[locale] ?? name;
  }

  /// Gets the localized name of the country (deprecated)
  @Deprecated('Use getDisplayName instead')
  String localizedName(String languageCode) {
    return nameTranslations[languageCode] ?? name;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Country &&
        other.name == name &&
        other.flag == flag &&
        other.code == code &&
        other.dialCode == dialCode &&
        other.regionCode == regionCode &&
        other.minLength == minLength &&
        other.maxLength == maxLength &&
        other.pattern == pattern &&
        other.allowedCharacters == allowedCharacters &&
        other.requiresAreaCode == requiresAreaCode &&
        other.areaCodePattern == areaCodePattern &&
        other.exampleNumber == exampleNumber;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        flag.hashCode ^
        code.hashCode ^
        dialCode.hashCode ^
        regionCode.hashCode ^
        minLength.hashCode ^
        maxLength.hashCode ^
        pattern.hashCode ^
        allowedCharacters.hashCode ^
        requiresAreaCode.hashCode ^
        areaCodePattern.hashCode ^
        exampleNumber.hashCode;
  }
}
