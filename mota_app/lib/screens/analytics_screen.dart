import 'package:flutter/material.dart';
import 'package:mota_app/widgets/graphic_widget.dart';

class AnalyticsScreen extends StatefulWidget {
  final List data;
  const AnalyticsScreen({Key? key, required this.data}) : super(key: key);

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  DateTime today = DateTime.now();
  String date = "";
  List filteredData = [];
  bool filtered = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [Icon(Icons.bar_chart_sharp), Text('  Analytics')],
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            // filtered ? Text(date) : const Text(""),
            _button(),
            GraphicsWidget(
              data: filteredData,
              dataNameOne: "Humedad_a",
              dataNameTwo: "Humedad_t",
            ),
            GraphicsWidget(
              data: filteredData,
              dataNameOne: "Temperatura_a",
              dataNameTwo: "Temperatura_t",
            ),
          ],
        ),
      ),
    );
  }

  _button() {
    return ButtonBar(
      // alignment: MainAxisAlignment.end,
      children: [
        filtered ? Text(date) : const Text(""),
        OutlinedButton(
          onPressed: () {
            showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2021),
              lastDate: DateTime(2023),
            ).then((value) {
              if (value != null) {
                filtered = true;
                date =
                    "${value.year}-${value.month < 10 ? "0${value.month}" : value.month}-${value.day < 10 ? "0${value.day}" : value.day}";
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Selected date: $date')),
                );
                setState(() {
                  filteredData =
                      widget.data.where((i) => i["Fecha"] == date).toList();
                });
              }
            });
          },
          child: const Text("Buscar fecha"),
        ),
      ],
    );
  }
}
