import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sunmate/constants/colors_contant.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../localization/localization_contants.dart';
import '../../providers/access_token_provider.dart';
import '../../providers/googe_verification_proiver.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/shared/language_select.dart';
import '../../widgets/shared/snackbar_common.dart';

class CodeVerificationPage extends StatefulWidget {
  const CodeVerificationPage({Key? key}) : super(key: key);

  @override
  CodeVerificationPageState createState() => CodeVerificationPageState();
}

class CodeVerificationPageState extends State<CodeVerificationPage> {
  String error = "";
  bool changeButton = false;
  String isSignIn = 'initial';
  final _priceFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  String selectedLanguage = 'English';
  bool isChecked = false;
  TextEditingController pin1 = TextEditingController();
  TextEditingController pin2 = TextEditingController();
  TextEditingController pin3 = TextEditingController();
  TextEditingController pin4 = TextEditingController();
  var code;
  var otp;
  var method;
  @override
  void initState() {
    otpcall();
    // TODO: implement initState
    super.initState();
  }

  void otpcall() async {
    final pref = await SharedPreferences.getInstance();
    otp = pref.getString('otp');
    method = pref.getString('method');
    setState(() {});
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    super.dispose();
  }

  Future<void> resentCode() async {
    dynamic result;
    code = "${pin1.text}${pin2.text}${pin3.text}${pin4.text}";
    result =
        await Provider.of<GoogleVerificationProvider>(context, listen: false)
            .resendOTP(context);
    print("resend");
    if (result['success'] == true) {
      print('result null');
      setState(() {
        otp = result['otp'].toString();
      });
      showCustomSnackbar(context, "Code send successfully", false);
    } else {
      showCustomSnackbar(context, "Something went wrong.", true);
    }
  }

  moveToHome(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      dynamic result;
      code = "${pin1.text}${pin2.text}${pin3.text}${pin4.text}";
      result =
          await Provider.of<GoogleVerificationProvider>(context, listen: false)
              .googleVerification(code, context);
      print('$result ================');
      if (result == null) {
        print('result null');
      }
      if (result['success'] == true) {
        setState(() {
          isSignIn = 'completed';
          changeButton = true;
        });
        await Provider.of<AccessTokenProvider>(context, listen: false)
            .accessToken();
        await Navigator.of(context)
            .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
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

  Widget _textFieldOTP({bool? first, last, pin, themeNotifier}) {
    return Container(
      height: 65,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: TextField(
          controller: pin,
          autofocus: true,
          onChanged: (value) {
            if (value.length == 1 && last == false) {
              FocusScope.of(context).nextFocus();
            }
            if (value.length == 0 && first == false) {
              FocusScope.of(context).previousFocus();
            }
          },
          showCursor: false,
          readOnly: false,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: getColors(themeNotifier.isDark, 'buttonColor')),
          keyboardType: TextInputType.number,
          maxLength: 1,
          decoration: InputDecoration(
            filled: true,
            fillColor: getColors(themeNotifier.isDark, 'inputColor'),
            counter: Offstage(),
            contentPadding: const EdgeInsets.only(bottom: 50, top: 50),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                  color: getColors(themeNotifier.isDark, 'borderColor'),
                ),
                borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    width: 2,
                    color: getColors(themeNotifier.isDark, 'buttonColor')),
                borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ModelTheme>(
        builder: (context, ModelTheme themeNotifier, child) {
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios,
                  color: getColors(themeNotifier.isDark, 'textColor')),
              onPressed: () => Navigator.pushNamed(context, '/login'),
            ),
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
                  Row(
                    children: [
                      Text(
                        getTranslated(context, 'k_verify_heading'),
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w400,
                          color: getColors(themeNotifier.isDark, 'textColor'),
                        ),
                      ),
                      Text(
                        getTranslated(context, 'k_verify_digits_code'),
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                          color: getColors(themeNotifier.isDark, 'buttonColor'),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    method == 'sms'
                        ? getTranslated(context, 'k_verify_sub_text')
                        : getTranslated(context, 'k_verify_sub_text1'),
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color:
                            getColors(themeNotifier.isDark, 'GreyTextColor')),
                  ),
                  Text(method == 'sms' ? otp ?? '' : ''),
                  const SizedBox(
                    height: 40.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _textFieldOTP(
                          first: true,
                          last: false,
                          pin: pin1,
                          themeNotifier: themeNotifier),
                      _textFieldOTP(
                          first: false,
                          last: false,
                          pin: pin2,
                          themeNotifier: themeNotifier),
                      _textFieldOTP(
                          first: false,
                          last: false,
                          pin: pin3,
                          themeNotifier: themeNotifier),
                      _textFieldOTP(
                          first: false,
                          last: true,
                          pin: pin4,
                          themeNotifier: themeNotifier),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: getTranslated(
                                        context, 'k_verify_resend'),
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: getColors(
                                          themeNotifier.isDark, 'textColor'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                              ),
                              onPressed: resentCode,
                              child: Text(
                                getTranslated(context, 'k_verify_resend_code'),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: getColors(
                                      themeNotifier.isDark, 'buttonColor'),
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
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
                                  moveToHome(context)
                                }
                              : null,
                          child: AnimatedContainer(
                              duration: const Duration(seconds: 1),
                              width: MediaQuery.of(context).size.width,
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
