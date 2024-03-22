class Language {
  final int id;
  final String name;
  final String flage;
  final String languageCode;

  Language(this.id, this.name, this.flage, this.languageCode);

  static List<Language> languageList() {
    return <Language>[
      Language(1, 'English', '🇺🇸', 'en'),
      Language(2,  'Danish','🇩🇰', 'da'),
    ];
  }

}
