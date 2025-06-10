import 'package:equatable/equatable.dart';
import 'package:libphonenumber/libphonenumber.dart';

class Country extends Equatable {
  final String name;
  final Map<String, String> nameTranslations;
  final String flag;
  final String code;
  final String dialCode;
  final String regionCode;
  final int minLength;
  final int maxLength;
  final List<String>? validPrefixes;
  final List<String>? validSuffixes;
  final Map<String, dynamic>? validationRules;
  final String? flagUrl;
  final String? region;
  final String? subRegion;
  final bool isMobileOnly;
  final bool isLandlineOnly;
  final bool isTollFree;

  const Country({
    required this.name,
    required this.flag,
    required this.code,
    required this.dialCode,
    required this.nameTranslations,
    required this.minLength,
    required this.maxLength,
    this.regionCode = "",
    this.validPrefixes,
    this.validSuffixes,
    this.validationRules,
    this.flagUrl,
    this.region,
    this.subRegion,
    this.isMobileOnly = false,
    this.isLandlineOnly = false,
    this.isTollFree = false,
  });

  String get fullCountryCode => dialCode + regionCode;

  String get displayCC => regionCode.isNotEmpty ? "$dialCode $regionCode" : dialCode;

  String localizedName(String languageCode) => nameTranslations[languageCode] ?? name;

  Future<bool> isValidPhoneNumber(String phone) async {
    try {
      // Basic length validation
      if (phone.length < minLength || phone.length > maxLength) {
        return false;
      }

      // Prefix validation if specified
      if (validPrefixes != null && validPrefixes!.isNotEmpty) {
        final hasValidPrefix = validPrefixes!.any((prefix) => phone.startsWith(prefix));
        if (!hasValidPrefix) return false;
      }

      // Suffix validation if specified
      if (validSuffixes != null && validSuffixes!.isNotEmpty) {
        final hasValidSuffix = validSuffixes!.any((suffix) => phone.endsWith(suffix));
        if (!hasValidSuffix) return false;
      }

      // Use libphonenumber for advanced validation
      final isValid = await PhoneNumberUtil.isValidPhoneNumber(
        phoneNumber: phone,
        isoCode: code,
      );

      if (!isValid) return false;

      // Additional validation rules if specified
      if (validationRules != null) {
        // Implement custom validation rules here
        // Example: Check for specific patterns, ranges, etc.
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String> formatPhoneNumber(String phone) async {
    try {
      final formatted = await PhoneNumberUtil.formatAsYouType(
        phoneNumber: phone,
        isoCode: code,
      );
      return formatted;
    } catch (e) {
      return phone;
    }
  }

  Future<PhoneNumberType> getPhoneNumberType(String phone) async {
    try {
      final type = await PhoneNumberUtil.getNumberType(
        phoneNumber: phone,
        isoCode: code,
      );
      return type;
    } catch (e) {
      return PhoneNumberType.UNKNOWN;
    }
  }

  @override
  List<Object?> get props => [
        name,
        flag,
        code,
        dialCode,
        nameTranslations,
        minLength,
        maxLength,
        regionCode,
        validPrefixes,
        validSuffixes,
        validationRules,
        flagUrl,
        region,
        subRegion,
        isMobileOnly,
        isLandlineOnly,
        isTollFree,
      ];

  Country copyWith({
    String? name,
    Map<String, String>? nameTranslations,
    String? flag,
    String? code,
    String? dialCode,
    String? regionCode,
    int? minLength,
    int? maxLength,
    List<String>? validPrefixes,
    List<String>? validSuffixes,
    Map<String, dynamic>? validationRules,
    String? flagUrl,
    String? region,
    String? subRegion,
    bool? isMobileOnly,
    bool? isLandlineOnly,
    bool? isTollFree,
  }) {
    return Country(
      name: name ?? this.name,
      nameTranslations: nameTranslations ?? this.nameTranslations,
      flag: flag ?? this.flag,
      code: code ?? this.code,
      dialCode: dialCode ?? this.dialCode,
      regionCode: regionCode ?? this.regionCode,
      minLength: minLength ?? this.minLength,
      maxLength: maxLength ?? this.maxLength,
      validPrefixes: validPrefixes ?? this.validPrefixes,
      validSuffixes: validSuffixes ?? this.validSuffixes,
      validationRules: validationRules ?? this.validationRules,
      flagUrl: flagUrl ?? this.flagUrl,
      region: region ?? this.region,
      subRegion: subRegion ?? this.subRegion,
      isMobileOnly: isMobileOnly ?? this.isMobileOnly,
      isLandlineOnly: isLandlineOnly ?? this.isLandlineOnly,
      isTollFree: isTollFree ?? this.isTollFree,
    );
  }
}
