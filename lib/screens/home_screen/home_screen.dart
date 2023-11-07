import 'package:flutter/material.dart';
import 'package:flutter_webapi_first_course/screens/add_journal_screen/add_journal_screen.dart';
import 'package:flutter_webapi_first_course/screens/home_screen/widgets/home_screen_list.dart';
import 'package:flutter_webapi_first_course/services/journal_service.dart';
import 'package:uuid/uuid.dart';

import '../../helpers/globals.dart';
import '../../models/journal.dart';
import '../../services/user_service.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});
  final UserService userService = UserService();
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // O último dia apresentado na lista
  DateTime currentDay = DateTime.now();

  // Tamanho da lista
  int windowPage = 10;

  // A base de dados mostrada na lista
  Map<String, Journal> database = {};

  // final ScrollController _listScrollController = ScrollController();
  final JournalService _journalService = JournalService();

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Título basado no dia atual
        title: Text(
          "${currentDay.day}  |  ${currentDay.month}  |  ${currentDay.year}  (${user?.email})",
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                refresh();
              });
            },
            icon: const Icon(
              Icons.refresh,
            ),
          ),
          IconButton(
            onPressed: () {
              logout();
            },
            icon: const Icon(
              Icons.logout,
            ),
          ),
        ],
      ),
      // body: GridView(
      // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      //   crossAxisCount: 2,
      //   childAspectRatio: 1.0,
      // ),

      body: Flow(
        delegate: MyFlowDelegate(),
        children: generateListJournalCards(
          windowPage: windowPage,
          database: database,
          refreshFunction: refresh,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            callAddJournalScreen(context);
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  refresh() async {
    List<Journal> listJournal = [];
    await _journalService
        .getAll(listJournal) //;
        .catchError((onError) {
      Navigator.pushReplacementNamed(context, 'login');
      return null;
    });

    setState(() {
      database = {};
      for (Journal journal in listJournal) {
        database[journal.id] = journal;
      }
    });
    return true;
  }

  logout() {
    user = null;
    accessToken = null;
    Navigator.pushReplacementNamed(context, 'login');
  }

  callAddJournalScreen(BuildContext context) {
    Navigator.pushNamed(
      context,
      'add-journal',
      arguments: Journal(
        id: const Uuid().v1(),
        content: "",
        createdAt: currentDay,
        updatedAt: currentDay,
      ),
    ).then((value) {
      if (value == DisposeStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Houve uma falha ao registar."),
          ),
        );
      }
      refresh();
    });
  }
}

class MyFlowDelegate extends FlowDelegate {
  @override
  void paintChildren(FlowPaintingContext context) {
    // Layout the children here.
    // final size = context.size;
    double y = 0;
    for (int i = 0; i < context.childCount; i++) {
      context.paintChild(i, transform: Matrix4.translationValues(0, y, 0));
      y += context.getChildSize(i)!.height;
    }
  }

  @override
  bool shouldRepaint(FlowDelegate oldDelegate) {
    // Return true if the delegate needs to be repainted.
    return true;
  }
}
