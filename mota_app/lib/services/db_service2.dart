import 'package:firebase_database/firebase_database.dart';

class DBService2 {
  DatabaseReference ref1 = FirebaseDatabase.instance.ref("apimataHistorico");
  DatabaseReference ref2 = FirebaseDatabase.instance.ref("apimata");

  Stream<DatabaseEvent> alldataStream() {
    // return ref1.onValue;
    return ref1.onValue;
  }

  Stream<DatabaseEvent> dataStream() {
    return ref2.onValue;
    // return ref2.onChildChanged;
  }

  Future<Map?> getLastData() async {
    DatabaseEvent event = await ref2.once();
    Map? res = event.snapshot.value as Map?;
    if (event.snapshot.value.toString() != "null") {
      return res;
    }
    return {};
  }

  Future<List?> getAllData() async {
    DatabaseEvent event = await ref1.once();
    Map? res = event.snapshot.value as Map?;

    if (event.snapshot.value.toString() != "null") {
      return sortData(res);
    }

    return [];
  }

  List sortData(Map? res) {
    List<dynamic> _list = [];
    for (var item in res!.keys) {
      _list.add({
        "FechaCompleta": res[item]["Fecha"] + res[item]["Hora"],
        "Fecha": res[item]["Fecha"],
        "Hora": res[item]["Hora"],
        "Humedad": res[item]["Humedad"],
        "Temperatura": res[item]["Temperatura"],
      });
    }
    _list.sort(
      (a, b) {
        return b["FechaCompleta"].toString().toLowerCase().compareTo(
              a["FechaCompleta"].toString().toLowerCase(),
            );
      },
    );
    return _list;
  }
}
