<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

# Custom Phone Field

[![pub package](https://img.shields.io/pub/v/custom_phone_field.svg)](https://pub.dev/packages/custom_phone_field)
[![license](https://img.shields.io/github/license/habeeb/custom_phone_field.svg)](https://github.com/habeeb/custom_phone_field/blob/main/LICENSE)

A beautiful and customizable phone number input field for Flutter applications. This package provides a ready-to-use phone input field with country selection, validation, and customization options.

## Features

- 🌍 Country selection with flags and dial codes
- 📱 Phone number validation with country-specific rules
- 🎨 Two widget options: `CustomPhoneInput` (pre-built) and `PhoneField` (customizable)
- 🔄 Form integration with validation
- 🌐 Internationalization support (20+ languages)
- ♿ Accessibility support
- 📦 Lightweight and easy to use

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  custom_phone_field: ^1.0.1
```

## Quick Start

### Using CustomPhoneInput (Pre-built Widget)

```dart
import 'package:custom_phone_field/custom_phone_field.dart';

CustomPhoneInput(
  initialCountry: 'US',
  onCountryChanged: (country) {
    print('Selected country: ${country.name}');
  },
  onPhoneNumberChanged: (phoneNumber) {
    print('Phone number: $phoneNumber');
  },
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a phone number';
    }
    return null;
  },
)
```

### Using PhoneField (Customizable Widget)

```dart
import 'package:custom_phone_field/custom_phone_field.dart';

PhoneField(
  initialCountry: 'US',
  onCountryChanged: (country) {
    print('Selected country: ${country.name}');
  },
  builder: (context, country, openPicker) {
    return Row(
      children: [
        // Country selector
        GestureDetector(
          onTap: openPicker,
          child: Container(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Text('+${country.dialCode}'),
                Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
        // Phone input
        Expanded(
          child: TextField(
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: 'Enter phone number',
            ),
          ),
        ),
      ],
    );
  },
)
```

## Available Widgets

### 1. CustomPhoneInput

A pre-built, ready-to-use phone input field with common customizations.

```dart
CustomPhoneInput({
  Key? key,
  String initialCountry = 'EG',
  String languageCode = 'en',
  List<String> availableCountries = const [],
  void Function(Country country)? onCountryChanged,
  void Function(String phoneNumber)? onPhoneNumberChanged,
  String? initialValue,
  bool enabled = true,
  bool readOnly = false,
  InputDecoration? decoration,
  TextStyle? style,
  String? Function(String?)? validator,
})
```

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| `initialCountry` | `String` | Initial country code (default: 'EG') |
| `languageCode` | `String` | Language code for localization (default: 'en') |
| `availableCountries` | `List<String>` | List of available country codes |
| `onCountryChanged` | `Function(Country)` | Callback when country is changed |
| `onPhoneNumberChanged` | `Function(String)` | Callback when phone number is changed |
| `initialValue` | `String?` | Initial phone number value |
| `enabled` | `bool` | Whether the field is enabled |
| `readOnly` | `bool` | Whether the field is read-only |
| `decoration` | `InputDecoration?` | Custom input decoration |
| `style` | `TextStyle?` | Custom text style |
| `validator` | `Function(String?)?` | Form validation callback |

### 2. PhoneField

A customizable phone field widget that allows complete control over the UI.

```dart
PhoneField({
  Key? key,
  required Widget Function(
    BuildContext context,
    Country country,
    VoidCallback openPicker,
  ) builder,
  String initialCountry = 'EG',
  String languageCode = 'en',
  List<String> availableCountries = const [],
  void Function(Country country)? onCountryChanged,
})
```

The `PhoneField` widget provides a base implementation that you can customize using the builder pattern. The builder function receives:

- `context`: The current BuildContext
- `country`: The currently selected Country object with properties:
  - `name`: Country name
  - `code`: ISO country code (e.g., 'US')
  - `dialCode`: Country dial code (e.g., '+1')
  - `flag`: Country flag emoji
  - `minLength`: Minimum phone number length
  - `maxLength`: Maximum phone number length
  - `nameTranslations`: Map of country names in different languages
- `openPicker`: A callback function to open the country picker dialog

## Country Model

The `Country` model provides detailed information about each country:

```dart
class Country {
  final String name;
  final Map<String, String> nameTranslations;
  final String flag;
  final String code;
  final String dialCode;
  final String regionCode;
  final int minLength;
  final int maxLength;
  final String pattern;
  final List<String> allowedCharacters;
  final bool requiresAreaCode;
  final String? areaCodePattern;
  final String? exampleNumber;
}
```

## Examples

### Basic Usage with CustomPhoneInput

```dart
CustomPhoneInput(
  onPhoneNumberChanged: (phoneNumber) {
    print('Phone number: $phoneNumber');
  },
)
```

### Form Integration

```dart
final _formKey = GlobalKey<FormState>();

Form(
  key: _formKey,
  child: CustomPhoneInput(
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter a phone number';
      }
      return null;
    },
  ),
)
```

### Custom Styling

```dart
CustomPhoneInput(
  initialCountry: 'US',
  style: TextStyle(
    fontSize: 16,
    color: Colors.black87,
  ),
  decoration: InputDecoration(
    labelText: 'Phone Number',
    hintText: 'Enter your phone number',
    prefixIcon: Icon(Icons.phone),
  ),
)
```

### Restricted Countries

```dart
CustomPhoneInput(
  availableCountries: ['US', 'CA', 'GB', 'AU'],
  initialCountry: 'US',
)
```

### Custom Implementation with PhoneField

```dart
PhoneField(
  initialCountry: 'US',
  onCountryChanged: (country) {
    print('Selected country: ${country.name}');
  },
  builder: (context, country, openPicker) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Country flag and code
          GestureDetector(
            onTap: openPicker,
            child: Container(
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  Text(country.flag),
                  SizedBox(width: 8),
                  Text('+${country.dialCode}'),
                ],
              ),
            ),
          ),
          // Phone input
          Expanded(
            child: TextField(
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter phone number',
              ),
            ),
          ),
        ],
      ),
    );
  },
)
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

Copyright (c) 2025 Habeeb

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Country flags from [flag-icons](https://github.com/lipis/flag-icons)
- Phone number validation patterns from [libphonenumber](https://github.com/google/libphonenumber)

## Support

If you find this package helpful, please give it a star on GitHub and share it with others!

For issues and feature requests, please use the [GitHub issue tracker](https://github.com/habeeb/custom_phone_field/issues).
