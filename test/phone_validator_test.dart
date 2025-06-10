import 'package:flutter_test/flutter_test.dart';
import 'package:phone_field/src/utils/phone_validator.dart';

void main() {
  group('PhoneValidator', () {
    group('isValidPhoneNumber', () {
      test('validates US numbers correctly', () {
        expect(PhoneValidator.isValidPhoneNumber('1234567890', 'US'), false); // Invalid area code
        expect(PhoneValidator.isValidPhoneNumber('2345678901', 'US'), true); // Valid mobile
        expect(PhoneValidator.isValidPhoneNumber('12345678901', 'US'), false); // Invalid with country code
        expect(PhoneValidator.isValidPhoneNumber('123456789', 'US'), false); // Too short
        expect(PhoneValidator.isValidPhoneNumber('123456789012', 'US'), false); // Too long
      });

      test('validates UK numbers correctly', () {
        expect(PhoneValidator.isValidPhoneNumber('07123456789', 'GB'), true); // Valid mobile
        expect(PhoneValidator.isValidPhoneNumber('0123456789', 'GB'), true); // Valid landline
        expect(PhoneValidator.isValidPhoneNumber('123456789', 'GB'), false); // Too short
        expect(PhoneValidator.isValidPhoneNumber('123456789012', 'GB'), false); // Too long
      });

      test('validates Indian numbers correctly', () {
        expect(PhoneValidator.isValidPhoneNumber('9876543210', 'IN'), true); // Valid mobile
        expect(PhoneValidator.isValidPhoneNumber('2345678901', 'IN'), true); // Valid landline
        expect(PhoneValidator.isValidPhoneNumber('123456789', 'IN'), false); // Too short
        expect(PhoneValidator.isValidPhoneNumber('12345678901', 'IN'), false); // Too long
      });

      test('validates Chinese numbers correctly', () {
        expect(PhoneValidator.isValidPhoneNumber('13812345678', 'CN'), true); // Valid mobile
        expect(PhoneValidator.isValidPhoneNumber('1234567890', 'CN'), false); // Too short
        expect(PhoneValidator.isValidPhoneNumber('123456789012', 'CN'), false); // Too long
      });

      test('handles generic numbers correctly', () {
        expect(PhoneValidator.isValidPhoneNumber('12345678', 'XX'), true); // Valid length
        expect(PhoneValidator.isValidPhoneNumber('1234567', 'XX'), false); // Too short
        expect(PhoneValidator.isValidPhoneNumber('1234567890123456', 'XX'), false); // Too long
      });
    });

    group('formatPhoneNumber', () {
      test('formats US numbers correctly', () {
        expect(PhoneValidator.formatPhoneNumber('2345678901', 'US'), '+1 (234) 567-8901');
        expect(PhoneValidator.formatPhoneNumber('12345678901', 'US'), '+1 (234) 567-8901');
        expect(PhoneValidator.formatPhoneNumber('123456789', 'US'), '123456789'); // Invalid length
      });

      test('formats UK numbers correctly', () {
        expect(PhoneValidator.formatPhoneNumber('07123456789', 'GB'), '+44 712 345 6789');
        expect(PhoneValidator.formatPhoneNumber('0123456789', 'GB'), '+44 123 456 789');
        expect(PhoneValidator.formatPhoneNumber('123456789', 'GB'), '123456789'); // Invalid length
      });

      test('formats Indian numbers correctly', () {
        expect(PhoneValidator.formatPhoneNumber('9876543210', 'IN'), '+91 98765 43210');
        expect(PhoneValidator.formatPhoneNumber('123456789', 'IN'), '123456789'); // Invalid length
      });

      test('formats Chinese numbers correctly', () {
        expect(PhoneValidator.formatPhoneNumber('13812345678', 'CN'), '+86 138 1234 5678');
        expect(PhoneValidator.formatPhoneNumber('123456789', 'CN'), '123456789'); // Invalid length
      });

      test('formats generic numbers correctly', () {
        expect(PhoneValidator.formatPhoneNumber('123456789', 'XX'), '123 456 789');
        expect(PhoneValidator.formatPhoneNumber('1234567890', 'XX'), '123 456 789 0');
        expect(PhoneValidator.formatPhoneNumber('123', 'XX'), '123');
      });
    });

    group('getPhoneNumberType', () {
      test('identifies US number types correctly', () {
        expect(PhoneValidator.getPhoneNumberType('2345678901', 'US'), 'mobile');
        expect(PhoneValidator.getPhoneNumberType('2345678901', 'US'), 'landline');
        expect(PhoneValidator.getPhoneNumberType('123456789', 'US'), 'unknown'); // Invalid length
      });

      test('identifies UK number types correctly', () {
        expect(PhoneValidator.getPhoneNumberType('07123456789', 'GB'), 'mobile');
        expect(PhoneValidator.getPhoneNumberType('0123456789', 'GB'), 'landline');
        expect(PhoneValidator.getPhoneNumberType('123456789', 'GB'), 'unknown'); // Invalid length
      });

      test('identifies Indian number types correctly', () {
        expect(PhoneValidator.getPhoneNumberType('9876543210', 'IN'), 'mobile');
        expect(PhoneValidator.getPhoneNumberType('2345678901', 'IN'), 'landline');
        expect(PhoneValidator.getPhoneNumberType('123456789', 'IN'), 'unknown'); // Invalid length
      });

      test('handles unknown number types correctly', () {
        expect(PhoneValidator.getPhoneNumberType('123456789', 'XX'), 'unknown');
      });
    });
  });
}
