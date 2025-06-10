class Country {
  final String code;
  final String name;
  final String dialCode;
  final String flagAsset;

  const Country({
    required this.code,
    required this.name,
    required this.dialCode,
    required this.flagAsset,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      code: json['code'] as String,
      name: json['name'] as String,
      dialCode: json['dialCode'] as String,
      flagAsset: json['flagAsset'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'dialCode': dialCode,
      'flagAsset': flagAsset,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Country &&
        other.code == code &&
        other.name == name &&
        other.dialCode == dialCode &&
        other.flagAsset == flagAsset;
  }

  @override
  int get hashCode => Object.hash(code, name, dialCode, flagAsset);

  @override
  String toString() => 'Country(code: $code, name: $name, dialCode: $dialCode)';
} 