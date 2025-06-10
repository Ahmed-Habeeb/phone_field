class PhoneNumber {
  final String number;
  final String countryCode;
  final String? e164Format;
  final String? nationalFormat;
  final String? internationalFormat;
  final String type; // 'mobile', 'landline', 'toll-free'
  final bool isValid;

  const PhoneNumber({
    required this.number,
    required this.countryCode,
    this.e164Format,
    this.nationalFormat,
    this.internationalFormat,
    this.type = 'unknown',
    this.isValid = false,
  });

  factory PhoneNumber.fromJson(Map<String, dynamic> json) {
    return PhoneNumber(
      number: json['number'] as String,
      countryCode: json['countryCode'] as String,
      e164Format: json['e164Format'] as String?,
      nationalFormat: json['nationalFormat'] as String?,
      internationalFormat: json['internationalFormat'] as String?,
      type: json['type'] as String? ?? 'unknown',
      isValid: json['isValid'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'countryCode': countryCode,
      if (e164Format != null) 'e164Format': e164Format,
      if (nationalFormat != null) 'nationalFormat': nationalFormat,
      if (internationalFormat != null) 'internationalFormat': internationalFormat,
      'type': type,
      'isValid': isValid,
    };
  }

  PhoneNumber copyWith({
    String? number,
    String? countryCode,
    String? e164Format,
    String? nationalFormat,
    String? internationalFormat,
    String? type,
    bool? isValid,
  }) {
    return PhoneNumber(
      number: number ?? this.number,
      countryCode: countryCode ?? this.countryCode,
      e164Format: e164Format ?? this.e164Format,
      nationalFormat: nationalFormat ?? this.nationalFormat,
      internationalFormat: internationalFormat ?? this.internationalFormat,
      type: type ?? this.type,
      isValid: isValid ?? this.isValid,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PhoneNumber &&
        other.number == number &&
        other.countryCode == countryCode &&
        other.e164Format == e164Format &&
        other.nationalFormat == nationalFormat &&
        other.internationalFormat == internationalFormat &&
        other.type == type &&
        other.isValid == isValid;
  }

  @override
  int get hashCode => Object.hash(
        number,
        countryCode,
        e164Format,
        nationalFormat,
        internationalFormat,
        type,
        isValid,
      );

  @override
  String toString() => 'PhoneNumber(number: $number, countryCode: $countryCode, type: $type, isValid: $isValid)';
} 