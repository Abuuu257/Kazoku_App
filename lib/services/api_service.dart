import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  // Use the production URL provided by the user
  static const String baseUrl = 'https://kazokuweb-production.up.railway.app/api';

  // Fallback to local if needed for debugging (commented out)
  // static String get baseUrl {
  //   if (kIsWeb) return 'http://127.0.0.1:8000/api';
  //   try {
  //     if (Platform.isAndroid) return 'http://10.0.2.2:8000/api';
  //   } catch (e) {
  //     // Platform.isAndroid throws on web, ignore
  //   }
  //   return 'http://127.0.0.1:8000/api';
  // }

  String? _token;

  void setToken(String? token) {
    _token = token;
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (body['status'] == true) {
        return body;
      }
      throw Exception(body['message']);
    } else {
      final body = jsonDecode(response.body);
      throw Exception(body['message'] ?? 'Login failed');
    }
  }

  Future<Map<String, dynamic>> register(String name, String username, String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      body: jsonEncode({
        'name': name,
        'username': username,
        'email': email,
        'password': password
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final body = jsonDecode(response.body);
      if (body['status'] == true) {
        return body;
      }
       throw Exception(body['message']);
    } else {
        // Validation errors likely
        final body = jsonDecode(response.body);
        if (body['errors'] != null) {
            String errorMsg = "";
            (body['errors'] as Map<String, dynamic>).forEach((key, value){
                errorMsg += "$key: ${(value as List).first}\n";
            });
            throw Exception(errorMsg.trim());
        }
        throw Exception(body['message'] ?? 'Registration failed');
    }
  }

  Future<void> logout() async {
    if (_token == null) return;
    try {
      final url = Uri.parse('$baseUrl/auth/logout');
      await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $_token',
        },
      );
    } catch (_) {
      // Ignore logout errors
    } finally {
      _token = null;
    }
  }

  Future<List<Product>> getProducts() async {
    final url = Uri.parse('$baseUrl/products');
    final response = await http.get(url, headers: {'Accept': 'application/json'});

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (body['success'] == true && body['data'] is List) {
        return (body['data'] as List).map((json) => Product.fromJson(json)).toList();
      }
      return [];
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<Map<String, dynamic>> updateProfile({
    required String name,
    required String username,
    required String email,
    String? imagePath,
  }) async {
    if (_token == null) throw Exception('Not authenticated');

    final url = Uri.parse('$baseUrl/auth/update-profile');
    var request = http.MultipartRequest('POST', url);
    
    // Add headers
    request.headers['Authorization'] = 'Bearer $_token';
    request.headers['Accept'] = 'application/json';
    
    // Add text fields
    request.fields['name'] = name;
    request.fields['username'] = username;
    request.fields['email'] = email;
    
    // Add image file if provided
    if (imagePath != null && imagePath.isNotEmpty) {
      var file = await http.MultipartFile.fromPath(
        'profile_image',
        imagePath,
      );
      request.files.add(file);
    }
    
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (body['status'] == true) {
        return body;
      }
      throw Exception(body['message']);
    } else {
      final body = jsonDecode(response.body);
      if (body['errors'] != null) {
        String errorMsg = "";
        (body['errors'] as Map<String, dynamic>).forEach((key, value) {
          errorMsg += "$key: ${(value as List).first}\n";
        });
        throw Exception(errorMsg.trim());
      }
      throw Exception(body['message'] ?? 'Profile update failed');
    }
  }
}
