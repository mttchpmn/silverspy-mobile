class Payment {
  final int id;
  final String name;
  final String referenceDate;
  final PaymentType type;
  final PaymentFrequency frequency;
  final String category;
  final double value;
  final String? details;

  Payment({
    required this.id,
    required this.name,
    required this.referenceDate,
    required this.type,
    required this.frequency,
    required this.category,
    required this.value,
    this.details,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'],
      name: json['name'],
      referenceDate: json['referenceDate'],
      type: PaymentType.values.byName(json['type'].toLowerCase()),
      frequency: PaymentFrequency.values.byName(json['frequency'].toLowerCase()),
      category: json['category'],
      value: json['value'],
      details: json['details'],
    );
  }
}

enum PaymentType { incoming, outgoing }

enum PaymentFrequency { weekly, fortnightly, monthly, yearly }
