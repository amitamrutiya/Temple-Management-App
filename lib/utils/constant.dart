import 'package:flutter/material.dart';
import 'colors.dart';

class Constant {
  static AppBar appBar(String title) {
    return AppBar(
      elevation: 0,
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: AppColors.mainColor,
    );
  }
}
