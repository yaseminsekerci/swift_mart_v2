class SavedAddress {
  final String id;
  final String title;
  final String line;
  final String city;

  const SavedAddress({
    required this.id,
    required this.title,
    required this.line,
    required this.city,
  });

  String get oneLine => '$line, $city';
}
