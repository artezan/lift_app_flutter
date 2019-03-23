import 'dart:async';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:lift_app/alert_dialog.dart';
import 'package:lift_app/days_tabs.dart';
import 'package:lift_app/rutine_cards.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:localstorage/localstorage.dart';

Future<void> main() async {
  final FirebaseApp app = await FirebaseApp.configure(
    name: 'liftApp-flutter',
    options: const FirebaseOptions(
      googleAppID: '1:597114331964:android:4cefccdaffd3490f',
      gcmSenderID: '597114331964',
      apiKey: 'AIzaSyDakbtN1KFrTFBAac-VS5DGwymdg7H70qI',
      projectID: 'liftapp-flutter',
    ),
  );
  final Firestore firestore = Firestore(app: app);
  await firestore.settings(timestampsInSnapshotsEnabled: true);
  runApp(MyApp());
}

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
    // Local Storage
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

// todo localstore
  get userIdFirebase => 'ROasIinc7hArHKskLM6T';

  _getRoutines() {
    Firestore.instance
        .collection('routines')
        .where("uid", isEqualTo: userIdFirebase)
        .snapshots()
        .listen(
            (data) => data.documents.forEach((doc) => print(doc['blocks'])));
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

  _showAlert() {
    ShowAlert().confirmDialog(context).then((bool value) {
      _getRoutines();
      print(value);
    });
  }

  _showAlertUserEmail() {
    ShowAlert().confirmDialog(context).then((bool value) {
      _getRoutines();
      print(value);
    });
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
            RaisedButton(
              child: Text('Alert'),
              onPressed: _showAlert,
            ),
            DaysTabs(days, currentDay, _callback),
            RutineCards(blocks)
          ],
        ));
  }
}
