/// Validation error types for phone numbers
enum PhoneValidationError {
  /// Phone number is too short
  tooShort,

  /// Phone number is too long
  tooLong,

  /// Phone number contains invalid characters
  invalidCharacters,

  /// Phone number has an invalid prefix
  invalidPrefix,

  /// Phone number has an invalid format
  invalidFormat,

  /// Phone number is not supported for the selected country
  notSupported,

  /// No error
  none,
}

/// A utility class for phone number validation and formatting
class PhoneValidator {
  /// Validates a phone number for a given country code
  /// Returns a [PhoneValidationError] indicating the type of error, if any
  static PhoneValidationError validatePhoneNumber(String phone, String countryCode) {
    // Remove any non-digit characters for validation
    final digits = phone.replaceAll(RegExp(r'[^\d]'), '');

    // Check for invalid characters
    if (digits.length != phone.replaceAll(RegExp(r'[^0-9+\-() ]'), '').length) {
      return PhoneValidationError.invalidCharacters;
    }

    // Check length
    if (!_isValidLength(digits, countryCode)) {
      if (digits.length < _getMinLength(countryCode)) {
        return PhoneValidationError.tooShort;
      }
      if (digits.length > _getMaxLength(countryCode)) {
        return PhoneValidationError.tooLong;
      }
    }

    // Check prefix for specific countries
    if (!_isValidPrefix(digits, countryCode)) {
      return PhoneValidationError.invalidPrefix;
    }

    // Check format for specific countries
    if (!_isValidFormat(digits, countryCode)) {
      return PhoneValidationError.invalidFormat;
    }

    // Check if the number type is supported
    if (!_isSupportedNumberType(digits, countryCode)) {
      return PhoneValidationError.notSupported;
    }

    return PhoneValidationError.none;
  }

  /// Gets a user-friendly error message for a validation error
  static String getErrorMessage(PhoneValidationError error, String countryCode) {
    switch (error) {
      case PhoneValidationError.tooShort:
        return 'Phone number is too short for ${_getCountryName(countryCode)}';
      case PhoneValidationError.tooLong:
        return 'Phone number is too long for ${_getCountryName(countryCode)}';
      case PhoneValidationError.invalidCharacters:
        return 'Phone number contains invalid characters';
      case PhoneValidationError.invalidPrefix:
        return 'Invalid prefix for ${_getCountryName(countryCode)}';
      case PhoneValidationError.invalidFormat:
        return 'Invalid format for ${_getCountryName(countryCode)}';
      case PhoneValidationError.notSupported:
        return 'This type of number is not supported for ${_getCountryName(countryCode)}';
      case PhoneValidationError.none:
        return '';
    }
  }

  /// Checks if a phone number is valid for a given country code
  static bool isValidPhoneNumber(String phone, String countryCode) {
    return validatePhoneNumber(phone, countryCode) == PhoneValidationError.none;
  }

  static bool _isValidLength(String digits, String countryCode) {
    // Define valid lengths for different countries
    final validLengths = {
      'US': [10, 11], // US numbers can be 10 or 11 digits
      'GB': [10, 11], // UK numbers can be 10 or 11 digits
      'IN': [10], // Indian numbers are 10 digits
      'CN': [11], // Chinese numbers are 11 digits
      'BR': [10, 11], // Brazilian numbers can be 10 or 11 digits
      'RU': [10, 11], // Russian numbers can be 10 or 11 digits
      'JP': [10, 11], // Japanese numbers can be 10 or 11 digits
      'DE': [10, 11], // German numbers can be 10 or 11 digits
      'FR': [9, 10], // French numbers can be 9 or 10 digits
      'IT': [10, 11], // Italian numbers can be 10 or 11 digits
      'ES': [9], // Spanish numbers are 9 digits
      'CA': [10], // Canadian numbers are 10 digits
      'AU': [9, 10], // Australian numbers can be 9 or 10 digits
      'MX': [10], // Mexican numbers are 10 digits
      'ZA': [9], // South African numbers are 9 digits
      'NG': [10, 11], // Nigerian numbers can be 10 or 11 digits
      'EG': [10, 11], // Egyptian numbers can be 10 or 11 digits
      'SA': [9], // Saudi numbers are 9 digits
      'AE': [9], // UAE numbers are 9 digits
      'TR': [10], // Turkish numbers are 10 digits
      'ID': [10, 11], // Indonesian numbers can be 10 or 11 digits
      'PH': [10], // Philippine numbers are 10 digits
      'VN': [9, 10], // Vietnamese numbers can be 9 or 10 digits
      'TH': [9], // Thai numbers are 9 digits
      'MY': [10, 11], // Malaysian numbers can be 10 or 11 digits
      'SG': [8], // Singaporean numbers are 8 digits
      'KR': [10, 11], // Korean numbers can be 10 or 11 digits
    };

    final lengths = validLengths[countryCode.toUpperCase()] ?? [8, 15]; // Default range
    return lengths.contains(digits.length);
  }

