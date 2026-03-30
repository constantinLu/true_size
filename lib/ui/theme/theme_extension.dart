// You can also create extension methods for easier access:
import 'package:flutter/material.dart';

extension ThemeExtension on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  TextTheme get textTheme => Theme.of(this).textTheme;

  Color get primary => Theme.of(this).colorScheme.primary;

  Color get secondary => Theme.of(this).colorScheme.secondary;

  Color get surface => Theme.of(this).colorScheme.surface;

  Color get primaryContainer => Theme.of(this).colorScheme.primaryContainer;

  Color get error => Theme.of(this).colorScheme.error;
}
