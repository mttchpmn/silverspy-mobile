class PaymentForecast {
  final List<PaymentInstance> payments;
  final double totalIncoming;
  final double totalOutgoing;
  final double netPosition;

  PaymentForecast(
      this.payments, this.totalIncoming, this.totalOutgoing, this.netPosition);

  factory PaymentForecast.fromJson(Map<String, dynamic> json) {
    List<PaymentInstance> payments = json['payments']
        .map<PaymentInstance>((x) => PaymentInstance.fromJson(x))
        .toList();

    return PaymentForecast(payments,
        double.parse(json['totalIncoming'].toString()),
        double.parse(json['totalOutgoing'].toString()),
        double.parse(json['netPosition'].toString()),
        );
  }
}

class PaymentInstance {
  final DateTime paymentDate;
  final String name;
  final String type;
  final String category;
  final String details;
  final double value;

  PaymentInstance(this.paymentDate, this.name, this.type, this.category,
      this.details, this.value);

  factory PaymentInstance.fromJson(Map<String, dynamic> json) {
    return PaymentInstance(
        DateTime.parse(json['paymentDate']),
        json['name'],
        json['type'],
        json['category'],
        json['details'],
        double.parse(json['value'].toString()));
  }
}
