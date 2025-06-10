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

# Smart Phone Field

A smart and customizable Flutter package for phone number input with country selection, validation, and formatting.

[![pub package](https://img.shields.io/pub/v/smart_phone_field.svg)](https://pub.dev/packages/smart_phone_field)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Features

- 📱 Smart phone number input with country selection
- 🌍 200+ countries with flags and dial codes
- ✅ Real-time validation and formatting
- 🎨 Highly customizable UI
- 🔍 Search functionality for countries
- ⭐ Favorite and recent countries
- 📦 Persistent storage for user preferences
- 🌐 Internationalization support
- 📝 E.164 format support

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  smart_phone_field: ^1.0.0
```

## Usage

The package provides two ways to implement phone input:

1. **PhoneInputField**: A pre-built widget with a complete UI
2. **PhoneInputBuilder**: A flexible builder for custom UI implementation

### Using PhoneInputField (Pre-built UI)

```dart
import 'package:smart_phone_field/smart_phone_field.dart';

// Basic usage
PhoneInputField(
  controller: PhoneController(),
  onChanged: (number) {
    print('Phone number: $number');
  },
)

// Advanced usage with all features
PhoneInputField(
  controller: PhoneController(),
  // UI Customization
  showCountryFlag: true,
  showCountryCode: true,
  showValidationMessage: true,
  
  // Features
  enableFavoriteCountries: true,
  enableRecentCountries: true,
  enableE164Format: true,
  
  // Callbacks
  onChanged: (number) {
    print('Phone number: $number');
  },
  onCountryChanged: (country) {
    print('Selected country: ${country.name}');
  },
  onValidated: (isValid) {
    print('Is valid: $isValid');
  },
)
```

### Using PhoneInputBuilder (Custom UI)

The `PhoneInputBuilder` gives you complete control over the UI while handling all the phone input logic:

```dart
PhoneInputBuilder(
  controller: PhoneController(),
  onChanged: (number) {
    print('Phone number: $number');
  },
  builder: (context, phoneNumber, country, isValid, errorMessage, {
    required onNumberChanged,
    required onCountrySelected,
    required onCountryPickerPressed,
  }) {
    // Build your custom UI here
    return Row(
      children: [
        // Custom country selector
        GestureDetector(
          onTap: onCountryPickerPressed,
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                if (country != null) ...[
                  Text(country.name),
                  SizedBox(width: 8),
                  Text('+${country.dialCode}'),
                ] else
                  Text('Select Country'),
                Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
        SizedBox(width: 8),
        // Custom phone input
        Expanded(
          child: TextField(
            onChanged: onNumberChanged,
            decoration: InputDecoration(
              labelText: 'Phone Number',
              errorText: errorMessage,
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  },
)
```

### Form Integration

```dart
class ContactForm extends StatefulWidget {
  @override
  _ContactFormState createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = PhoneController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Using pre-built widget
          PhoneInputField(
            controller: _phoneController,
            decoration: InputDecoration(
              labelText: 'Phone Number',
              border: OutlineInputBorder(),
            ),
            validator: (phoneNumber) {
              if (phoneNumber == null || !phoneNumber.isValid) {
                return 'Please enter a valid phone number';
              }
              return null;
            },
          ),
          // Or using builder for custom UI
          PhoneInputBuilder(
            controller: _phoneController,
            builder: (context, phoneNumber, country, isValid, errorMessage, {
              required onNumberChanged,
              required onCountrySelected,
              required onCountryPickerPressed,
            }) {
              // Your custom form field implementation
              return YourCustomFormField(
                value: phoneNumber?.number,
                error: errorMessage,
                onChanged: onNumberChanged,
              );
            },
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Process the form
                print('Phone: ${_phoneController.phoneNumber}');
              }
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }
}
```

## API Reference

### PhoneInputField

The pre-built phone input field widget.

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| `controller` | `PhoneController` | Controller for the phone field |
| `decoration` | `InputDecoration` | Decoration for the input field |
| `style` | `TextStyle` | Style for the input text |
| `enabled` | `bool` | Whether the field is enabled |
| `autofocus` | `bool` | Whether to focus the field automatically |
| `showCountryFlag` | `bool` | Whether to show country flag |
| `showCountryCode` | `bool` | Whether to show country code |
| `showValidationMessage` | `bool` | Whether to show validation message |
| `enableFavoriteCountries` | `bool` | Whether to enable favorite countries |
| `enableRecentCountries` | `bool` | Whether to enable recent countries |
| `enableE164Format` | `bool` | Whether to use E.164 format |
| `onChanged` | `Function(PhoneNumber)` | Callback when phone number changes |
| `onCountryChanged` | `Function(Country)` | Callback when country changes |
| `onValidated` | `Function(bool)` | Callback when validation status changes |
| `validator` | `String? Function(PhoneNumber?)` | Custom validation function |

### PhoneInputBuilder

A flexible builder for custom phone input UI.

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| `controller` | `PhoneController` | Controller for the phone field |
| `builder` | `Widget Function(...)` | Builder function for custom UI |
| `onChanged` | `Function(PhoneNumber)` | Callback when phone number changes |
| `onCountryChanged` | `Function(Country)` | Callback when country changes |
| `onValidated` | `Function(bool)` | Callback when validation status changes |
| `validator` | `String? Function(PhoneNumber?)` | Custom validation function |

### PhoneController

Controller for managing phone field state.

#### Methods

| Method | Description |
|--------|-------------|
| `getNumber()` | Get the current phone number |
| `getCountry()` | Get the selected country |
| `setNumber(String)` | Set the phone number |
| `setCountry(Country)` | Set the country |
| `clear()` | Clear the phone number |
| `isValid()` | Check if the phone number is valid |

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [libphonenumber](https://github.com/google/libphonenumber) for phone number validation
- [country_picker](https://pub.dev/packages/country_picker) for country data
- All contributors and users of this package
