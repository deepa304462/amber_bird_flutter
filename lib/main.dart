import 'package:amber_bird/app-module.dart';
import 'package:amber_bird/app-widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ChangeLocale {
  static Function change = () {};
}

void main() {
  runApp(ModularApp(module: AppModule(), child: AppWidget()));
}