  // Country-specific validation methods
  static bool _isValidUSNumber(String digits) {
    if (digits.length == 11 && digits[0] != '1') return false;
    if (digits.length == 10) {
      // Check area code
      final areaCode = int.parse(digits.substring(0, 3));
      if (areaCode < 200 || areaCode > 999) return false;
    }
    return true;
  }

  static bool _isValidUKNumber(String digits) {
    if (digits.length == 11 && digits[0] != '0') return false;
    if (digits.length == 10) {
      // Check if it starts with a valid UK mobile prefix
      final prefix = digits.substring(0, 2);
      final validPrefixes = ['07', '01', '02', '03'];
      if (!validPrefixes.contains(prefix)) return false;
    }
    return true;
  }

  static bool _isValidIndianNumber(String digits) {
    if (digits.length != 10) return false;
    // Check if it starts with a valid Indian mobile prefix
    final prefix = digits.substring(0, 1);
    if (prefix != '6' && prefix != '7' && prefix != '8' && prefix != '9') return false;
    return true;
  }

  static bool _isValidChineseNumber(String digits) {
    if (digits.length != 11) return false;
    // Check if it starts with a valid Chinese mobile prefix
    final prefix = digits.substring(0, 2);
    final validPrefixes = ['13', '14', '15', '16', '17', '18', '19'];
    if (!validPrefixes.contains(prefix)) return false;
    return true;
  }

  // Add more country-specific validation methods as needed...

  static bool _isValidGenericNumber(String digits, String countryCode) {
    // For countries without specific validation rules
    // Use basic length validation and digit-only check
    return digits.length >= 8 && digits.length <= 15 && digits.contains(RegExp(r'^\d+$'));
  }

  // Format phone number based on country
  static String formatPhoneNumber(String phone, String countryCode) {
    final digits = phone.replaceAll(RegExp(r'[^\d]'), '');
    
    switch (countryCode.toUpperCase()) {
      case 'US':
        return _formatUSNumber(digits);
      case 'GB':
        return _formatUKNumber(digits);
      case 'IN':
        return _formatIndianNumber(digits);
      case 'CN':
        return _formatChineseNumber(digits);
      // Add more country-specific formatting methods as needed...
      default:
        return _formatGenericNumber(digits);
    }
  }

  static String _formatUSNumber(String digits) {
    if (digits.length == 11 && digits[0] == '1') {
      return '+1 (${digits.substring(1, 4)}) ${digits.substring(4, 7)}-${digits.substring(7)}';
    }
    if (digits.length == 10) {
      return '+1 (${digits.substring(0, 3)}) ${digits.substring(3, 6)}-${digits.substring(6)}';
    }
    return digits;
  }

  static String _formatUKNumber(String digits) {
    if (digits.length == 11 && digits[0] == '0') {
      return '+44 ${digits.substring(1, 4)} ${digits.substring(4, 7)} ${digits.substring(7)}';
    }
    if (digits.length == 10) {
      return '+44 ${digits.substring(0, 3)} ${digits.substring(3, 6)} ${digits.substring(6)}';
    }
    return digits;
  }

  static String _formatIndianNumber(String digits) {
    if (digits.length == 10) {
      return '+91 ${digits.substring(0, 5)} ${digits.substring(5)}';
    }
    return digits;
  }

  static String _formatChineseNumber(String digits) {
    if (digits.length == 11) {
      return '+86 ${digits.substring(0, 3)} ${digits.substring(3, 7)} ${digits.substring(7)}';
    }
    return digits;
  }

  static String _formatGenericNumber(String digits) {
    // Generic formatting for other countries
    if (digits.length <= 3) return digits;
    if (digits.length <= 6) return '${digits.substring(0, 3)} ${digits.substring(3)}';
    if (digits.length <= 9) {
      return '${digits.substring(0, 3)} ${digits.substring(3, 6)} ${digits.substring(6)}';
    }
    return '${digits.substring(0, 3)} ${digits.substring(3, 6)} ${digits.substring(6, 9)} ${digits.substring(9)}';
  }

  // Get phone number type (mobile, landline, etc.)
  static String getPhoneNumberType(String phone, String countryCode) {
    final digits = phone.replaceAll(RegExp(r'[^\d]'), '');
    
    switch (countryCode.toUpperCase()) {
      case 'US':
        return _getUSNumberType(digits);
      case 'GB':
        return _getUKNumberType(digits);
      case 'IN':
        return _getIndianNumberType(digits);
      // Add more country-specific type detection as needed...
      default:
        return 'unknown';
    }
  }

