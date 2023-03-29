import 'payment_model.dart';

class PaymentResponse {
  final List<Payment> payments;
  final PaymentTypeSummary monthlyIncoming;
  final PaymentTypeSummary monthlyOutgoing;
  final PaymentTypeSummary monthlyNet;
  final List<PaymentCategoryTotal> categoryTotals;

  PaymentResponse(
      {required this.payments,
      required this.monthlyIncoming,
      required this.monthlyOutgoing,
      required this.monthlyNet,
      required this.categoryTotals});

  factory PaymentResponse.fromJson(Map<String, dynamic> json) {
    var payments = json['payments'].map((p) => Payment.fromJson(p)).toList();

    return PaymentResponse(
        payments: payments,
        monthlyIncoming: json['monthlyIncoming'],
        monthlyOutgoing: json['monthlyOutgoing'],
        monthlyNet: json['monthlyNet'],
        categoryTotals: json['categoryTotals']);
  }
}

class PaymentTypeSummary {
  final int count;
  final double total;

  PaymentTypeSummary({required this.count, required this.total});
}

class PaymentCategoryTotal {
  final String category;
  final double total;

  PaymentCategoryTotal({required this.category, required this.total});
}
