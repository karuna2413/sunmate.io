import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:sunmate/localization/demo_localization.dart';
import 'package:sunmate/providers/access_token_provider.dart';
import 'package:sunmate/providers/auth_provider.dart';
import 'package:sunmate/providers/googe_verification_proiver.dart';
import 'package:sunmate/providers/home_data_provider.dart';
import 'package:sunmate/providers/theme_provider.dart';
import 'package:sunmate/routes/routes.dart';
import 'package:sunmate/screens/home/getstarted.dart';
import 'package:sunmate/screens/home/home_page.dart';
import 'package:sunmate/screens/home/internet.dart';
import 'config/environment.dart';
import 'package:local_auth/local_auth.dart';
import 'package:intl/intl.dart';

import 'models/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const String environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: Environment.DEV,
  );
  Environment().initConfig(environment);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  static void setLocale(BuildContext context, Locale locale) {
    _MyAppState? state = context.findRootAncestorStateOfType<_MyAppState>();
    state?.setLocale(locale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Locale _locale = const Locale('en');
  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  getLocale() {
    return _locale;
  }

  void _updateThemeBrightness(BuildContext context, ModelTheme themeNotifier) {
    if (MediaQuery.of(context).platformBrightness == Brightness.dark) {
      themeNotifier.isDark = true;
    } else {
      themeNotifier.isDark = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => HomeDataProvider()),
        ChangeNotifierProvider(create: (_) => GoogleVerificationProvider()),
        ChangeNotifierProvider(create: (_) => AccessTokenProvider())
      ],
      child: Sizer(builder: (BuildContext context, Orientation orientation,
          DeviceType deviceType) {
        return ChangeNotifierProvider(
          create: (_) => ModelTheme(),
          child: MaterialApp(
            localizationsDelegates: const [
              DemoLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            locale: _locale,
            localeListResolutionCallback: (deviceLocale, supportedLocales) {},
            supportedLocales: const [
              Locale('en'), // English
              Locale('da'), // Danish
            ],
            title: 'Sunmate.io',
            home: InternetPage(),
            routes: allRoutes,
          ),
        );
      }),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage();

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var expireTime;
  var isLogin = false;
  var token;
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  var authenticationCompleted = false; // Add this flag
  UserLogin? loginModal;
  var check;
  bool _initialBuild = true; // Add boolean flag

  @override
  void initState() {
    checkToken();

    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    authenticationCompleted = false;
    super.dispose();
  }

  Future<Widget> _authenticateUser(BuildContext context) async {
    authenticationCompleted = true;

    bool isAuthenticated = false;

    try {
      isAuthenticated = await _localAuthentication.authenticate(
        localizedReason: 'Authenticate to access the app',
        // Prompt shown to the user
        options: const AuthenticationOptions(
          useErrorDialogs: true, // Show system dialog in case of error
          stickyAuth: true,
        ),
      );
    } catch (e) {
      SystemNavigator.pop();
      print('Error: $e');
    }

    if (isAuthenticated) {
      Navigator.pushNamed(context, '/home');
      return SizedBox();
    } else {
      SystemNavigator.pop();
      return SizedBox();
    }
  }

  void checkToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    expireTime = prefs.getString('refresh_expire');
    check = prefs.getBool('check');

    isLogin = prefs.getBool('isLogin') ?? false;
    token = prefs.getString('refreshToken');
    if (expireTime != null) {
      DateFormat format = DateFormat('EEE, dd MMM yyyy HH:mm:ss \'GMT\'');
      DateTime expirationTime = format.parse(expireTime!);
      bool isTokenExpired = expirationTime.isBefore(DateTime.now());
      final storage = new FlutterSecureStorage();

      if (isTokenExpired) {
        if (check == true) {
          String? value1 = await storage.read(key: 'email');
          String? value2 = await storage.read(key: 'password');
          loginModal = UserLogin(email: value1!, password: value2!);
          Provider.of<AuthProvider>(context, listen: false)
              .updateLoginModel(loginModal!);
          await Provider.of<AuthProvider>(context, listen: false).login(check);
        } else {
          token = null;
          prefs.remove('isLogin');
          prefs.remove('access_token');
          prefs.remove('refreshToken');
        }

        isLogin = false;
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print('plog$token');
    if (_initialBuild) {
      _initialBuild = false;
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return isLogin && token != null
        ? _buildAuthWidget(context)
        : token != null || check == true
            ? HomePage()
            : FirstHomePage();
  }

  Widget _buildAuthWidget(BuildContext context) {
    if (!authenticationCompleted) {
      return FutureBuilder(
        future: _authenticateUser(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }
            return snapshot.data ?? Container();
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      );
    } else {
      return SizedBox();
    }
  }
}
