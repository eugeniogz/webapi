import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:memo_webapi/helpers/globals.dart';
import 'package:memo_webapi/services/journal_service.dart';

// import 'package:google_fonts/google_fonts.dart';

import 'package:memo_webapi/models/journal.dart';
import 'package:memo_webapi/screens/edit_journal_screen/edit_journal_screen.dart';
import 'package:memo_webapi/screens/home_screen/home_screen.dart';
import 'package:memo_webapi/screens/login_screen/login_screen.dart';
import 'package:memo_webapi/services/user_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: chekcAccessToken(),
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != "F") {
              return mainAppScreen(true, snapshot.data != "V");
            } else {
              return mainAppScreen(false, true);
            }
          } else {
            return const Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center , 
              children: [SizedBox(height: 50, child: CircularProgressIndicator())]);
          }
        });
  }

  Future<String> chekcAccessToken() async {
    // Executar com server sem auth
    // UserService userService = UserService();
    // User user = User(email: "k@ufmg.br", password: "12345aB");
    // userService.register(user);
    JournalService journalService = JournalService();
    try {
      await journalService.get("1234");
      return "V";
    } catch (err) {
      log(err.toString());
      UserService userService = UserService();
      await userService.readCachedToken();
      return accessToken==null?"F":accessToken!;
    }
  }

  Widget mainAppScreen(bool home, bool auth) {
    String initialRoute = home ? "home" : "login";
    return MaterialApp(
      title: 'Simple Journal',
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        // textTheme: GoogleFonts.bitterTextTheme(),
      ),
      initialRoute: initialRoute,
      routes: {
        initialRoute: (context) => home ? HomeScreen(auth) : const LoginScreen(),
      },
      onGenerateRoute: (routeSettings) {
        if (routeSettings.name == "add-journal" ||
            routeSettings.name == "edit-journal") {
          final journal = routeSettings.arguments as Journal;
          return MaterialPageRoute(
            builder: (context) {
              return EditJournalScreen(
                  journal: journal, edit: routeSettings.name == "edit-journal");
            },
          );
        } else if (routeSettings.name == (home ? "login" : "home")) {
          return MaterialPageRoute(
            builder: (context) {
              return home ? const LoginScreen() : HomeScreen(auth);
            },
          );
        }
        return null;
      },
    );
  }
}
