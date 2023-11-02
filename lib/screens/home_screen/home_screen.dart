import 'package:flutter/material.dart';
import 'package:flutter_webapi_first_course/screens/home_screen/widgets/home_screen_list.dart';
import 'package:flutter_webapi_first_course/services/journal_service.dart';
import '../../services/user_service.dart';

import '../../models/journal.dart';
import '../../helpers/globals.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});
  final UserService userService = UserService();
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // O último dia apresentado na lista
  DateTime currentDay = DateTime.now().toUtc();

  // Tamanho da lista
  int windowPage = 10;

  // A base de dados mostrada na lista
  Map<String, Journal> database = {};
  
  final ScrollController _listScrollController = ScrollController();
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
        title: Text("${currentDay.day}  |  ${currentDay.month}  |  ${currentDay.year}  (${user?.email})",),
        actions: [
          IconButton( onPressed: () {
              refresh();
            },
            icon: const Icon(Icons.refresh,),
          ),
        ],
      ),
      body: FutureBuilder(
        future: refresh(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            return ListView(
              controller: _listScrollController,
              children: generateListJournalCards(
                windowPage: windowPage,
                currentDay: currentDay,
                database: database,
                refreshFunction: refresh,
              ),
            );
          } else if (snapshot.hasError) {
            return 
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Erro: ${snapshot.error}'),
              );
          } else {
            return const Row(
              children: [
             SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Buscando dados...'),
              )
            ]);
          }
        }
      ),
    );
  }

  Future<bool> refresh() async {
    List<Journal> listJournal = await _journalService.getAll(); 
    setState(() {
      database = {};
      for (Journal journal in listJournal) {
        database[journal.id] = journal;
      }

      if (_listScrollController.hasClients) {
        final double position = _listScrollController.position.maxScrollExtent;
        _listScrollController.jumpTo(position);
      }
    });
    return true;
  }
}
