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

  List<String> selCoulmn =[];
  Map<String,int> mapCoulmn = {};
  String xaxis="";
  String yaxis="";

  int xaxisdata = 1;
  int yaxisdata = 4;



  void getData(int x , int y) async {
    //print(filePath);

    var file = filePath;
    var bytes = File(file).readAsBytesSync();
    var excel = Excel.decodeBytes(bytes);


    // ByteData data = await rootBundle.load('assets/Financial_Sample.xlsx');
    // var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    // var excel = Excel.decodeBytes(bytes);


    //print("check 0");
    Plottingdata = [];
    temp = {};
    selCoulmn =[];
    mapCoulmn = {};
    //making coulmn name list
    int? maxCol = excel.tables["Sheet1"]?.maxCols;
    for(int i=0;i<maxCol! ; i++){
      selCoulmn.add((excel.tables["Sheet1"]?.rows[0][i]?.value).toString());
    }
    for(int i=0;i<selCoulmn.length;i++){
      //print(selCoulmn[i]);
      mapCoulmn[selCoulmn[i]] = i;
    }
    /*xaxis = selCoulmn[x];
    yaxis = selCoulmn[y];

    int xaxisdata = mapCoulmn[xaxis] ?? 1;
    int yaxisdata = mapCoulmn[yaxis] ?? 4;*/


    for (var table in excel.tables.keys) {
      //print(table); //sheet Name
      // print(excel.tables[table]?.maxCols);
      // print(excel.tables[table]?.maxRows);
      for (var row in excel.tables[table]!.rows) {
        //checking and adding each value to map to remove redundancy
        if(temp[row[x]!.value] == null){
          temp[row[x]!.value] = row[y]!.value;
        }else{
          temp.update(row[x]!.value, (thisvalue) => thisvalue + row[y]!.value);
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
      // print("check2");
      // for(var data in Plottingdata){
      //   print(data.name);
      //   print(data.population);
      // }
    }

  }


  @override
  void initState(){
    getData(xaxisdata,yaxisdata);
    //print("hi");
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Scaffold Widget
        home: Scaffold(
            body: Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(14.0),
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
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(150, 0, 16, 0),
                      child: Row(
                        children: [
                          DropdownButton(value: selCoulmn[xaxisdata],
                            items: selCoulmn.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(), onChanged:(String? value) {
                            // This is called when the user selects an item.
                            setState(() {
                              xaxis = value!;
                              xaxisdata = mapCoulmn[xaxis] ?? 1;
                            });
                          },),
                          DropdownButton(
                            onChanged:(String? value) {
                              // This is called when the user selects an item.
                              setState(() {
                                yaxis = value!;
                                yaxisdata = mapCoulmn[yaxis] ?? 4;
                              });
                            },
                            items: selCoulmn.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                            value: selCoulmn[yaxisdata],
                            ),
                          ElevatedButton(onPressed: (){
                            setState(() {
                              getData(xaxisdata,yaxisdata);
                            });
                          }, child: Text("Refresh"))
                        ],
                      ),
                    )
                  ],
                )
            )
        )
    );
  }
}
