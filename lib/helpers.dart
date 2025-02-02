import 'package:intl_phone_field/countries.dart';

bool isNumeric(String s) =>
    s.isNotEmpty && int.tryParse(s.replaceAll("+", "")) != null;

String removeDiacritics(String str) {
  var withDia =
      'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž';
  var withoutDia =
      'AAAAAAaaaaaaOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuNnSsYyyZz';

  for (int i = 0; i < withDia.length; i++) {
    str = str.replaceAll(withDia[i], withoutDia[i]);
  }

  return str;
}

bool validate(String value, String countryCode) {
  Set egypt = {'10', '11', '12', '15'};
  Set saudiArabia = {'17', '13', '11', '16', '12', '14'};
  //validate to egypt and saudi arabia to check in egypt must start with 10 ,11 ,12 and 15
  switch (countryCode) {
    case 'EG':
      return (egypt.contains(value.substring(0, 2)));

    case 'SA':
      return (saudiArabia.contains(value.substring(0, 2)));

    default:
      return false;
  }
}

extension CountryExtensions on List<Country> {
  List<Country> stringSearch(String search) {
    search = removeDiacritics(search.toLowerCase());
    return where(
      (country) => isNumeric(search) || search.startsWith("+")
          ? country.dialCode.contains(search)
          : removeDiacritics(country.name.replaceAll("+", "").toLowerCase())
                  .contains(search) ||
              country.nameTranslations.values.any((element) =>
                  removeDiacritics(element.toLowerCase()).contains(search)),
    ).toList();
  }
}
