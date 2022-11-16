import 'package:firebase_database/firebase_database.dart';

class DBService2 {
  DatabaseReference ref = FirebaseDatabase.instance.ref("apimataHistorico");

  Stream<DatabaseEvent> dataStream() {
    return ref.onChildAdded;
  }

  Future<List?> getData() async {
    DatabaseEvent event = await ref.once();
    Map? res = event.snapshot.value as Map?;

    if (event.snapshot.value.toString() != "null") {
      return sortData(res);
    }

    return [];
  }

  List sortData(Map? res) {
    List<dynamic> _list = [];
    for (var item in res!.keys) {
      // res[item]["Fecha"]
      // var parsedDate = DateTime.parse('1974-03-20 00:00:00.000');
      String fecha = res[item]["Fecha"];
      String hora = res[item]["Hora"];
      var parsedDate = fecha + " " + hora;
      _list.add({
        "Fecha": parsedDate,
        "Humedad": res[item]["Humedad"],
        "Temperatura": res[item]["Temperatura"],
      });
    }
    // _list.sort((a, b) => a.Fecha.compareTo(b.Fecha));
    _list.sort(
      (a, b) {
        return b["Fecha"].toString().toLowerCase().compareTo(
              a["Fecha"].toString().toLowerCase(),
            );
      },
    );
    return _list;
  }
}
