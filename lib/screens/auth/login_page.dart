import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:sunmate/providers/access_token_provider.dart';
import 'package:sunmate/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:sunmate/screens/auth/signup_page.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../constants/colors_contant.dart';
import '../../localization/localization_contants.dart';
import '../../main.dart';
import '../../models/login.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/shared/snackbar_common.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  String email = "";
  String password = '';
  String error = "";
  bool changeButton = false;
  String isSignIn = 'initial';
  UserLogin? loginModal;
  var visiblePass = false;
  var res;
  var check = false;
  final _priceFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _priceFocusNode.dispose();
    super.dispose();
  }

  moveToHome(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      loginModal = UserLogin(email: email, password: password);
      Provider.of<AuthProvider>(context, listen: false)
          .updateLoginModel(loginModal!);
      res =
          await Provider.of<AuthProvider>(context, listen: false).login(check);
      print(res.statusCode);
      if (res.statusCode == 200) {
        var result = jsonDecode(res.body);
        if (result["success"] == true) {
          setState(() {
            isSignIn = 'completed';
            changeButton = true;
          });
          if (result['auth_method'] == 'google') {
            await Navigator.pushNamed(context, '/googleVerification');
          } else if (result['auth_method'] == 'sms' ||
              result['auth_method'] == 'email') {
            await Navigator.pushNamed(context, '/verification');
          } else if (result['auth_method'] == 'none') {
            MyApp.setLocale(context, Locale(result['language']));
            print('method none');
            await Provider.of<AccessTokenProvider>(context, listen: false)
                .accessToken();
            await Navigator.pushNamed(context, '/home');
          }
          _formKey.currentState!.reset();
          setState(() {
            isSignIn = 'initial';
          });
        } else {
          setState(() {
            isSignIn = 'initial';
            showCustomSnackbar(context, result['message'], true);
          });
        }
      } else {
        String errorMessage = 'Something went wrong!';
        if (res.statusCode == 401) {
          errorMessage = getTranslated(context, 'k_valid_email_pass');
        }
        setState(() {
          isSignIn = 'initial';
          showCustomSnackbar(context, errorMessage, true);
        });
        return;
      }
    }
  }

  loginButton(themeNotifier) {
    if (isSignIn == 'initial') {
      return Text(
        getTranslated(context, 'k_form_login'),
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

  @override
  Widget build(BuildContext context) {
    return Consumer<ModelTheme>(
        builder: (context, ModelTheme themeNotifier, child) {
      return SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: getColors(themeNotifier.isDark, 'backgroundColor'),
          body: Form(
            key: _formKey,
            child: Container(
              padding: const EdgeInsets.all(30),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.all(20),
                    child: Image.asset(
                        'assets/images/${getLogo(themeNotifier.isDark)}'),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Text(
                    error,
                    style: const TextStyle(color: Colors.red, fontSize: 16.0),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Row(
                    children: [
                      Text(
                        getTranslated(context, 'k_login_welcome'),
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w400,
                          color: getColors(themeNotifier.isDark, 'textColor'),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          maxLines: 1,
                          overflow: TextOverflow.visible,
                          softWrap: false,
                          getTranslated(context, 'k_auth_app_name'),
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w600,
                            color:
                                getColors(themeNotifier.isDark, 'buttonColor'),
                          ),
                        ),
                      )
                    ],
                  ),
                  Text(
                    getTranslated(context, 'k_login_sub_text'),
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color:
                            getColors(themeNotifier.isDark, 'GreyTextColor')),
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                  Text(
                    getTranslated(context, 'k_form_email'),
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color:
                            getColors(themeNotifier.isDark, 'GreyTextColor')),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  TextFormField(
                    style: TextStyle(
                        color: getColors(themeNotifier.isDark, 'textColor'),
                        fontSize: 14),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return getTranslated(context, 'k_form_require_email');
                      }
                      return null;
                    },
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
                      hintText:
                          getTranslated(context, 'k_form_email_placeholder'),
                      hintStyle: TextStyle(
                          color: getColors(themeNotifier.isDark, 'textColor'),
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                    readOnly: isSignIn != 'initial',
                    onChanged: (value) {
                      email = value;
                      setState(() {});
                    },
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_priceFocusNode);
                    },
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                  Text(
                    getTranslated(context, 'k_form_password'),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: getColors(themeNotifier.isDark, 'GreyTextColor'),
                    ),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  TextFormField(
                    style: TextStyle(
                      color: getColors(themeNotifier.isDark, 'textColor'),
                      fontSize: 14,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return getTranslated(
                            context, 'k_form_require_password');
                      }
                      return null;
                    },
                    readOnly: isSignIn != 'initial',
                    obscureText: !visiblePass,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              visiblePass = !visiblePass;
                            });
                          },
                          icon: visiblePass
                              ? Icon(
                                  Icons.remove_red_eye_sharp,
                                  color: getColors(
                                      themeNotifier.isDark, 'buttonColor'),
                                )
                              : Icon(Icons.remove_red_eye_sharp)),
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
                      hintText:
                          getTranslated(context, 'k_form_password_placeholder'),
                      hintStyle: TextStyle(
                          color: getColors(themeNotifier.isDark, 'textColor'),
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                    onChanged: (value) {
                      password = value;
                      setState(() {});
                    },
                    focusNode: _priceFocusNode,
                    onFieldSubmitted: (_) => {
                      setState(() {
                        isSignIn = 'loading';
                      }),
                      moveToHome(context)
                    },
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  CheckboxListTile(
                    title: Text(
                      getTranslated(context, 'k_form_remember'),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: getColors(themeNotifier.isDark, 'textColor'),
                      ),
                    ),
                    checkColor: Colors.yellowAccent, // color of tick Mark
                    activeColor: getColors(themeNotifier.isDark, 'buttonColor'),
                    controlAffinity: ListTileControlAffinity.leading,
                    value: check,
                    onChanged: (Value) async {
                      check = Value!;
                      setState(() {});
                    },
                  ),
                  const SizedBox(
                    height: 10.0,
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
                                  print(_formKey.currentState),
                                  moveToHome(context)
                                }
                              : null,
                          child: AnimatedContainer(
                              duration: const Duration(seconds: 1),
                              width: MediaQuery.of(context).size.width,
                              height: 60,
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(10),
                              child: loginButton(themeNotifier)),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        getTranslated(context, 'k_login_not_have_account'),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: getColors(themeNotifier.isDark, 'textColor'),
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                        ),
                        onPressed: () {
                          _formKey.currentState?.reset();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const SignupPage();
                              },
                            ),
                          );
                        },
                        child: Text(
                          getTranslated(context, 'k_form_sign_up'),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color:
                                getColors(themeNotifier.isDark, 'buttonColor'),
                          ),
                        ),
                      ),
                    ],
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
