import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

void showToast(String message, {ToastGravity gravity = ToastGravity.CENTER}) {
  Fluttertoast.showToast(
    msg: message,
    gravity: gravity,
    backgroundColor: Colors.black.withOpacity(0.8),
    textColor: Colors.white,
    fontSize: 16.0,
    toastLength: Toast.LENGTH_SHORT,
  );
}


void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(

      content: Text(message),
      duration: const Duration(seconds: 2),
    ),
  );
}