import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_app/widgets/login.dart';

class SignupView extends StatelessWidget {
  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SignUp'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            LoginBar(
              usernameController: _controllerUsername,
              passwordController: _controllerPassword,
            ),
            ElevatedButton(
              onPressed: () async {
                print('Username: ${_controllerUsername.text}');
                print('Password: ${_controllerPassword.text}');
                final response = await http.post(
                  Uri.parse('http://192.168.20.20:3000/signup'),
                  body: {
                    'username': _controllerUsername.text,
                    'password': _controllerPassword.text,
                  },
                );
                print('Response: ${response.body}');
                if (response.statusCode == 200) {
                  Get.offAllNamed('/');
                } else {
                  print('Error: ${response.statusCode}');
                }
              },
              child: const Text('Register'),
            ),
            ElevatedButton(
                onPressed: () async {
                  Get.offAllNamed('/');
                },
                child: const Text('Back')),
          ],
        ),
      ),
    );
  }
}
