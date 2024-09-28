import 'package:flutter/material.dart';

void showToast(context, Widget content) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        content: content),
  );
}

void clearToast(context) {
  ScaffoldMessenger.of(context).clearSnackBars();
}
