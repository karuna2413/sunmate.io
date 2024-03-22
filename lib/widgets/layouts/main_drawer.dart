import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sunmate/constants/colors_contant.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../../localization/localization_contants.dart';

class MainDrawerPage extends StatefulWidget {
  const MainDrawerPage({super.key});

  @override
  State<MainDrawerPage> createState() => _MainDrawerPageState();
}

class _MainDrawerPageState extends State<MainDrawerPage> {
  bool? isSwitched;

  @override
  void initState() {
    storage();
    // TODO: implement initState
    super.initState();
  }

  void storage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isSwitched = prefs.getBool('isLogin') ?? false;
    });
  }

  var set;
  void _toggleSwitch(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    isSwitched = value;
    await prefs.setBool('isLogin', isSwitched!);
    set = prefs.getBool('isLogin');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ModelTheme>(
        builder: (context, ModelTheme themeNotifier, child) {
      return Drawer(
        backgroundColor: getColors(themeNotifier.isDark, 'inputColor'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(left: 15, top: 50, bottom: 20),
              decoration: BoxDecoration(
                color: getColors(themeNotifier.isDark, 'inputColor'),
              ),
              child: Row(
                children: [
                  Text(
                    'SunMate.IO',
                    style: TextStyle(
                        color: getColors(themeNotifier.isDark, 'textColor'),
                        fontSize: 20),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () async {
                      Provider.of<AuthProvider>(context, listen: false)
                          .logOut();
                      Navigator.of(context).pushReplacementNamed('/login');
                    },
                    child: Icon(Icons.logout,
                        color: getColors(themeNotifier.isDark, 'textColor')),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    getTranslated(context, 'k_home_biometric'),
                    style: TextStyle(
                        color: getColors(themeNotifier.isDark, 'textColor'),
                        fontWeight: FontWeight.w500,
                        fontSize: 14),
                  ),
                  Switch(
                    value: isSwitched ?? false,
                    onChanged: _toggleSwitch,
                    activeTrackColor: Colors.grey,
                    activeColor: Colors.grey.shade700,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
