import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class PayMongoService {
  static const apiKey = 'sk_test_1QuYojD6iZBDzdN2SgTsGUNi';
  static const gcashPaymentMethod = 'gcash';
  static const paymentEndpoint = 'https://api.paymongo.com/v1/payments';

  void createPaymentIntent() async {
    try {
      final url = Uri.parse('https://api.paymongo.com/v1/payment_intents');
      final headers = {
        'accept': 'application/json',
        'authorization': 'Basic $apiKey',
        'content-type': 'application/json',
      };
      final payload = {
        'data': {
          'attributes': {
            'amount': 10000,
            'payment_method_allowed': ['card', 'dob', 'paymaya', 'billease'],
            'payment_method_options': {
              'card': {
                'request_three_d_secure': 'any',
              },
            },
            'currency': 'PHP',
            'capture_type': 'automatic',
            'description': 'Your internal description',
            'statement_descriptor': 'Statement',
            'metadata': {
              'key': 'value',
              'key2': 'value',
            },
          },
        },
      };

      final response =
          await http.post(url, headers: headers, body: jsonEncode(payload));

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        log('Payment intent created: ${responseData['data']['id']}');
        // Handle the successful response
      } else {
        log('Failed to create payment intent');
        // Handle the error response
      }
    } catch (e) {
      log('Exception occurred: $e');
      // Handle the exception
    }
  }




}
