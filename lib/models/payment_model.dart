class Payment {
  final String id;
  final String description;
  final double amount;
  final String date;

  Payment({required this.id, required this.description, required this.amount, required this.date});

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'],
      description: json['description'],
      amount: json['amount'],
      date: json['date'],
    );
  }
}
