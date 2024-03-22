import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/colors_contant.dart';
import '../../localization/localization_contants.dart';
import '../../providers/theme_provider.dart';

class MyTextField extends StatelessWidget {
  const MyTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.obscureText,
      required this.validator});

  final controller;
  final String hintText;
  final bool obscureText;
  final FormFieldValidator<String> validator;

  @override
  Widget build(BuildContext context) {
    return Consumer<ModelTheme>(
        builder: (context, ModelTheme themeNotifier, child) {
      return TextFormField(
        style: TextStyle(
            color: getColors(themeNotifier.isDark, 'textColor'), fontSize: 14),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return getTranslated(context, 'k_form_require_full_name');
          }
          return null;
        },
        controller: controller,
        obscureText: obscureText,
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
          hintText: hintText,
          hintStyle: TextStyle(
              color: getColors(themeNotifier.isDark, 'textColor'),
              fontSize: 14,
              fontWeight: FontWeight.w400),
        ),
      );
    });
  }
}
