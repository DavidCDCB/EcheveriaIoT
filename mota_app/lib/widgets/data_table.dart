import 'package:flutter/material.dart';
import 'package:mota_app/screens/analytics_screen.dart';
// import 'package:intl/intl.dart';
// import 'package:intl/intl.dart';

class DaTable extends StatefulWidget {
  final List data;
  const DaTable({Key? key, required this.data}) : super(key: key);

  @override
  State<DaTable> createState() => _DaTableState();
}

class _DaTableState extends State<DaTable> {
  bool isAscending = false;
  bool isFiltered = false;
  late String date;
  List filteredData = [];
  // _DaTableState() {
  //   filteredData = widget.data;
  // }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _filters(),
          DataTable(
            columns: <DataColumn>[
              DataColumn(
                onSort: (columnIndex, ascending) => isFiltered
                    ? _onSorting(
                        filteredData, columnIndex, ascending, "FechaCompleta")
                    : _onSorting(
                        widget.data, columnIndex, ascending, "FechaCompleta"),
                label: const Expanded(
                  child: Text(
                    'Fecha',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.black,
                      /* fontSize: 20.0,*/ fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const DataColumn(
                label: Expanded(
                  child: Text(
                    'Hora',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.black,
                      /* fontSize: 20.0,*/ fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              DataColumn(
                onSort: (columnIndex, ascending) => isFiltered
                    ? _onSorting(
                        filteredData, columnIndex, ascending, "Humedad_a")
                    : _onSorting(
                        widget.data, columnIndex, ascending, "Humedad_a"),
                label: const Expanded(
                  child: Text(
                    'Hum. aire',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.black,
                      /* fontSize: 20.0,*/ fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              DataColumn(
                onSort: (columnIndex, ascending) => isFiltered
                    ? _onSorting(
                        filteredData, columnIndex, ascending, "Humedad_t")
                    : _onSorting(
                        widget.data, columnIndex, ascending, "Humedad_t"),
                label: const Expanded(
                  child: Text(
                    'Hum. tierra',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.black,
                      /* fontSize: 20.0,*/ fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              DataColumn(
                onSort: (columnIndex, ascending) => isFiltered
                    ? _onSorting(
                        filteredData, columnIndex, ascending, "Temperatura_a")
                    : _onSorting(
                        widget.data, columnIndex, ascending, "Temperatura_a"),
                label: const Expanded(
                  child: Text(
                    'Temp. aire',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.black,
                      /* fontSize: 20.0,*/ fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              DataColumn(
                onSort: (columnIndex, ascending) => isFiltered
                    ? _onSorting(
                        filteredData, columnIndex, ascending, "Temperatura_t")
                    : _onSorting(
                        widget.data, columnIndex, ascending, "Temperatura_t"),
                label: const Expanded(
                  child: Text(
                    'Temp tierra.',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.black,
                      /* fontSize: 20.0,*/ fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
            rows: isFiltered
                ? _tranformList(filteredData)
                : _tranformList(widget.data),
          ),
        ],
      ),
    );
  }

  _onSorting(dataList, columnIndex, ascending, String key) {
    setState(
      () {
        isAscending = !isAscending;
        isAscending
            ? dataList.sort(
                (a, b) {
                  return b[key].toString().toLowerCase().compareTo(
                        a[key].toString().toLowerCase(),
                      );
                },
              )
            : dataList.sort(
                (b, a) {
                  return b[key].toString().toLowerCase().compareTo(
                        a[key].toString().toLowerCase(),
                      );
                },
              );
      },
    );
  }

  _tranformList(List? dataList) {
    List<DataRow> data = [];
    for (var item in dataList!) {
      data.add(DataRow(cells: <DataCell>[
        DataCell(Text(item["Fecha"])),
        DataCell(Text(item["Hora"])),
        DataCell(Text(item["Humedad_a"].toString())),
        DataCell(Text(item["Humedad_t"].toString())),
        DataCell(Text(item["Temperatura_a"].toString())),
        DataCell(Text(item["Temperatura_t"].toString())),
        // DataCell(Text(item["Temperatura"].toString())),
      ]));
    }
    return data;
  }

  _filters() {
    // dropdownValue = list.first;
    return Row(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ButtonBar(
          // alignment: MainAxisAlignment.start,
          children: [
            OutlinedButton(
              onPressed: () {
                showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2021),
                  lastDate: DateTime(2023),
                ).then((value) {
                  if (value != null) {
                    date =
                        "${value.year}-${value.month < 10 ? "0${value.month}" : value.month}-${value.day < 10 ? "0${value.day}" : value.day}";
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Selected date: $date')),
                    );
                    setState(() {
                      isFiltered = true;
                      filteredData =
                          widget.data.where((i) => i["Fecha"] == date).toList();
                    });
                  }
                });
              },
              child: const Text("Buscar fecha"),
            ),
          ],
        ),
        ButtonBar(
          alignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color.fromARGB(255, 243, 33, 33)),
              ),
              onPressed: () {
                setState(() => isFiltered = false);
              },
              child: const Text("Borrar filtro"),
            ),
          ],
        ),
        ButtonBar(
          alignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => AnalyticsScreen(
                      data: widget.data,
                    ),
                  ),
                );
              },
              child: const Text("Analytics"),
            ),
          ],
        ),
      ],
    );
  }
}
