import 'package:flutter/material.dart';
import 'package:memo_webapi/models/journal.dart';
import 'package:memo_webapi/services/journal_service.dart';

class EditJournalScreen extends StatefulWidget {
  final Journal journal;
  final bool edit;
  const EditJournalScreen(
      {super.key, required this.journal, required this.edit});

  @override
  State<EditJournalScreen> createState() => _EditJournalScreenState();
}

class _EditJournalScreenState extends State<EditJournalScreen> {
  TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    contentController.text = widget.journal.content;
    return WillPopScope(
        onWillPop: () async {
          return widget.edit
              ? await editJournal(context)
              : await registerJournal(context);
        },
        child: Scaffold(
          appBar: AppBar(
            title:   Text("${widget.journal.createdAt.day}  |  ${widget.journal.createdAt.month}  |  ${widget.journal.createdAt.year}"),
            actions: [
              IconButton(
                onPressed: () {
                  deleteJournal(context);
                },
                icon: const Icon(Icons.delete),
              ),
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
        ));
  }

  deleteJournal(BuildContext context) async {
    JournalService journalService = JournalService();
    journalService.delete(widget.journal).then((value) {
      if (value) {
        Navigator.pop(context, DisposeStatus.success);
      } else {
        Navigator.pop(context, DisposeStatus.error);
      }
    });
  }

  Future<bool> registerJournal(BuildContext context) async {
    JournalService journalService = JournalService();
    widget.journal.content = contentController.text;
    journalService.register(widget.journal).then((value) {
      if (value) {
        Navigator.pop(context, DisposeStatus.success); //Só faz o pop depois do servidor retornar
      } else {
        Navigator.pop(context, DisposeStatus.error);
      }
    });
    return false; //Retorn a false para o Willpop não chamar pop mais uma vez
  }

  Future<bool> editJournal(BuildContext context) async {
    JournalService journalService = JournalService();
    if (widget.journal.content != contentController.text) {
      widget.journal.content = contentController.text;
      widget.journal.updatedAt = DateTime.now();
    }
    journalService.edit(widget.journal).then((value) {
      if (value) {
        Navigator.pop(context, DisposeStatus.success); //Só faz o pop depois do servidor retornar
      } else {
        Navigator.pop(context, DisposeStatus.error);
      }
    });
    return false; //Retorn a false para o Willpop não chamar pop mais uma vez
  }
}

enum DisposeStatus { exit, error, success }
