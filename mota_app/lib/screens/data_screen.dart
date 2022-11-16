import 'package:flutter/material.dart';
import 'package:mota_app/screens/loading_screen.dart';
import 'package:mota_app/services/db_service2.dart';

class DataScreen extends StatefulWidget {
  const DataScreen({Key? key}) : super(key: key);

  @override
  _DataScreenState createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  DBService2 dataService = DBService2();
  var lastData = {};
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: dataService.dataStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return FutureBuilder(
              future: _list(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Scaffold(
                    appBar: AppBar(
                        title: Row(
                      children: const [Icon(Icons.sensors), Text('  Lecturas')],
                    )),
                    body: Column(
                      children: [
                        _dataActual(),
                        Flexible(
                          child: ListView(
                            padding: const EdgeInsets.all(8),
                            children: snapshot.data as List<Widget>,
                          ),
                        ),
                        _datosAdicionales(),
                      ],
                    ),
                  );
                } else {
                  return const LoadingScreen();
                }
              },
            );
          } else {
            return const LoadingScreen();
          }
        });
  }

  Future<List<Widget>> _list() async {
    DBService2 dataService = DBService2();
    List _keys = [];
    List _values = [];
    List<Widget> _data = [];

    await dataService.getData().then((List? res) {
      if (res != null) {
        for (var item in res) {
          _data.add(_tiles(item));
        }
        lastData = res[0];
      }
    });
    _data.add(const SizedBox(
      height: 50,
    ));

    return _data;
  }

  Widget _tiles(var _item) {
    return Container(
      alignment: Alignment.bottomLeft,
      margin: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text("Fecha: ${_item["Fecha"]}"),
            ],
          ),
          const SizedBox(
            height: 1,
          ),
          Row(
            children: [
              Text(
                  "Humedad: ${_item["Humedad"]}, Temperatura: ${_item["Temperatura"]}"),
            ],
          ),
        ],
      ),
    );
  }

  _dataActual() {
    var humedad = int.parse(lastData['Humedad']);
    var temperatura = int.parse(lastData['Temperatura']);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30.0),
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Última lectura",
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    "Humedad: $humedad",
                    style: TextStyle(
                      color: humedad > 50 ? Colors.red : Colors.green,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Temperatura: $temperatura",
                    style: TextStyle(
                      color: temperatura > 50 ? Colors.red : Colors.green,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Temperatura: $temperatura",
                    style: TextStyle(
                      color: temperatura > 50 ? Colors.red : Colors.green,
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  _datosAdicionales() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30.0),
      child: ButtonBar(
        alignment: MainAxisAlignment.center,
        children: [
          OutlinedButton(
            onPressed: () {},
            child: const Text("Datos adicionales"),
          ),
        ],
      ),
    );
  }
}
