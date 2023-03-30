class PaymentInput {
  final String name;
  final String referenceDate;
  final String type;
  final String frequency;
  final String category;
  final double value;
  final String? details;

  PaymentInput({
    required this.name,
    required this.referenceDate,
    required this.type,
    required this.frequency,
    required this.category,
    required this.value,
    this.details,
  });

  @override
  String toString() {
    return "Payment { name: $name, referenceDate: $referenceDate, type: $type, frequency: $frequency, category: $category, value: $value, details: $details }";
  }
}
