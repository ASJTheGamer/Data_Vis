import 'package:data_vis/loadfile.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:excel/excel.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;


void main() {
  runApp(Load());
}

class PlotData {
  PlotData(this.name, this.population);
  final dynamic name;
  late final dynamic population;
}


class Charts extends StatefulWidget {
  //const Charts({Key? key}) : super(key: key);

  String filePath;
  Charts(this.filePath);


  @override
  State<Charts> createState() => _ChartsState(filePath);
}

class _ChartsState extends State<Charts> {

  String filePath;
  _ChartsState(this.filePath);

  List<PlotData> Plottingdata = [];
  Map<dynamic,dynamic> temp = {};



  void getData() async {
    print(filePath);

    var file = filePath;
    var bytes = File(file).readAsBytesSync();
    var excel = Excel.decodeBytes(bytes);


    // ByteData data = await rootBundle.load('assets/Financial_Sample.xlsx');
    // var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    // var excel = Excel.decodeBytes(bytes);

    for (var table in excel.tables.keys) {
      // print(table); //sheet Name
      // print(excel.tables[table]?.maxCols);
      // print(excel.tables[table]?.maxRows);
      for (var row in excel.tables[table]!.rows) {

        //checking and adding each value to map to remove redundancy
        if(temp[row[1]!.value] == null){
          temp[row[1]!.value] = row[7]!.value;
        }else{
          temp.update(row[1]!.value, (thisvalue) => thisvalue + row[7]!.value);
        }



        //Plottingdata.add(PlotData(row[1]!.value, row[7]!.value));
        //  print(row[1]!.value);
        //  print(row[7]!.value);
      }

      //transferring data fropm map to list of object
      temp.forEach((k, v) => Plottingdata.add(PlotData(k, v)));

      //print(temp);
      print("check1");
      Plottingdata.removeAt(0); //IMP REMOVE HEADING DATA FROM LIST SO IT CAN BE PLOTTED
      print("check2");
      for(var data in Plottingdata){
        print(data.name);
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
                  padding: const EdgeInsets.all(0.0),
                  child: Container(
                      child: SfCartesianChart(
                        // Initialize category axis
                          primaryXAxis: CategoryAxis(),

                          series: <LineSeries<PlotData, dynamic>>[
                            LineSeries<PlotData, dynamic>(
                              // Bind data source
                                 dataSource:
                              //   <PlotData>[
                              //     PlotData('Jan', 35),
                              //     PlotData('Feb', 28),
                              //
                              //   ],
                              Plottingdata,
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
