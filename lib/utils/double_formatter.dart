String doubleFormatter(double value) {
  final sign = value < 0 ? "-" : "";
  final text = value.abs().toStringAsFixed(2);
  return "$sign\$$text";
}
