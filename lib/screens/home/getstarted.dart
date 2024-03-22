import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/colors_contant.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/home/mybutton.dart';
import '../../localization/localization_contants.dart';

class FirstHomePage extends StatefulWidget {
  const FirstHomePage({super.key});

  @override
  State<FirstHomePage> createState() => _FirstHomePageState();
}

class _FirstHomePageState extends State<FirstHomePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ModelTheme>(
        builder: (context, ModelTheme themeNotifier, child) {
      return Scaffold(
        backgroundColor: getColors(themeNotifier.isDark, 'backgroundColor'),
        body: Padding(
          padding:
              const EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
          child: Container(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Center(
                    child: Container(
                  margin: const EdgeInsets.all(30),
                  child: Image.asset(
                    'assets/images/${getLogo(themeNotifier.isDark)}',
                  ),
                )),
                SizedBox(
                  height: 25,
                ),
                Center(
                    child: Image.asset(
                        'assets/images/${getHome(themeNotifier.isDark)}')),
                SizedBox(
                  height: 25,
                ),
                Text(
                  getTranslated(context, 'k_home_energy'),
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                      color: getColors(themeNotifier.isDark, 'textColor')),
                ),
                Text(
                  "Maximize solar efficiency with SunMate.IO. Enjoy smart EV charging"
                  "adjusting power based on solar availability. Optimize battery use,"
                  "charging or discharging to cut costs. All in a user-friendly app.",
                  softWrap: true,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    color: getColors(themeNotifier.isDark, 'GreyTextColor'),
                    fontSize: 16,
                  ),
                ),
                Expanded(
                  child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 0, right: 0, top: 0, bottom: 30),
                        child: MyButton(
                          text: getTranslated(context, 'k_home_started'),
                          onTap: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/login', (Route<dynamic> route) => false);
                          },
                        ),
                      )),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
