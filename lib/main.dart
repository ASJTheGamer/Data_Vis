import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:excel/excel.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;


void main() {
  runApp(Charts());
}

class PlotData {
  PlotData(this.name, this.population);
  final dynamic name;
  final dynamic population;
}


class Charts extends StatefulWidget {
  const Charts({Key? key}) : super(key: key);

  @override
  State<Charts> createState() => _ChartsState();
}

class _ChartsState extends State<Charts> {

   List<PlotData> Plottingdata = [];

  void getData() async {

    ByteData data = await rootBundle.load('assets/data.xlsx');
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    var excel = Excel.decodeBytes(bytes);

    for (var table in excel.tables.keys) {
      // print(table); //sheet Name
      // print(excel.tables[table]?.maxCols);
      // print(excel.tables[table]?.maxRows);
      for (var row in excel.tables[table]!.rows) {
        Plottingdata.add(PlotData(row[0]!.value, row[1]!.value));
        // Plottingdata ?? print("null");
        // print(row[0]!.value);
      }
      Plottingdata.removeAt(0);
      for(var data in Plottingdata){
        print(data.population);
      }
    }

  }


  @override
  void initState(){
    getData();
    print("hi");
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Scaffold Widget
        home: Scaffold(
            body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(64.0),
                  child: Container(
                      child: SfCartesianChart(
                        // Initialize category axis
                          primaryXAxis: CategoryAxis(),

                          series: <LineSeries<PlotData, dynamic>>[
                            LineSeries<PlotData, dynamic>(
                              // Bind data source
                                dataSource:  Plottingdata,
                                xValueMapper: (PlotData myplot, _) => myplot.name,
                                yValueMapper: (PlotData myplot, _) => myplot.population
                            )
                          ]
                      )
                  ),
                )
            )
        )
    );
  }
}
