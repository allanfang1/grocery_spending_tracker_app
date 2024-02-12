import 'package:http/http.dart' as http;

class ConfirmReceiptRepository {
  http.Client client = http.Client();

  Future<int> submitTrip(int userId, String trip) async {
    final response = await client.post(
      Uri.https(
          'grocery-tracker.azurewebsites.net', 'users/$userId/submit-trip'),
      headers: {
        'Content-Type': 'application/json',
        'auth': ''}, // TODO get auth token from login
      body: trip,
    );

    return response.statusCode;
  }
}
