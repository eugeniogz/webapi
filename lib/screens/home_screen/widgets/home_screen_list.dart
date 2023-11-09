import '../../../models/journal.dart';
import 'journal_card.dart';

List<JournalCard> generateListJournalCards(
    {required int column,
    required Map<String, Journal> database,
    required Function refreshFunction}) {
  // Cria uma lista de Cards vazios
  List<JournalCard> list = List.empty(growable: true);

  //Preenche os espaços que possuem entradas no banco
  for (var i=column==1?0:1; i<database.values.length; i+=2)
  {
      var value = database.values.elementAt(i);
      list.add(JournalCard(
        showedDate: value.createdAt,
        journal: value,
        refreshFunction: refreshFunction,
      ));
  }
  return list;
}
