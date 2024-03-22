import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sunmate/constants/colors_contant.dart';
import 'package:sunmate/providers/googe_verification_proiver.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../localization/localization_contants.dart';
import '../../providers/access_token_provider.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/shared/language_select.dart';
import '../../widgets/shared/snackbar_common.dart';

class GoogleVerificationPage extends StatefulWidget {
  const GoogleVerificationPage({Key? key}) : super(key: key);

  @override
  GoogleVerificationPageState createState() => GoogleVerificationPageState();
}

class GoogleVerificationPageState extends State<GoogleVerificationPage> {
  String error = "";
  bool changeButton = false;
  String isSignIn = 'initial';
  final _priceFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  String selectedLanguage = 'English';
  bool isChecked = false;

  @override
  void dispose() {
    _priceFocusNode.dispose();
    super.dispose();
  }

  moveToHome(BuildContext context, themeNotifier) async {
    final pref = await SharedPreferences.getInstance();
    if (_formKey.currentState!.validate()) {
      dynamic result;
      print(code);
      result =
          await Provider.of<GoogleVerificationProvider>(context, listen: false)
              .googleVerification(code, context);
      if (result['success'] == true) {
        setState(() {
          isSignIn = 'completed';
          changeButton = true;
        });
        await Provider.of<AccessTokenProvider>(context, listen: false)
            .accessToken();
        await Navigator.of(context)
            .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
        showCustomSnackbar(context, result['message'], true);
      } else {
        setState(() {
          isSignIn = 'initial';
        });
        String errorMessage = result['message'] ?? 'Something went wrong!';
        showCustomSnackbar(context, errorMessage, result['success'] == false);
      }
    }
  }

  Widget verifyButton(themeNotifier) {
    if (isSignIn == 'initial') {
      return Text(
        getTranslated(context, 'k_verify_button'),
        style: TextStyle(
          color: getColors(themeNotifier.isDark, 'buttonTextColor'),
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      );
    } else if (isSignIn == 'loading') {
      return CircularProgressIndicator(
        color: getColors(themeNotifier.isDark, 'buttonTextColor'),
      ).centered();
    } else {
      return Icon(
        Icons.done,
        color: getColors(themeNotifier.isDark, 'buttonTextColor'),
      );
    }
  }

  var code;
  @override
  Widget build(BuildContext context) {
    return Consumer<ModelTheme>(
        builder: (context, ModelTheme themeNotifier, child) {
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: getColors(
                  themeNotifier.isDark, 'textColor'), //change your color here
            ),
            backgroundColor: getColors(themeNotifier.isDark, 'backgroundColor'),
            centerTitle: true,
            title: Text(
              getTranslated(context, 'k_verify'),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: getColors(themeNotifier.isDark, 'textColor')),
            ),
            actions: const <Widget>[
              Padding(padding: EdgeInsets.all(5), child: LanguageSelect())
            ],
          ),
          backgroundColor: getColors(themeNotifier.isDark, 'backgroundColor'),
          resizeToAvoidBottomInset: false,
          body: Form(
            key: _formKey,
            child: Container(
              padding: const EdgeInsets.all(30),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      RichText(
                          text: TextSpan(children: [
                        TextSpan(
                          text: getTranslated(context, 'k_verify_heading'),
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w400,
                            color: getColors(themeNotifier.isDark, 'textColor'),
                          ),
                        ),
                        TextSpan(
                          text: getTranslated(context, 'k_verify_google_code'),
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w600,
                            color:
                                getColors(themeNotifier.isDark, 'buttonColor'),
                          ),
                        ),
                      ])),
                    ],
                  ),
                  // SizedBox(height: 20),

                  const SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    style: TextStyle(
                      color: getColors(themeNotifier.isDark, 'textColor'),
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: getColors(themeNotifier.isDark, 'inputColor'),
                      contentPadding: const EdgeInsets.all(20),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        borderSide: BorderSide(
                          color: getColors(themeNotifier.isDark, 'borderColor'),
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: getColors(themeNotifier.isDark, 'buttonColor'),
                          width: 2.0,
                        ),
                      ),
                      hintText: getTranslated(context, 'k_form_code'),
                      hintStyle: TextStyle(
                          color: getColors(themeNotifier.isDark, 'textColor'),
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                    onChanged: (value) {
                      code = value;
                      setState(() {});
                    },
                  ),

                  Expanded(
                    child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Material(
                        color: getColors(themeNotifier.isDark, 'buttonColor'),
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          onTap: () => _formKey.currentState!.validate()
                              ? {
                                  setState(() {
                                    isSignIn = 'loading';
                                  }),
                                  moveToHome(context, themeNotifier)
                                }
                              : null,
                          child: AnimatedContainer(
                              duration: const Duration(seconds: 1),
                              width: 400,
                              height: 60,
                              alignment: Alignment.center,
                              child: verifyButton(themeNotifier)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
