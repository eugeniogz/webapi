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
        title: const Text("Login",),
        actions: [
          IconButton( onPressed: () {
              try {
                login().then((value) => Navigator.pushNamed(context, 'home'));
              } on Exception catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("${e.toString()} Login inválido!"), ),
                );
              }
            },
            icon: const Icon(Icons.login,),
          ),
        ],
      ),
      body:  Column(mainAxisAlignment: MainAxisAlignment.center,
        children: [ Row(crossAxisAlignment: CrossAxisAlignment.center, children: [const Text("e-mail:"),SizedBox(
            width: 40.0, child: TextFormField(controller: emailController, )),],),
                    Row(crossAxisAlignment: CrossAxisAlignment.center, children: [const Text("senha:"), SizedBox(
            width: 40.0, child: TextFormField(controller: passwordController, obscureText: true ))]),
        ])
    );
  }

  Future<void> login() async {
    User user = User(email: emailController.text, password: passwordController.text);
    await userService.login(user);
  }
}