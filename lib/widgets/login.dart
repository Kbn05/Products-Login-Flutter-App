import 'package:flutter/material.dart';

class LoginBar extends StatelessWidget {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final Size size;
  LoginBar(
      {Key? key,
      required this.usernameController,
      required this.passwordController,
      this.size = const Size(150, 100)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Expanded(
        child: Center(
          child: Column(
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: const OutlineInputBorder(),
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: size.height / 2,
                    horizontal: size.width / 4,
                  ),
                ),
                textAlign: TextAlign.right,
                controller: usernameController,
              ),
              const SizedBox(
                height: 100,
              ),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: size.height /
                        2, // Divide entre 2 para centrar verticalmente
                    horizontal: size.width /
                        4, // Divide entre 4 para centrar horizontalmente
                  ),
                ),
                textAlign: TextAlign.right,
                controller: passwordController,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
