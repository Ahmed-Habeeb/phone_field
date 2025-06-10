/// A smart and customizable Flutter package for phone number input with country selection.
library smart_phone_field;

// Main widget and builders
export 'src/widgets/phone_input_field.dart';
export 'src/widgets/builders/phone_input_builder.dart';
export 'src/widgets/builders/country_selector_builder.dart';
export 'src/widgets/builders/validation_builder.dart';

// Essential models and controller
export 'src/models/country.dart';
export 'src/models/phone_number.dart';
export 'src/phone_controller.dart';

// Utilities
export 'src/utils/constants.dart';
export 'src/utils/extensions.dart';

// Storage
export 'src/storage/storage_service.dart';

// Core exports
export 'src/phone_validator.dart';

// Enhanced features
export 'src/enhanced/phone_formatter.dart';
export 'src/enhanced/enhanced_phone_field.dart';
export 'src/enhanced/enhanced_country_picker.dart'; 