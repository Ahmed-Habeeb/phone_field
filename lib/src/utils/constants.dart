class PhoneFieldConstants {
  // Storage keys
  static const String recentCountriesKey = 'phone_field_recent_countries';
  static const String favoriteCountriesKey = 'phone_field_favorite_countries';
  static const String preferencesKey = 'phone_field_preferences';
  
  // Limits
  static const int maxRecentCountries = 10;
  static const int maxFavoriteCountries = 20;
  
  // Default values
  static const String defaultCountryCode = 'US';
  static const int defaultMaxLength = 15;
  
  // Phone number types
  static const String typeMobile = 'mobile';
  static const String typeLandline = 'landline';
  static const String typeTollFree = 'toll-free';
  static const String typeUnknown = 'unknown';
  
  // Asset paths
  static const String flagAssetPath = 'assets/flags/';
  static const String flagAssetExtension = '.png';
  
  // Validation
  static const int minPhoneLength = 8;
  static const int maxPhoneLength = 15;
  
  // UI
  static const double defaultFlagSize = 24.0;
  static const double defaultIconSize = 20.0;
  static const double defaultBorderRadius = 8.0;
  static const double defaultPadding = 16.0;
  static const double defaultSpacing = 8.0;
} 