  static String _getUSNumberType(String digits) {
    if (digits.length == 11 && digits[0] == '1') {
      digits = digits.substring(1);
    }
    if (digits.length == 10) {
      final prefix = digits.substring(0, 3);
      // Mobile prefixes
      if (['201', '202', '203', '205', '206', '207', '208', '209', '210', '212', '213', '214', '215', '216', '217', '218', '219', '220', '223', '224', '225', '228', '229', '231', '234', '239', '240', '248', '251', '252', '253', '254', '256', '260', '262', '267', '269', '270', '272', '276', '281', '301', '302', '303', '304', '305', '307', '308', '309', '310', '312', '313', '314', '315', '316', '317', '318', '319', '320', '321', '323', '325', '330', '331', '334', '336', '337', '339', '340', '341', '347', '351', '352', '360', '361', '364', '380', '385', '386', '401', '402', '404', '405', '406', '407', '408', '409', '410', '412', '413', '414', '415', '417', '419', '423', '424', '425', '430', '432', '434', '435', '440', '442', '443', '447', '458', '463', '469', '470', '475', '478', '479', '480', '484', '501', '502', '503', '504', '505', '507', '508', '509', '510', '512', '513', '515', '516', '517', '518', '520', '530', '539', '540', '541', '551', '559', '561', '562', '563', '567', '570', '571', '573', '574', '575', '580', '585', '586', '601', '602', '603', '605', '606', '607', '608', '609', '610', '612', '614', '615', '616', '617', '618', '619', '620', '623', '626', '628', '629', '630', '631', '636', '641', '646', '650', '651', '657', '660', '661', '662', '667', '669', '678', '681', '682', '701', '702', '703', '704', '706', '707', '708', '712', '713', '714', '715', '716', '717', '718', '719', '720', '724', '725', '727', '731', '732', '734', '737', '740', '747', '754', '757', '760', '762', '763', '765', '769', '770', '772', '773', '774', '775', '779', '781', '785', '786', '801', '802', '803', '804', '805', '806', '808', '810', '812', '813', '814', '815', '816', '817', '818', '828', '830', '831', '832', '843', '845', '847', '848', '850', '854', '856', '857', '858', '859', '860', '862', '863', '864', '865', '870', '872', '878', '901', '903', '904', '906', '907', '908', '909', '910', '912', '913', '914', '915', '916', '917', '918', '919', '920', '925', '928', '929', '930', '931', '934', '936', '937', '938', '940', '941', '947', '949', '951', '952', '954', '956', '959', '970', '971', '972', '973', '975', '978', '979', '980', '984', '985', '989'].contains(prefix)) {
        return 'mobile';
      }
      // Landline prefixes
      if (['200', '211', '221', '222', '226', '227', '230', '232', '233', '235', '236', '237', '238', '241', '242', '243', '244', '245', '246', '247', '249', '250', '255', '257', '258', '259', '261', '263', '264', '265', '266', '268', '271', '273', '274', '275', '277', '278', '279', '280', '282', '283', '284', '285', '286', '287', '288', '289', '290', '291', '292', '293', '294', '295', '296', '297', '298', '299', '300', '311', '322', '324', '326', '327', '328', '329', '331', '332', '333', '335', '338', '342', '343', '344', '345', '346', '348', '349', '350', '353', '354', '355', '356', '357', '358', '359', '362', '363', '365', '366', '367', '368', '369', '370', '371', '372', '373', '374', '375', '376', '377', '378', '379', '381', '382', '383', '384', '387', '388', '389', '390', '391', '392', '393', '394', '395', '396', '397', '398', '399', '400', '411', '421', '422', '426', '427', '428', '429', '431', '433', '436', '437', '438', '439', '441', '444', '445', '446', '448', '449', '450', '451', '452', '453', '454', '455', '456', '457', '459', '460', '461', '462', '464', '465', '466', '467', '468', '471', '472', '473', '474', '476', '477', '481', '482', '483', '485', '486', '487', '488', '489', '490', '491', '492', '493', '494', '495', '496', '497', '498', '499', '500', '511', '514', '521', '522', '523', '524', '525', '526', '527', '528', '529', '531', '532', '533', '534', '535', '536', '537', '538', '542', '543', '544', '545', '546', '547', '548', '549', '550', '552', '553', '554', '555', '556', '557', '558', '560', '564', '565', '566', '568', '569', '572', '574', '576', '577', '578', '579', '581', '582', '583', '584', '587', '588', '590', '591', '592', '593', '594', '595', '596', '597', '598', '599', '600', '604', '611', '613', '621', '622', '624', '625', '627', '632', '633', '634', '635', '637', '638', '639', '640', '642', '643', '644', '645', '647', '648', '649', '652', '653', '654', '655', '656', '658', '659', '663', '664', '665', '666', '668', '670', '671', '672', '673', '674', '675', '676', '677', '679', '680', '683', '684', '685', '686', '687', '688', '689', '690', '691', '692', '693', '694', '695', '696', '697', '698', '699', '700', '704', '705', '709', '710', '711', '721', '722', '723', '726', '728', '729', '730', '733', '735', '736', '738', '739', '741', '742', '743', '744', '745', '746', '748', '749', '750', '751', '752', '753', '755', '756', '758', '759', '761', '764', '766', '767', '768', '771', '775', '776', '777', '778', '780', '782', '783', '784', '787', '788', '789', '790', '791', '792', '793', '794', '795', '796', '797', '798', '799', '800', '811', '821', '822', '823', '824', '825', '826', '827', '829', '833', '834', '835', '836', '837', '838', '839', '840', '841', '842', '844', '846', '849', '851', '852', '853', '855', '858', '859', '861', '863', '864', '865', '866', '867', '868', '869', '871', '873', '874', '875', '876', '877', '879', '880', '881', '882', '883', '884', '885', '886', '887', '888', '889', '890', '891', '892', '893', '894', '895', '896', '897', '898', '899', '900', '911', '921', '922', '923', '924', '926', '927', '932', '933', '935', '939', '942', '943', '944', '945', '946', '948', '950', '953', '955', '957', '958', '960', '961', '962', '963', '964', '966', '967', '968', '969', '971', '972', '973', '974', '976', '977', '980', '981', '982', '983', '986', '987', '988', '990', '991', '992', '993', '994', '995', '996', '997', '998', '999'].contains(prefix)) {
        return 'landline';
      }
    }
    return 'unknown';
  }

