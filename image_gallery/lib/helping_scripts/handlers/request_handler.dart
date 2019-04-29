import 'package:http/http.dart' as http;

class RequestHandler {
  static Future<http.Response> executeGetRequest(String route) async {
    http.Response response = await http
        .get(Uri.encodeFull(route), headers: {"Accept": "application/json"});

    return response;
  }

  static Future<http.Response> executePostRequest(
      String route, String body) async {
    http.Response response = await http.post(Uri.encodeFull(route),
        headers: {
          "Accept": "application/json",
          "Content-type": "application/json"
        },
        body: body);

    return response;
  }

  static Future<http.Response> executePostRequestNoBody(String route) async {
    http.Response response = await http.post(Uri.encodeFull(route), headers: {
      "Accept": "application/json",
      "Content-type": "application/json",
    });

    return response;
  }

  static Future<http.Response> executeDeleteRequest(String route) async {
    http.Response response = await http
        .delete(Uri.encodeFull(route), headers: {"Accept": "application/json"});

    return response;
  }
}
