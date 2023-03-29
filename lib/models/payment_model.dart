class Payment {
  final String id;
  final String name;
  final DateTime referenceDate;
  final PaymentType type;
  final PaymentFrequency frequency;
  final String category;
  final double amount;
  final String? details;

  Payment({
    required this.id,
    required this.name,
    required this.referenceDate,
    required this.type,
    required this.frequency,
    required this.category,
    required this.amount,
    this.details,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'],
      name: json['name'],
      referenceDate: json['referenceDate'],
      type: json['type'],
      frequency: json['frequency'],
      category: json['category'],
      amount: json['amount'],
      details: json['details'],
    );
  }
}

enum PaymentType { incoming, outgoing }

enum PaymentFrequency { weekly, fortnightly, monthly, yearly }
