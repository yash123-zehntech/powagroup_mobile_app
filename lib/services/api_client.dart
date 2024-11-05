import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  // ignore: constant_identifier_names
  //static const BASE_URL = "https://pwa-qa.odoo.inspiredsoftware.com.au";

  // Production Base URL
  static const BASE_URL = "https://www.powagroup.com.au";
  // static const BASE_URL = "http://10.10.1.35:9143";

  Future<http.Response> getMethod(String url,
      {Map<String, String>? header}) async {
    print("URL ----------------- ${Uri.parse(BASE_URL + url)}");
    http.Response response =
        await http.get(Uri.parse(BASE_URL + url), headers: header);

    return response;
  }

  Future<http.Response> getMethodWithQuery(String url,
      {Map<String, dynamic>? body}) async {
    // Encode the body data if provided
    String queryString = '';
    if (body != null && body.isNotEmpty) {
      // Encode the query parameters
      final encodedParams = Uri(queryParameters: body).query;
      queryString = '?$encodedParams';
    }

    // Perform a GET request to the specified URL with query parameters
    http.Response response =
        await http.get(Uri.parse(BASE_URL + url + queryString));

    return response; // Return the response object
  }

  Future<http.Response> postMethod(String method, var body,
      {Map<String, String>? header}) async {
    print("Body -------- $body");
    print("Url ---------- ${Uri.parse(BASE_URL + method)}");
    http.Response response = await http.post(Uri.parse(BASE_URL + method),
        body: body, headers: header);

    return response;
  }

  Future<http.Response> postMethodRow(String method, var body,
      {Map<String, String>? header}) async {
    final jsonString = json.encode(body);
    print("URL -------------------- ${Uri.parse(BASE_URL + method)}");
    print("Body -------------------- ${jsonString}");
    print("Header -------------------- ${header}");
    http.Response response = await http.post(Uri.parse(BASE_URL + method),
        body: jsonString, headers: header);

    return response;
  }

  Future<http.Response> patchMethod(
      String method, var body, Map<String, String> headers) async {
    http.Response response = await http.patch(Uri.parse(BASE_URL + method),
        body: body, headers: headers);
    return response;
  }

  Future<http.Response> getMethodForQueryParams2(
      String url, Map<String, dynamic> queryParams,
      {Map<String, String>? header}) async {
    try {
      http.Response response =
          await http.get(Uri.parse(BASE_URL + url), headers: header);

      return response;
    } catch (e) {
      throw Exception('Error during API request: $e');
    }
  }

  Future<http.Response> getMethodForQueryParams(
      String url, Map<String, dynamic> queryParams,
      {Map<String, String>? header}) async {
    try {
      print(
          "URL ------------- ${Uri.parse(BASE_URL + url).replace(queryParameters: queryParams)}");
      http.Response response = await http.get(
          Uri.parse(BASE_URL + url).replace(queryParameters: queryParams),
          headers: header);

      return response;
    } catch (e) {
      throw Exception('Error during API request: $e');
    }
  }
}
