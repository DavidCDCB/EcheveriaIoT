import 'package:firebase_database/firebase_database.dart';

class DBService {
  List dataList = [];

  Future<List> getDataString() async {
    await loadData();
    return dataList;
  }

  Future<List> loadData() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("apimataHistorico");
    DatabaseEvent event = await ref.once();
    Map? res = event.snapshot.value as Map?;
    for (var item in res!.keys) {
      print(res[item].runtimeType);
      dataList.add(res[item]);
    }
    return dataList;
  }
}
