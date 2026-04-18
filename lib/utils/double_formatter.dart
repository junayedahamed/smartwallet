import 'package:smartwallet/setting/setting_controller.dart';

String doubleFormatter(double value) {
  final sign = value < 0 ? "-" : "";
  final text = value.abs().toStringAsFixed(2);
  final currency = SettingsController.instance.currency;
  return "$sign$currency$text";
}
