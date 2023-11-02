import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/journal.dart';
import 'screens/add_journal_screen/add_journal_screen.dart';
import 'screens/home_screen/home_screen.dart';
import 'screens/login_screen/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Journal',
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.light,
      theme: ThemeData(
        primarySwatch: Colors.grey,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.black,
          titleTextStyle: TextStyle(color: Colors.white),
          actionsIconTheme: IconThemeData(color: Colors.white),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        textTheme: GoogleFonts.bitterTextTheme(),
      ),
      initialRoute: "login",
      routes: {
        "login": (context) => const LoginScreen(),
      },
      onGenerateRoute: (routeSettings) {
        if (routeSettings.name == "add-journal" || routeSettings.name == "edit-journal") {
          final journal = routeSettings.arguments as Journal;
          return MaterialPageRoute(
            builder: (context) {
              return AddJournalScreen(journal: journal, edit: routeSettings.name == "edit-journal");
            },
          );
        }
        else if (routeSettings.name == "home") {
          return MaterialPageRoute(
            builder: (context) {
              return HomeScreen(); //Home Screen não pode ser const porque senão inicializa antes do login
            },
          );
        }
        return null;
      },
    );
  }
}
