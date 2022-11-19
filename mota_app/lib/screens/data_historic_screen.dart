import 'package:flutter/material.dart';
import 'package:mota_app/screens/loading_screen.dart';
import 'package:mota_app/services/db_service2.dart';
import 'package:mota_app/widgets/data_table.dart';

class DataHistoricScreen extends StatefulWidget {
  const DataHistoricScreen({Key? key}) : super(key: key);

  @override
  State<DataHistoricScreen> createState() => _DataHistoricScreenState();
}

class _DataHistoricScreenState extends State<DataHistoricScreen> {
  DBService2 service = DBService2();
  List list = [];
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: service.alldataStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return FutureBuilder(
              future: service.getAllData(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Scaffold(
                    appBar: AppBar(
                        title: Row(
                      children: const [Icon(Icons.sensors), Text('  Lecturas')],
                    )),
                    body: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              // child: ListView(
                              //   children: _lista(snapshot.data as List),
                              // ),
                              child: DaTable(data: snapshot.data as List),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  // return Text("${snapshot.hasData}");
                  return const LoadingScreen();
                }
              },
            );
          } else {
            return const LoadingScreen();
          }
        });
  }
}
