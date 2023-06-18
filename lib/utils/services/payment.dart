import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class PayMongoService {
  static const apiKey = 'sk_test_1QuYojD6iZBDzdN2SgTsGUNi';
  static const gcashPaymentMethod = 'gcash';
  static const paymentEndpoint = 'https://api.paymongo.com/v1/payments';

  void createPaymentIntent() async {
    try {
      final url = Uri.parse('https://api.paymongo.com/v1/payment_intents');
      final headers = {
        'accept': 'application/json',
        'authorization': 'Basic ${base64.encode(utf8.encode(apiKey))}',
        'content-type': 'application/json',
      };
      final payload = {
        'data': {
          'attributes': {
            'amount': 10000,
            'payment_method_allowed': ['gcash'],
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

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        log('Payment intent created: ${responseData['data']['url']}');
        // Handle the successful response
      } else {
        log(jsonDecode(response.body));
        log('Failed to create payment intent');
        // Handle the error response
      }
    } catch (e) {
      log('Exception occurred: $e');
      // Handle the exception
    }
  }

  Future<String?> createGCashLink(String amount, String description) async {
    String endpoint = 'https://api.paymongo.com/v1/links';
    double amountInPesos =
        double.parse(double.parse(amount).toStringAsFixed(1));
    int amountInCentavos = (amountInPesos * 100).toInt();
    Map<String, dynamic> requestData = {
      'data': {
        'attributes': {
          'type': 'gcash',
          'amount': amountInCentavos,
          'currency': 'PHP',
          'description': description,
        }
      }
    };

    String url = endpoint;

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Basic ${base64Encode(utf8.encode('$apiKey:'))}',
    };

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: json.encode(requestData),
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);
      String gcashLink =
          await responseData['data']['attributes']['checkout_url'];
     
      await _launchUrl(
          gcashLink);
      return gcashLink;
    } else {
      log(response.body);
      return null;
    }
  }

  Future<void> _launchUrl(String gCashLink) async {
    if (!await launchUrl(Uri.parse(gCashLink))) {
      throw Exception('Could not launch $gCashLink');
    }
  }
}
