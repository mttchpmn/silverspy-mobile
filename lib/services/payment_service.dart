import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/payment_response_model.dart';

class PaymentsService {
  final String apiUrl = 'http://10.0.2.2:5224/payments'; // TODO - Extract to config

  Future<PaymentData> getPaymentData() async {
    var headers = <String,String>{
      "Authorization" : ""
    };
    final response = await http.get(Uri.parse(apiUrl), headers: headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      var paymentResponse = PaymentData.fromJson(data);

      return paymentResponse;
    } else {
      throw Exception('Failed to load transactions');
    }
  }
}
