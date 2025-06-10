import 'package:flutter/material.dart';
import '../models/country.dart';
import '../models/phone_number.dart';
import 'constants.dart';

extension BuildContextPhoneFieldX on BuildContext {
  Country? get selectedCountry => PhoneInputField.of(this)?.controller.selectedCountry;
  String get phoneNumber => PhoneInputField.of(this)?.controller.phoneNumber ?? '';
  bool get isPhoneNumberValid => PhoneInputField.of(this)?.controller.isValid ?? false;
  String? get phoneNumberError => PhoneInputField.of(this)?.controller.errorMessage;
  
  void updatePhoneNumber(String number) {
    PhoneInputField.of(this)?.controller.updatePhoneNumber(number);
  }
  
  void selectCountry(Country country) {
    PhoneInputField.of(this)?.controller.selectCountry(country);
  }
  
  void showCountryPicker() {
    PhoneInputField.of(this)?.showCountryPicker();
  }
}

extension CountryX on Country {
  String get flagAssetPath => '${PhoneFieldConstants.flagAssetPath}${code.toLowerCase()}${PhoneFieldConstants.flagAssetExtension}';
  
  String get displayName => '$name (+$dialCode)';
  
  bool isSameCountry(Country? other) => other?.code == code;
}

extension PhoneNumberX on PhoneNumber {
  String get displayNumber {
    if (nationalFormat != null) return nationalFormat!;
    if (internationalFormat != null) return internationalFormat!;
    if (e164Format != null) return e164Format!;
    return number;
  }
  
  bool get isMobile => type == PhoneFieldConstants.typeMobile;
  bool get isLandline => type == PhoneFieldConstants.typeLandline;
  bool get isTollFree => type == PhoneFieldConstants.typeTollFree;
  
  String get typeDisplay {
    switch (type) {
      case PhoneFieldConstants.typeMobile:
        return 'Mobile';
      case PhoneFieldConstants.typeLandline:
        return 'Landline';
      case PhoneFieldConstants.typeTollFree:
        return 'Toll Free';
      default:
        return 'Unknown';
    }
  }
}

extension StringPhoneX on String {
  String get unformattedPhone => replaceAll(RegExp(r'\D'), '');
  
  bool get isNumeric => RegExp(r'^\d+$').hasMatch(this);
  
  String get e164Format {
    if (startsWith('+')) return this;
    return '+$this';
  }
} 