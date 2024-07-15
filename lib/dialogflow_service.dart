import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;

class DialogflowService {
  final String _projectId = 'bot-semd'; // Replace with your Dialogflow project ID
  final String _languageCode = 'en';
  final String _sessionId = '123456'; // You can use a random or generated session ID

  Future<String> _getAccessToken() async {
    final serviceAccount = await rootBundle.loadString('assets/deductive-motif-428420-q5-4e464dcc1319.json'); // Path to your service account JSON file
    final Map<String, dynamic> credentials = json.decode(serviceAccount);
    final response = await http.post(
      Uri.parse('https://oauth2.googleapis.com/token'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'client_email': credentials['client_email'],
        'private_key': credentials['private_key'],
        'grant_type': 'urn:ietf:params:oauth:grant-type:jwt-bearer',
        'scope': 'https://www.googleapis.com/auth/cloud-platform',
      }),
    );
    final accessToken = json.decode(response.body)['access_token'];
    return accessToken;
  }

  Future<String> detectIntent(String query) async {
    final accessToken = await _getAccessToken();
    final response = await http.post(
      Uri.parse('https://dialogflow.googleapis.com/v2/projects/$_projectId/agent/sessions/$_sessionId:detectIntent'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json; charset=utf-8',
      },
      body: json.encode({
        'queryInput': {
          'text': {
            'text': query,
            'languageCode': _languageCode,
          },
        },
      }),
    );
    final responseBody = json.decode(response.body);
    final fulfillmentText = responseBody['queryResult']['fulfillmentText'];
    return fulfillmentText;
  }
}
