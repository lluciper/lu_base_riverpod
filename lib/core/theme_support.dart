import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeProvider = NotifierProvider<ThemeSupport, Brightness>(
  ThemeSupport.new,
);

class ThemeSupport extends Notifier<Brightness> {
  @override
  Brightness build() => Brightness.light;

  void setBrightness(Brightness brightness) {
    state = brightness;
  }

  void clearBrightness() {
    state = Brightness.light;
  }
}
