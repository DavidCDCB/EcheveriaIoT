import 'dart:math';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

/// Data class to visualize.
class _SalesData {
  final int year = 0;
  final int sales = 0;

  _SalesData(year, sales);
  // Returns Jan.1st of that year as date.
  DateTime get date => DateTime(year);
}

/// Generate some random data.
List<_SalesData> _genRandData() {
  final random = Random();
  // Returns an increasing series with some fluctuations.
  return [
    for (int i = 2005; i < 2020; ++i)
      _SalesData(i, (i - 2000) * 40 + random.nextInt(100)),
  ];
}

class TimeseriesChartExample extends StatefulWidget {
  const TimeseriesChartExample({Key? key}) : super(key: key);

  @override
  _TimeseriesChartExampleState createState() => _TimeseriesChartExampleState();
}

class _TimeseriesChartExampleState extends State<TimeseriesChartExample> {
  // Chart configs.
  bool _animate = true;
  bool _defaultInteractions = true;
  bool _includeArea = true;
  bool _includePoints = true;
  bool _stacked = true;
  charts.BehaviorPosition _titlePosition = charts.BehaviorPosition.bottom;
  charts.BehaviorPosition _legendPosition = charts.BehaviorPosition.bottom;

  // Data to render.
  late List<_SalesData> _series1, _series2;

  @override
  void initState() {
    super.initState();
    _series1 = _genRandData();
    _series2 = _genRandData();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        SizedBox(
          height: 300,
          child: charts.TimeSeriesChart(
            [
              charts.Series<_SalesData, DateTime>(
                id: 'Sales-1',
                colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
                domainFn: (_SalesData sales, _) => sales.date,
                measureFn: (_SalesData sales, _) => sales.sales,
                data: _series1,
              ),
              charts.Series<_SalesData, DateTime>(
                id: 'Sales-2',
                colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
                domainFn: (_SalesData sales, _) => sales.date,
                measureFn: (_SalesData sales, _) => sales.sales,
                data: _series2,
              ),
            ],
            defaultInteractions: _defaultInteractions,
            defaultRenderer: charts.LineRendererConfig(
              includePoints: _includePoints,
              includeArea: _includeArea,
              stacked: _stacked,
            ),
            animate: _animate,
            behaviors: [
              // Add title.
              charts.ChartTitle(
                'Dummy sales time series',
                behaviorPosition: _titlePosition,
              ),
              // Add legend.
              charts.SeriesLegend(position: _legendPosition),
              // Highlight X and Y value of selected point.
              charts.LinePointHighlighter(
                showHorizontalFollowLine:
                    charts.LinePointHighlighterFollowLineType.all,
                showVerticalFollowLine:
                    charts.LinePointHighlighterFollowLineType.nearest,
              ),
            ],
          ),
        ),
        const Divider(),
        ..._controlWidgets(),
      ],
    );
  }

  /// Widgets to control the chart appearance and behavior.
  List<Widget> _controlWidgets() => <Widget>[
        SwitchListTile(
          title: const Text('animate'),
          onChanged: (bool val) => setState(() => _animate = val),
          value: _animate,
        ),
        SwitchListTile(
          title: const Text('defaultInteractions'),
          onChanged: (bool val) => setState(() => _defaultInteractions = val),
          value: _defaultInteractions,
        ),
        SwitchListTile(
          title: const Text('includePoints'),
          onChanged: (bool val) => setState(() => _includePoints = val),
          value: _includePoints,
        ),
        SwitchListTile(
          title: const Text('includeArea'),
          onChanged: (bool val) => setState(() => _includeArea = val),
          value: _includeArea,
        ),
        SwitchListTile(
          title: const Text('stacked'),
          onChanged: (bool val) => setState(() => _stacked = val),
          value: _stacked,
        ),
        ListTile(
          title: const Text('titlePosition:'),
          trailing: DropdownButton<charts.BehaviorPosition>(
            value: _titlePosition,
            onChanged: (charts.BehaviorPosition? newVal) {
              if (newVal != null) {
                setState(() => _titlePosition = newVal);
              }
            },
            items: [
              for (final val in charts.BehaviorPosition.values)
                DropdownMenuItem(value: val, child: Text('$val'))
            ],
          ),
        ),
        ListTile(
          title: const Text('legendPosition:'),
          trailing: DropdownButton<charts.BehaviorPosition>(
            value: _legendPosition,
            onChanged: (charts.BehaviorPosition? newVal) {
              if (newVal != null) {
                setState(() => _legendPosition = newVal);
              }
            },
            items: [
              for (final val in charts.BehaviorPosition.values)
                DropdownMenuItem(value: val, child: Text('$val'))
            ],
          ),
        ),
      ];
}
