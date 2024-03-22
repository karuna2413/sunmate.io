import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sunmate/constants/colors_contant.dart';
import 'package:sunmate/providers/auth_provider.dart';
import '../../main.dart';
import '../../models/language.dart';
import '../../providers/theme_provider.dart';

class LanguageSelect extends StatefulWidget {
  const LanguageSelect({super.key});

  @override
  State<LanguageSelect> createState() => _LanguageSelectState();
}

class _LanguageSelectState extends State<LanguageSelect> {
  Future<void> _changeLanguage(Language language) async {
    print(language.flage);
    Locale _temp;
    switch (language.languageCode) {
      case 'en':
        _temp = Locale(language.languageCode, "US");
        break;
      case 'da':
        _temp = Locale(language.languageCode, "DA");
        break;
      default:
        _temp = Locale(language.languageCode, "US");
    }

    final pref = await SharedPreferences.getInstance();
    await pref.setString('language', language.languageCode);
    Provider.of<AuthProvider>(context, listen: false).updateLanguage();
    MyApp.setLocale(context, _temp);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ModelTheme>(
        builder: (context, ModelTheme themeNotifier, child) {
      return DropdownButton(
        dropdownColor: getColors(themeNotifier.isDark, 'inputColor'),
        underline: SizedBox(),
        onChanged: (Language? language) {
          if (language != null) {
            _changeLanguage(language);
          }
        },
        icon: Icon(Icons.language,
            color: getColors(themeNotifier.isDark, 'textColor')),
        items: Language.languageList()
            .map<DropdownMenuItem<Language>>(
              (lang) => DropdownMenuItem<Language>(
                value: lang,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(lang.flage,
                        style: TextStyle(
                            color:
                                getColors(themeNotifier.isDark, 'textColor'))),
                    Text(lang.name,
                        style: TextStyle(
                            color:
                                getColors(themeNotifier.isDark, 'textColor'))),
                  ],
                ),
              ),
            )
            .toList(),
      );
    });
  }
}
