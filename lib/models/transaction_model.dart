class Transaction {
  final int id;
  final String transactionDate;
  final String reference;
  final String description;
  final String category;
  final String? details;
  final int type;
  final double value;

  Transaction({
    required this.id,
    required this.transactionDate,
    required this.reference,
    required this.description,
    required this.category,
    required this.details,
    required this.type,
    required this.value
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      transactionDate: json['transactionDate'],
      reference: json['reference'],
      description: json['description'],
      category: json['category'],
      details: json['details'],
      type: json['type'],
      value: json['value'].toDouble(),
    );
  }
}
