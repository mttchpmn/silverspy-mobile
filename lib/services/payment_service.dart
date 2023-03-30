import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:silverspy/models/payment_input_model.dart';

import '../models/payment_response_model.dart';

class PaymentsService {
  final String apiUrl =
      'http://10.0.2.2:5224/payments'; // TODO - Extract to config
  final _bearerToken =
      "";

  Future<PaymentData> getPaymentData() async {
    var headers = <String, String>{"Authorization": _bearerToken};
    final response = await http.get(Uri.parse(apiUrl), headers: headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      var paymentResponse = PaymentData.fromJson(data);

      return paymentResponse;
    } else {
      throw Exception('Failed to load payments');
    }
  }

  Future<void> addPayment(PaymentInput payment) async {
    var headers = <String, String>{
      "Authorization": _bearerToken,
      "Content-Type": "application/json; charset=UTF-8"
    };

    final response = await http.post(Uri.parse(apiUrl),
        body: json.encode({
          'name': payment.name,
          'referenceDate': payment.referenceDate,
          'type': payment.type,
          'frequency': payment.frequency,
          'category': payment.category,
          'value': payment.value.toString(),
          'details': payment.details,
        }),
        headers: headers);
    if (response.statusCode != 200) {
      throw Exception('Failed to add payment');
    }
  }
}
