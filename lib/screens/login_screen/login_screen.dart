import 'package:flutter/material.dart';

import '../../models/user.dart';
import '../../services/user_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final UserService userService = UserService();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Título basado no dia atual
          title: const Text(
            "Login",
          ),
        ),
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 50.0, child: Text("e-mail:")),
              SizedBox(
                  width: 240.0,
                  child: TextField(
                    controller: emailController,
                  )),
            ],
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const SizedBox(width: 50.0, child: Text("senha:")),
            SizedBox(
                width: 240.0,
                child: TextField(
                    controller: passwordController, obscureText: true))
          ]),
          TextButton(
              style: TextButton.styleFrom(
                elevation: 10,
              ),
              onPressed: () {
                login()
                    .then((value) =>
                        Navigator.pushReplacementNamed(context, 'home'))
                    .catchError((e) => {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(e.toString()),
                            ),
                          )
                        });
              }, child: const Text("Login"))]));
  }

  Future<void> login() async {
    User user =
        User(email: emailController.text, password: passwordController.text);
    await userService.login(user);
  }
}
