import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:silverspy/models/payment_input_model.dart';

import '../models/payment_response_model.dart';
import '../providers/auth_provider.dart';

class PaymentsService {
  // final String apiUrl =
  //     'http://10.0.2.2:5224/payments'; // TODO - Extract to config
  // final _bearerToken =
  //     "Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6Ii13LTV2cTdoNFN6VjROVEdHQ09leiJ9.eyJpc3MiOiJodHRwczovL3NpbHZlcnNweS5hdS5hdXRoMC5jb20vIiwic3ViIjoiYXV0aDB8NjFkOGJkMGYyZDRjMDkwMDZhMjAxOTM2IiwiYXVkIjoiaHR0cHM6Ly9hcGkuc2lsdmVyc3B5LmlvIiwiaWF0IjoxNjgwNDE0NDM0LCJleHAiOjE2ODA1MDA4MzQsImF6cCI6IkRFek5hTVdYM3NGM2tjSzgwUk1LZHpEdDBjQkFpdlFBIiwiZ3R5IjoicGFzc3dvcmQifQ.JAPy3lJ4joi2J1jkPn5Za-MkSpbk3ZF18y0Ot_9vfzO29RBWe03wJz16OxF4QIJj3PSF_uTdCQC6lWnih8nmfKyAKtnQC-D01ZHaSlzj0yHCml8IxSX4aLUnFVpHkqzdAwbgLJDbU1y92TkPbIBfxznTJu2qb5YIRR9a6Qykcm6tylUruSoV14TKzwpaXO3juM4iKLXHeAx61xvsmxeHcOJVeNYLQkpux4ZOPaSU8JPnE28eEvR4XKN4Va2XvEY8__3Kpw0cW98BUTRRNGGStbyzIODx8TG2OfuvmveGWizlOIK0qehExwfajcOzKYoY_Vbo0yDj3jqvCC9vZnNAwQ";

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
