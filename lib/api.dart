import 'package:http/http.dart' as http;

class API {
  static const String baseUrl = 'https://www.balldontlie.io/api/v1';

  static Future<http.Response> get(String endpoint) {
    return http.get(Uri.parse('$baseUrl$endpoint'));
  }
}
