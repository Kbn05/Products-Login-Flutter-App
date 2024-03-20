import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jwt_app/widgets/login.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_app/views/viewHome.dart';
import 'package:jwt_app/views/viewSignup.dart';

class ViewLogin extends StatefulWidget {
  const ViewLogin({Key? key}) : super(key: key);

  @override
  State<ViewLogin> createState() => _ViewLoginState();
}

class _ViewLoginState extends State<ViewLogin> {
  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
    _prefs.then((SharedPreferences prefs) {
      final String? token = prefs.getString('token');
      if (token != null) {
        Get.to(const HomeView());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
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
                  Uri.parse('http://192.168.20.20:3000/login'),
                  body: {
                    'username': _controllerUsername.text,
                    'password': _controllerPassword.text,
                  },
                );
                print('Response: ${response.body}');
                if (response.statusCode == 200) {
                  final SharedPreferences prefs = await _prefs;
                  prefs.setString('token', response.body);
                  Get.to(const HomeView());
                } else {
                  print('Error: ${response.statusCode}');
                }
              },
              child: const Text('Login'),
            ),
            ElevatedButton(
                onPressed: () async {
                  Get.to(SignupView());
                },
                child: const Text('Signup')),
          ],
        ),
      ),
    );
  }
}
