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
    List<dynamic> list = [];
    for (var item in res!.keys) {
      list.add({
        "FechaCompleta":
            DateTime.parse("${res[item]['Fecha']} ${res[item]['Hora']}"),
        "Fecha": res[item]["Fecha"],
        "Hora": res[item]["Hora"],
        "Humedad_a": int.parse(res[item]["Humedad_a"].toString()),
        "Humedad_t": int.parse(res[item]["Humedad_t"].toString()),
        "Temperatura_a": int.parse(res[item]["Temperatura_a"].toString()),
        "Temperatura_t": int.parse(res[item]["Temperatura_t"].toString()),
      });
    }
    list.sort(
      (a, b) {
        return b["FechaCompleta"].toString().toLowerCase().compareTo(
              a["FechaCompleta"].toString().toLowerCase(),
            );
      },
    );
    return list;
  }
}
