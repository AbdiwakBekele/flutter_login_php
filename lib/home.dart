import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String? name;

  Future<void> login() async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1/projects/flutter_api_updated/login.php'),
      body: {
        'email': usernameController.text,
        'password': passwordController.text,
      },
    );

    final Map<String, dynamic> data = json.decode(response.body);

    if (data['success']) {
      // Navigate to the next screen or perform desired action
      print(data['token']);
      print('Login successful');
    } else {
      // Show an error message or handle the failure
      print('Login failed');
    }
  }

  Future<void> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    if (token != null) {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await http.get(
        Uri.parse('http://your_php_server/fetch_data.php'),
        headers: headers,
      );

      // Process the response as needed
    } else {
      // Handle case where token is not available (user is not authenticated)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: login,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
