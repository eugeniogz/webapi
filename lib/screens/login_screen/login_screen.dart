import 'package:flutter/material.dart';
import 'package:memo_webapi/models/user.dart';

import 'package:memo_webapi/services/user_service.dart';

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
              SizedBox(
                  width: 290.0,
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: "e-mail",
                      // label: Text("e-mails"),
                      // hintText: "e-mail",
                      border: OutlineInputBorder()),
                    controller: emailController,
                  )),
            ],
          ),
          const SizedBox(height: 20,),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(
                width: 290.0,
                child: TextField(
                    decoration: const InputDecoration(
                      labelText: "senha",
                      border: OutlineInputBorder()),
                    controller: passwordController, obscureText: true))
          ]),
          const SizedBox(height: 20,),
          ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor),
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
