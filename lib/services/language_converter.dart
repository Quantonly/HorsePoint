class LanguageConverter {
  final List<String> languages = [
    'English',
    'Nederlands',
    'Français',
    'Deutsch'
  ];

  final List<String> abbreviations = [
    'en',
    'nl',
    'fr',
    'de'
  ];

  String getLanguage(abbreviation) {
    return languages[abbreviations.indexOf(abbreviation)];
  }

  String getAbbreviation(language) {
    return abbreviations[languages.indexOf(language)];
  }
}