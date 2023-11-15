import 'package:flutter/material.dart';
import 'package:memo_webapi/helpers/globals.dart';
// import 'package:google_fonts/google_fonts.dart';

import 'models/journal.dart';
import 'screens/edit_journal_screen/edit_journal_screen.dart';
import 'screens/home_screen/home_screen.dart';
import 'screens/login_screen/login_screen.dart';
import 'services/user_service.dart';

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
              return mainAppScreen(true);
            } else {
              return mainAppScreen(false);
            }
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  Future<String> chekcAccessToken() async {
    UserService userService = UserService();
    await userService.readCachedToken();
    return accessToken==null?"F":accessToken!;
  }

  Widget mainAppScreen(bool home) {
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
        initialRoute: (context) => home ? HomeScreen() : const LoginScreen(),
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
              return home ? const LoginScreen() : HomeScreen();
            },
          );
        }
        return null;
      },
    );
  }
}
