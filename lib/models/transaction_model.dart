class Transaction {
  final String id;
  final String date;
  final String description;
  final double amount;

  Transaction({required this.id, required this.date, required this.description, required this.amount});

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      date: json['date'],
      description: json['description'],
      amount: json['amount'].toDouble(),
    );
  }
}
