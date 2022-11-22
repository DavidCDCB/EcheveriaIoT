import 'package:flutter/material.dart';
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
                        filteredData,
                        columnIndex,
                        ascending,
                        "Humedad",
                      )
                    : _onSorting(
                        widget.data,
                        columnIndex,
                        ascending,
                        "Humedad",
                      ),
                label: const Expanded(
                  child: Text(
                    'Hum.',
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
                        filteredData, columnIndex, ascending, "Temperatura")
                    : _onSorting(
                        widget.data, columnIndex, ascending, "Temperatura"),
                label: const Expanded(
                  child: Text(
                    'Temp.(Tierra)',
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
                        filteredData, columnIndex, ascending, "Temperatura")
                    : _onSorting(
                        widget.data, columnIndex, ascending, "Temperatura"),
                label: const Expanded(
                  child: Text(
                    'Temp.(Aire)',
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
        DataCell(Text(item["Humedad"])),
        DataCell(Text(item["Temperatura"])),
        DataCell(Text(item["Temperatura"])),
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
                    date = "${value.day}/${value.month}/${value.year}";
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
        const SizedBox(
          width: 20,
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
      ],
    );
  }
}
