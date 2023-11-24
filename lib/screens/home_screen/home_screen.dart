import 'package:flutter/material.dart';
import 'package:memo_webapi/screens/edit_journal_screen/edit_journal_screen.dart';
import 'package:memo_webapi/services/journal_service.dart';
import 'package:uuid/uuid.dart';

import '../../models/journal.dart';
import '../../services/user_service.dart';
import 'widgets/journal_card.dart';

class HomeScreen extends StatefulWidget {
  final bool auth;
  HomeScreen(this.auth, {super.key});
  final UserService userService = UserService();
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // O último dia apresentado na lista
  DateTime currentDay = DateTime.now();

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
    List<Widget> listActions = [];
    listActions.add(IconButton(
      onPressed: () {
        refresh();
      },
      icon: const Icon(
        Icons.refresh,
      ),
    ));

    if (widget.auth) {
      listActions.add(IconButton(
          onPressed: () {
            widget.userService.logout().then(
                (value) => Navigator.pushReplacementNamed(context, 'login'));
          },
          icon: const Icon(
            Icons.logout,
          )));
    }
    return Scaffold(
      appBar: AppBar(
        // Título basado no dia atual
        title: Text(
          "${currentDay.day}/${currentDay.month}/${currentDay.year}",
        ),
        actions: listActions,
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints boxConstraints) {
          var colWidth = (boxConstraints.maxWidth-5)/2;
          return 
          SingleChildScrollView(child: Flex(direction: Axis.horizontal,
            children : [
            SizedBox(width: colWidth,
            child: Flex(direction: Axis.vertical,
            // Flow(
            //   delegate: MyFlowDelegate(),
              children: generateListJournalCards(
                width: colWidth,
                column: 1,
                database: database,
                refreshFunction: refresh,
              ),
          ),
        ), 
          SizedBox(width: colWidth,
            child: Flex(direction: Axis.vertical,
            // Flow(
            //   delegate: MyFlowDelegate(),
              children: generateListJournalCards(
                width: colWidth,
                column: 2,
                database: database,
                refreshFunction: refresh,
              ),
          ),
        )]));
          },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          callAddJournalScreen(context);
        },
        child: const Icon(
          color: Colors.white,
          Icons.add),
      ),
    );
  }

  refresh() {
    _journalService
        .getAll()
        .then((listJournal) {
          setState(() {
            database = {};
            for (Journal journal in listJournal) {
              database[journal.id] = journal;
            }
          });
        })
        .catchError((onError) {
          Navigator.pushReplacementNamed(context, 'login');
        });
  }

  callAddJournalScreen(BuildContext context) {
    Navigator.pushNamed(
      context,
      'add-journal',
      arguments: Journal(
        id: const Uuid().v1(),
        content: "",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
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

  List<JournalCard> generateListJournalCards(
    {required double width, required int column,
    required Map<String, Journal> database,
    required Function refreshFunction}) {
    // Cria uma lista de Cards vazios
    List<JournalCard> list = List.empty(growable: true);

    //Preenche os espaços que possuem entradas no banco
    for (var i=column==1?0:1; i<database.values.length; i+=2)
    {
        var value = database.values.elementAt(i);
        list.add(JournalCard(
          width: width,
          showedDate: value.createdAt,
          journal: value,
          refreshFunction: refreshFunction,
        ));
    }
    return list;
  }

}

class MyFlowDelegate extends FlowDelegate {
  @override
  void paintChildren(FlowPaintingContext context) {
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
