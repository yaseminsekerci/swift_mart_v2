class SavedPaymentMethod {
  final String id;
  final String holderName;
  final String lastFour;

  const SavedPaymentMethod({
    required this.id,
    required this.holderName,
    required this.lastFour,
  });

  String get maskLabel => '•••• $lastFour';
}
