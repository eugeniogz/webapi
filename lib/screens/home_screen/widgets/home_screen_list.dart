import '../../../models/journal.dart';
import 'journal_card.dart';

List<JournalCard> generateListJournalCards(
    {required int windowPage,
    required DateTime currentDay,
    required Map<String, Journal> database,
    required Function refreshFunction}) {
  // Cria uma lista de Cards vazios
  List<JournalCard> list = List.generate(
    windowPage + 1,
    (index) => JournalCard(
      refreshFunction: refreshFunction,
      showedDate: currentDay.subtract(Duration(
        days: (windowPage) - index,
      )),
    ),
  );

  //Preenche os espaços que possuem entradas no banco
  database.forEach(
    (key, value) {
      Duration duration = value.createdAt.difference(currentDay.subtract(Duration(days: windowPage)));
      int difference = (duration.inMinutes/(60.0*24)).ceil();

      if (difference>=0 && difference<=windowPage) {
        list[difference] = JournalCard(
          showedDate: value.createdAt,
          journal: value,
          refreshFunction: refreshFunction,
        );
      }     
    },
  );
  return list;
}
