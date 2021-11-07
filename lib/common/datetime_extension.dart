extension DateTimeExtension on DateTime? {
  String get simpleDateString =>
      "${this?.year.toString().padLeft(4, '0')}-${this?.month.toString().padLeft(2, '0')}-${this?.day.toString().padLeft(2, '0')}";
}
