import 'package:flutter/material.dart';
import 'package:lift_app/days_tabs.dart';
import 'package:lift_app/rutine_cards.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LIFTAPP',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
        accentColor: Color(0xFFc678dd),
        // Define the default Font Family
        fontFamily: 'Dosis',
        textTheme: TextTheme(
          headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          title: TextStyle(fontFamily: 'Dosis'),
          body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      ),
      home: MyHomePage(title: 'LIFT APP'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map<String, Object> dayOfTab;
  List<Map<String, Object>> blocks;
  int currentDay;
  // List days
  List<Map<String, Object>> days = [
    {'name': 'Lunes', 'id': 0},
    {'name': 'Martes', 'id': 1},
    {'name': 'Miercoles', 'id': 2},
    {'name': 'Jueves', 'id': 3},
    {'name': 'Viernes', 'id': 4},
    // {'name': 'Sabado', 'id': 5},
    // {'name': 'Domingo', 'id': 6},
  ];
  // otra forma
  List<Tab> tabs = [
    Tab(text: 'lunes'),
    Tab(text: 'Martes'),
    // ...
  ];

  @override
  void initState() {
    super.initState();
    if (getCurrentDate > days.length) {
      currentDay = 0;
    } else {
      currentDay = getCurrentDate - 1;
    }
    blocks = _getblocks(currentDay);
  }

  get getCurrentDate {
    final now = new DateTime.now();
    print(now.weekday);
    return now.weekday;
  }

  _callback(Map<String, Object> newDay) {
    setState(() {
      dayOfTab = newDay;
      print(dayOfTab);
      blocks = _getblocks(dayOfTab['id']);
    });
  }

  _getblocks(dayNumber) {
    // filter data Firebase
    List<Map<String, Object>> blocks = [
      {
        'day': dayNumber,
        'exercises': [
          {
            'description': 'es hasta el pecho',
            'name': 'Jalon al pecho',
            'reps': 12
          },
          {
            'description': 'es hasta el pecho2',
            'name': 'Jalon al pecho2',
            'reps': 10
          }
        ]
      },
      {
        'day': dayNumber,
        'exercises': [
          {
            'description': 'es hasta el pecho',
            'name': 'Jalon al pecho',
            'reps': 12
          },
          {
            'description': 'es hasta el pecho2',
            'name': 'Jalon al pecho2',
            'reps': 10
          }
        ]
      }
    ];
    return blocks;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
              widget.title,
              style: Theme.of(context).textTheme.title,
            ),
            backgroundColor: Colors.deepPurple),
        body: Column(
          children: <Widget>[
            DaysTabs(days, currentDay, _callback),
            RutineCards(blocks)
          ],
        ));
  }
}
