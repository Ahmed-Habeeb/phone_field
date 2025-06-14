# Changelog

All notable changes to the `custom_phone_field` package will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).
## [1.0.4] - 2024-03-19

### Changed
- Updated package metadata
- hot fixes for minor issues
## [1.0.3] - 2024-03-19

### Changed
- Optimized package size by removing unused code
- Cleaned up internal implementation
- Improved code organization
- Enhanced code readability

### Removed
- Removed unused dependencies
- Removed redundant code comments
- Removed unused imports
- Removed deprecated code patterns

### Fixed
- Code style improvements
- Removed potential memory leaks
- Optimized widget rebuilds
- Improved performance

## [1.0.2] - 2024-03-19

### Added
- Added `TextEditingController` support to `CustomPhoneInput` widget
- New `controller` property for programmatic control of the phone input field
- Updated documentation with controller usage examples

### Changed
- Updated README to include controller property documentation
- Enhanced examples to demonstrate controller usage

## [1.0.1] - 2024-03-19

### Changed
- Updated documentation to accurately reflect implementation details
- Improved README with more comprehensive examples
- Added detailed Country model documentation
- Enhanced widget property descriptions
- Updated installation instructions
- Added more practical usage examples
- Improved code snippets for better understanding

### Fixed
- Documentation inconsistencies
- Missing property descriptions
- Incomplete example code
- Outdated feature list

## [1.0.0] - 2024-03-19

### Added
- Initial release of the custom phone field package
- Two widget options:
  - `CustomPhoneInput`: A pre-built, ready-to-use phone input field
  - `PhoneField`: A customizable widget for complete UI control
- Country selection with flags and dial codes
- Phone number validation with country-specific rules
- Form integration with validation support
- Internationalization support (20+ languages)
- Accessibility features
- Comprehensive documentation and examples
- MIT License

### Features
- Country picker dialog with search functionality
- Country-specific phone number validation
- Support for 200+ countries with:
  - Country names in multiple languages
  - Country flags
  - Dial codes
  - Phone number patterns
  - Minimum and maximum length validation
  - Area code requirements
  - Example numbers
- Customizable UI components
- Form field integration
- Input validation
- Keyboard type optimization
- Error handling
- Callback support for country and phone number changes

### Technical Details
- Built with Flutter
- Null safety support
- Lightweight implementation
- No external dependencies
- Well-documented code
- Comprehensive test coverage
- Example app included
