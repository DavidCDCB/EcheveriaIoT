import 'package:flutter/material.dart';
import 'package:mota_app/screens/loading_screen.dart';
import 'package:mota_app/services/db_service2.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DBService2 dataService = DBService2();
  var lastData = {};
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: dataService.dataStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return FutureBuilder(
              future: _actualCard(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Scaffold(
                    appBar: AppBar(
                        title: Row(
                      children: const [Icon(Icons.grass), Text('  MotaApp')],
                    )),
                    body: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          snapshot.data as Widget,
                          // _dataActual(),
                          // Flexible(
                          //   child: ListView(
                          //     padding: const EdgeInsets.all(8),
                          //     children: snapshot.data as List<Widget>,
                          //   ),
                          // ),
                          Image.asset("assets/images/IconMota.png", scale: 6),
                          _datosAdicionales(),
                        ],
                      ),
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

  Future<Widget> _actualCard() async {
    late List<Widget> _tempList;
    await dataService.getLastData().then(
      (value) {
        try {
          var humedad = int.parse(value!['Humedad']);
          var temperatura = int.parse(value['Temperatura']);
          _tempList = [
            const Text(
              "Última lectura",
              style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 40,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Humedad: $humedad",
              style: TextStyle(
                color: humedad > 50 ? Colors.red : Colors.green,
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              "Temperatura: $temperatura",
              style: TextStyle(
                color: temperatura > 50 ? Colors.red : Colors.green,
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              "Temperatura: $temperatura",
              style: TextStyle(
                color: temperatura > 50 ? Colors.red : Colors.green,
                fontSize: 20,
              ),
            ),
          ];
        } catch (e) {
          _tempList = [
            const Text(
              "Algo salió mal...",
              style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 40,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              "Error: $e",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
          ];
        }
      },
    );

    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.1),
      child: Center(
        child: Card(
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              color: Colors.greenAccent,
            ),
            borderRadius: BorderRadius.circular(20.0), //<-- SEE HERE
          ),
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: _tempList,
            ),
          ),
        ),
      ),
    );
    ;
  }

  _datosAdicionales() {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.1),
      child: ButtonBar(
        alignment: MainAxisAlignment.center,
        children: [
          OutlinedButton(
            onPressed: () {
              Navigator.pushNamed(context, "dataHistoric");
            },
            child: const Text("Datos adicionales"),
          ),
        ],
      ),
    );
  }
}
