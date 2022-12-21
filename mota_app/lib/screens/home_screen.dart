import 'package:flutter/material.dart';
import 'package:mota_app/screens/loading_screen.dart';
import 'package:mota_app/services/db_service2.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
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
                      children: const [
                        Icon(Icons.grass),
                        Text('  BushMonitor')
                      ],
                    )),
                    body: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          snapshot.data as Widget,
                          Image.asset("assets/images/IconMota.png", scale: 3.5),
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
    late List<Widget> tempList;
    double heightScreen = MediaQuery.of(context).size.height;
    await dataService.getLastData().then(
      (value) {
        try {
          int humedadA = int.parse(value!['Humedad_a']);
          int humedadT = int.parse(value['Humedad_t']);
          int temperaturaA = int.parse(value['Temperatura_a']);
          int temperaturaT = int.parse(value['Temperatura_t']);
          tempList = [
            const Text(
              "Última lectura",
              style: TextStyle(color: Colors.blueAccent, fontSize: 40),
            ),
            const SizedBox(height: 10),
            Text(
              "Humedad aire: $humedadA%",
              style: TextStyle(
                color: humedadA < 50 ? Colors.red : Colors.green,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Humedad tierra: $humedadT%",
              style: TextStyle(
                color: humedadT < 50 ? Colors.red : Colors.green,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              "Temperatura aire: $temperaturaA°C",
              style: TextStyle(
                color: temperaturaA > 50 ? Colors.red : Colors.green,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              "Temperatura tierra: $temperaturaT°C",
              style: TextStyle(
                color: temperaturaT > 50 ? Colors.red : Colors.green,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 5),
          ];
        } catch (e) {
          tempList = [
            const Text(
              "Algo salió mal...",
              style: TextStyle(color: Colors.blueAccent, fontSize: 40),
            ),
            const SizedBox(height: 5),
            Text(
              "Error: $e",
              style: const TextStyle(color: Colors.black, fontSize: 20),
            ),
          ];
        }
      },
    );

    return Padding(
      padding: EdgeInsets.symmetric(vertical: heightScreen * 0.08),
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
              children: tempList,
            ),
          ),
        ),
      ),
    );
  }

  Text _a(String text, int value) {
    return Text(
      "$text: $value",
      style: TextStyle(
        color: value > 50 ? Colors.red : Colors.green,
        fontSize: 20,
      ),
    );
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
