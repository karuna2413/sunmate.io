import 'package:flutter/material.dart';

void showCustomSnackbar(BuildContext context, String message, bool isError,
    {DismissDirection dismissDirection = DismissDirection.endToStart}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      dismissDirection: dismissDirection,
      margin: EdgeInsets.only(
          bottom: 10, left: 10, right: 10, top: 10), // Adjust the top margin
      content: Text(message),
      backgroundColor: isError ? Colors.red : Colors.green,
      behavior: SnackBarBehavior.floating,
    ),
  );
}
