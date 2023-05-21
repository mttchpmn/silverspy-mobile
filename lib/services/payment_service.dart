import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:silverspy/models/payment_forecast_model.dart';
import 'package:silverspy/models/payment_input_model.dart';

import '../models/payment_response_model.dart';
import '../providers/auth_provider.dart';

class PaymentsService {
  final String apiUrl = "https://staging.api.silverspy.io/payments";

  Future<PaymentData> getPaymentData(String token) async {
    var headers = <String, String>{"Authorization": "Bearer $token"};
    final response = await http.get(Uri.parse(apiUrl), headers: headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      var paymentResponse = PaymentData.fromJson(data);

      return paymentResponse;
    } else {
      throw Exception('Failed to load payments');
    }
  }

  Future<PaymentForecast> getPaymentForecast(DateTime startDate, DateTime endDate, String token) async {
    var headers = <String, String>{
      "Authorization": "Bearer $token",
      "Content-Type": "application/json; charset=UTF-8"
    };
    final response = await http.post(Uri.parse("$apiUrl/forecast"),
        body: json.encode({
          'startDate': startDate.toUtc().toIso8601String(),
          'endDate': endDate.toUtc().toIso8601String()
        }),
        headers: headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      var result = PaymentForecast.fromJson(data);

      return result;
    } else {
      throw Exception('Failed to fetch payment forecast');
    }
  }

  Future<void> addPayment(PaymentInput payment, String token) async {
    var headers = <String, String>{
      "Authorization": "Bearer $token",
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
