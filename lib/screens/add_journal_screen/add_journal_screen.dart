import 'package:flutter/material.dart';
import 'package:flutter_webapi_first_course/helpers/weekday.dart';
import 'package:flutter_webapi_first_course/models/journal.dart';
import 'package:flutter_webapi_first_course/services/journal_service.dart';

class AddJournalScreen extends StatefulWidget {
  final Journal journal;
  final bool edit;
  const AddJournalScreen(
      {super.key, required this.journal, required this.edit});

  @override
  State<AddJournalScreen> createState() => _AddJournalScreenState();
}

class _AddJournalScreenState extends State<AddJournalScreen> {
  TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    contentController.text = widget.journal.content;
    return Scaffold(
      appBar: AppBar(
        title: Text(WeekDay(widget.journal.createdAt).toString()),
        actions: [
          IconButton(
            onPressed: () {
              widget.edit?editJournal(context):registerJournal(context);
            },
            icon: const Icon(Icons.check),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: TextField(
          controller: contentController,
          keyboardType: TextInputType.multiline,
          style: const TextStyle(fontSize: 24),
          expands: true,
          maxLines: null,
          minLines: null,
        ),
      ),
    );
  }

  registerJournal(BuildContext context) async {
    JournalService journalService = JournalService();
    widget.journal.content = contentController.text;
    journalService.register(widget.journal).then((value) {
      if (value) {
        Navigator.pop(context, DisposeStatus.success);
      } else {
        Navigator.pop(context, DisposeStatus.error);
      }
    });
  }

  editJournal(BuildContext context) async {
    JournalService journalService = JournalService();
    widget.journal.content = contentController.text;
    journalService.edit(widget.journal).then((value) {
      if (value) {
        Navigator.pop(context, DisposeStatus.success);
      } else {
        Navigator.pop(context, DisposeStatus.error);
      }
    });
  }
  
  
}

enum DisposeStatus { exit, error, success }
