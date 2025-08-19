import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:traveler_voice/models/report.dart';

class ApiService {
  // Base configuration
  static late String _baseUrl = 'https://your-api-endpoint.com/api';
  static String get _reportsEndpoint => '$_baseUrl/reports';
  static String get _uploadEndpoint => '$_baseUrl/upload';
  static const int _timeoutSeconds = 30;

  // Headers
  static Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// Submit a report to the backend
  /// Submit a report to the backend
  static Future<bool> submitReport(Report report) async {
    try {
      final reportJson = report.toJson();

      // Print the report details before sending
      print('┌───────────────────────────────────────────────────────');
      print('📝 Report Details to be Submitted:');
      print(const JsonEncoder.withIndent('  ').convert(reportJson));
      print('└───────────────────────────────────────────────────────');

      // For testing purposes, just return true and print the data
      print('✅ [TEST MODE] Report would be submitted to $_reportsEndpoint');
      print('✅ [TEST MODE] Returning success without actual API call');
      return true;

      // If you want to actually make the API call (with a real endpoint):
      /*
    final response = await http
        .post(
          Uri.parse(_reportsEndpoint),
          headers: _headers,
          body: jsonEncode(reportJson),
        )
        .timeout(const Duration(seconds: _timeoutSeconds));

    _printResponseData(response);
    final responseData = _handleResponse(response);

    return responseData['success'] == true;
    */
    } catch (e) {
      print('❌ Error submitting report: $e');
      return false;
    }
  }

  /// Upload an image file to the server
  static Future<String> uploadImage(String filePath) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      // Check if file exists (optional for test)
      final file = File(filePath);
      if (!file.existsSync()) {
        throw Exception("File not found at $filePath");
      }

      // Return a mock image URL as if it was uploaded successfully
      return "https://example.com/uploads/${file.uri.pathSegments.last}";
    } catch (e) {
      throw Exception("Image upload failed: $e");
    }
  }

  /// Fetch all reports from the server
  static Future<List<Report>> getReports() async {
    try {
      print('📡 Fetching reports from server...');
      final response = await http
          .get(
            Uri.parse(_reportsEndpoint),
            headers: _headers,
          )
          .timeout(const Duration(seconds: _timeoutSeconds));

      _printResponseData(response);
      final responseData = _handleResponse(response);

      return (responseData['reports'] as List)
          .map((reportJson) => Report.fromJson(reportJson))
          .toList();
    } catch (e) {
      print('❌ Error fetching reports: $e');
      throw _handleError(e);
    }
  }

  /// Handle API responses
  static Map<String, dynamic> _handleResponse(http.Response response) {
    print('🔍 Processing response...');
    switch (response.statusCode) {
      case 200:
      case 201:
        try {
          return jsonDecode(response.body);
        } catch (e) {
          throw FormatException('Invalid JSON response: ${response.body}');
        }
      case 400:
        throw Exception('Bad request: ${response.body}');
      case 401:
        throw Exception('Unauthorized: Please login again');
      case 403:
        throw Exception('Forbidden: ${response.body}');
      case 404:
        throw Exception('Resource not found');
      case 500:
        throw Exception('Server error: ${response.body}');
      default:
        throw Exception(
            'Request failed with status: ${response.statusCode}. ${response.body}');
    }
  }

  /// Handle errors consistently
  static Exception _handleError(dynamic error) {
    print('⚠️ Handling error: $error');
    if (error is SocketException) {
      return Exception('No Internet connection');
    } else if (error is FormatException) {
      return Exception('Invalid server response format');
    } else if (error is http.ClientException) {
      return Exception('Network request failed');
    } else if (error is TimeoutException) {
      return Exception('Request timed out after $_timeoutSeconds seconds');
    }
    return Exception('An unexpected error occurred: $error');
  }

  /// Print request data in readable format
  static void _printRequestData(Map<String, dynamic> data, String endpoint) {
    print('┌───────────────────────────────────────────────────────');
    print('⬆️ Preparing to submit to $endpoint');
    print('📦 Request Data:');
    print(const JsonEncoder.withIndent('  ').convert(data));
    print('🔑 Headers:');
    print(_headers);
    print('└───────────────────────────────────────────────────────');
  }

  /// Print response data in readable format
  static void _printResponseData(http.Response response) {
    print('┌───────────────────────────────────────────────────────');
    print('⬇️ Server Response:');
    print('Status Code: ${response.statusCode}');
    try {
      final jsonData = jsonDecode(response.body);
      print('Response Body:');
      print(const JsonEncoder.withIndent('  ').convert(jsonData));
    } catch (e) {
      print('Response Body: ${response.body}');
    }
    print('└───────────────────────────────────────────────────────');
  }

  /// Add authentication token to headers
  static void setAuthToken(String token) {
    print('🔐 Setting auth token');
    _headers['Authorization'] = 'Bearer $token';
  }

  /// Remove authentication token
  static void clearAuthToken() {
    print('🔓 Clearing auth token');
    _headers.remove('Authorization');
  }

  /// Get current headers (for debugging)
  static Map<String, String> get currentHeaders => _headers;

  /// Update base URL (for testing)
  static void updateBaseUrl(String newUrl) {
    print('🔄 Updating base URL to: $newUrl');
    _baseUrl = newUrl;
  }
}
