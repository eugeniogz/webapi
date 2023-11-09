import 'package:flutter/material.dart';
import 'package:flutter_webapi_first_course/models/journal.dart';
import 'package:flutter_webapi_first_course/screens/edit_journal_screen/edit_journal_screen.dart';

class JournalCard extends StatefulWidget {
  final Journal journal;
  final DateTime showedDate;
  final Function refreshFunction;
  const JournalCard({
    super.key,
    required this.journal,
    required this.showedDate,
    required this.refreshFunction,
  });

  @override
  State<JournalCard> createState() => _JournalCardState();
}

class _JournalCardState extends State<JournalCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        color: Colors.amber[100],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(widget.journal.content, softWrap: true, overflow: TextOverflow.fade, style: const TextStyle(color: Colors.black)),
        ),
      ),
      onTap: () {
        callEditJournalScreen(context, widget.journal);
      },
    );
  }

  callEditJournalScreen(BuildContext context, Journal? journal) {
    Navigator.pushNamed(
      context,
      'edit-journal',
      arguments: Journal(
        id: journal!.id,
        content: journal.content,
        createdAt: journal.createdAt,
        updatedAt: journal.updatedAt,
      ),
    ).then((value) {
      if (value == DisposeStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Erro inesperado."),
          ),
        );
      }
      widget.refreshFunction();
    });
  }
}
