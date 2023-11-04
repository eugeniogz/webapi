import '../../../models/journal.dart';
import 'journal_card.dart';

List<JournalCard> generateListJournalCards(
    {required int windowPage,
    required Map<String, Journal> database,
    required Function refreshFunction}) {
  // Cria uma lista de Cards vazios
  List<JournalCard> list = List.empty(growable: true);

  //Preenche os espaços que possuem entradas no banco
  database.forEach(
    (key, value) {
        list.add(JournalCard(
          showedDate: value.createdAt,
          journal: value,
          refreshFunction: refreshFunction,
        ));
      }     
  );
  return list;
}
