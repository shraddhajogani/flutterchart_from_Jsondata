import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:convert';

class HomePage extends StatefulWidget {
  final Widget child;

  HomePage({Key key, this.child}) : super(key: key);

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<charts.Series<Sales, String>> seriesBarData;

  _generateData() async {
    final load =
    await DefaultAssetBundle.of(context).loadString("asset/data.json");
    var decoded = json.decode(load);
    List<Sales> sales = [];
    for (var item in decoded) {
      sales.add(Sales.fromJson(item));
    }

    seriesBarData.add(charts.Series(
      data: sales,
      domainFn: (Sales sales, _) => sales.saleyear,
      measureFn: (Sales sales, _) => int.parse(sales.saleval),
      id: 'Performance',
    ));
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    seriesBarData = List<charts.Series<Sales, String>>();
    _generateData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text('flutter charts'),
      ),
      body: Column(
        children: [
          Text(
            'Sales By Year',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10.0,
          ),
          seriesBarData.length > 0
              ? Expanded(
            child: charts.BarChart(
              seriesBarData,
              animate: true,
              animationDuration: Duration(seconds: 5),
            ),
          )
              : Container(),
        ],
      ),
    );
  }
}

class Sales {
  String saleyear;
  String saleval;

  Sales(this.saleyear, this.saleval);

  Sales.fromJson(Map<String, dynamic> json) {
    saleyear = json['saleyear'];
    saleval = json['saleval'];
  }
}