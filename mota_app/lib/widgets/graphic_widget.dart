import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GraphicsWidget extends StatefulWidget {
  final List data;
  final String dataNameOne;
  final String dataNameTwo;
  const GraphicsWidget(
      {Key? key,
      required this.data,
      required this.dataNameOne,
      required this.dataNameTwo})
      : super(key: key);

  @override
  State<GraphicsWidget> createState() => _GraphicsWidgetState();
}

class _GraphicsWidgetState extends State<GraphicsWidget> {
  @override
  Widget build(BuildContext context) {
    String title = widget.dataNameOne.split("_")[0];
    return chart("$title por día", widget.dataNameOne, widget.dataNameTwo);
  }

  chart(String title, String lineNameOne, String lineNameTwo) {
    return //Initialize the chart widget
        SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      // Chart title
      title: ChartTitle(text: title),
      // Enable legend
      legend: Legend(isVisible: true),
      // Enable tooltip
      tooltipBehavior: TooltipBehavior(enable: true),
      series: <ChartSeries<dynamic, String>>[
        LineSeries<dynamic, String>(
          dataSource: _sortData(widget.data),
          xValueMapper: (dynamic meassure, _) => meassure["Hora"].toString(),
          yValueMapper: (dynamic meassure, _) => meassure[lineNameOne],
          name: lineNameOne,
          // Enable data label
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        ),
        LineSeries<dynamic, String>(
          dataSource: _sortData(widget.data),
          xValueMapper: (dynamic meassure, _) => meassure["Hora"].toString(),
          yValueMapper: (dynamic meassure, _) => meassure[lineNameTwo],
          name: lineNameTwo,
          // Enable data label
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        ),
      ],
    );
  }

  List _sortData(List list) {
    list.sort(
      (b, a) {
        return b["FechaCompleta"].toString().toLowerCase().compareTo(
              a["FechaCompleta"].toString().toLowerCase(),
            );
      },
    );
    return list;
  }
}
