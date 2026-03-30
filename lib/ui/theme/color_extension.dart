import 'dart:ui';

extension StringToColor on String {
  Color toColors() {
    String hexString = replaceAll('#', '');
    if (hexString.length == 6) {
      hexString = 'FF$hexString';
    }
    return Color(int.parse(hexString, radix: 16));
  }
}