  static String _getUKNumberType(String digits) {
    if (digits.length == 11 && digits[0] == '0') {
      digits = digits.substring(1);
    }
    if (digits.length == 10) {
      final prefix = digits.substring(0, 2);
      // Mobile prefixes
      if (['07'].contains(prefix)) {
        return 'mobile';
      }
      // Landline prefixes
      if (['01', '02', '03'].contains(prefix)) {
        return 'landline';
      }
    }
    return 'unknown';
  }

  static String _getIndianNumberType(String digits) {
    if (digits.length == 10) {
      final prefix = digits.substring(0, 1);
      if (['6', '7', '8', '9'].contains(prefix)) {
        return 'mobile';
      }
      if (['2', '3', '4', '5'].contains(prefix)) {
        return 'landline';
      }
    }
    return 'unknown';
  }

  /// Gets the minimum valid length for a country
  static int _getMinLength(String countryCode) {
    return _validLengths[countryCode]?.first ?? 7;
  }

  /// Gets the maximum valid length for a country
  static int _getMaxLength(String countryCode) {
    return _validLengths[countryCode]?.last ?? 15;
  }

  /// Gets a user-friendly country name
  static String _getCountryName(String countryCode) {
    return _countryNames[countryCode] ?? countryCode;
  }

  /// Checks if a number type is supported for a country
  static bool _isSupportedNumberType(String digits, String countryCode) {
    final type = getPhoneNumberType(digits, countryCode);
    switch (countryCode) {
      case 'US':
        return type == 'mobile' || type == 'landline';
      case 'GB':
        return type == 'mobile' || type == 'landline';
      case 'IN':
        return type == 'mobile' || type == 'landline';
      // Add more country-specific rules as needed
      default:
        return true;
    }
  }

  /// Map of country codes to their names
  static const Map<String, String> _countryNames = {
    'US': 'United States',
    'GB': 'United Kingdom',
    'IN': 'India',
    'CN': 'China',
    'BR': 'Brazil',
    'RU': 'Russia',
    'JP': 'Japan',
    'DE': 'Germany',
    'FR': 'France',
    'IT': 'Italy',
    'ES': 'Spain',
    'CA': 'Canada',
    'AU': 'Australia',
    'MX': 'Mexico',
    'ZA': 'South Africa',
    'NG': 'Nigeria',
    'EG': 'Egypt',
    'SA': 'Saudi Arabia',
    'AE': 'United Arab Emirates',
    'TR': 'Turkey',
    'ID': 'Indonesia',
    'PH': 'Philippines',
    'VN': 'Vietnam',
    'TH': 'Thailand',
    'MY': 'Malaysia',
    'SG': 'Singapore',
    'KR': 'South Korea',
  };
} 