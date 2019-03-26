import 'dart:async';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:lift_app/alert_dialog.dart';
import 'package:lift_app/days_tabs.dart';
import 'package:lift_app/models/user.model.dart';
import 'package:lift_app/rutine_cards.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:localstorage/localstorage.dart';
import 'package:rxdart/rxdart.dart';

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
  dynamic blocks;
  final LocalStorage storage = new LocalStorage('user_login');
  final LocalStorage storageRutines = new LocalStorage('user_rutines');
  BehaviorSubject _user$ = BehaviorSubject.seeded(false);
  Map<String, dynamic> routine;
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
  }

  get getCurrentDate {
    final now = new DateTime.now();
    return now.weekday;
  }

  _callback(Map<String, Object> newDay) {
    setState(() {
      dayOfTab = newDay;
      print(dayOfTab);
      currentDay = dayOfTab['id'];
    });
  }

// FIREBASE
// todo localstore
  get userIdFirebase => _user$.value['id'];

  _getRoutines(int number) {
    Firestore.instance
        .collection('routines')
        .where("uid", isEqualTo: userIdFirebase)
        .where("number", isEqualTo: number)
        .limit(1)
        .snapshots()
        .listen((data) => data.documents.forEach((doc) => doc.exists
            ? _trasformRoutines(doc.data)
            : _user$.add({'id': userIdFirebase, 'routine': false})));
  }

  _addUserFirebase(user) {
    Map<String, dynamic> usr = User.doMap(user);
    Firestore.instance
        .collection('user')
        .add(usr)
        .then((onValue) => _addToLocalUser(onValue.documentID));
  }

  _getUserFirebase(User user) {
    Map<String, dynamic> usr = User.doMap(user);
    Firestore.instance
        .collection('user')
        .where('name', isEqualTo: usr['name'])
        .where('lastName', isEqualTo: usr['lastName'])
        .limit(1)
        .snapshots()
        .listen((data) => data.documents.forEach((doc) =>
            doc.exists ? _trasformId(doc.documentID) : _user$.add(false)));
  }

  // Local
  _addToLocalUser(String id) {
    print(id);
    storage.setItem('user_login', id);
  }

  _addToLocalRoutine(routine) {
    print('guardo rut');
    print(routine);
    storageRutines.setItem('user_rutines', routine);
  }

  _logoutLocalUser() {
    print('salida');
    _user$.add(false);
    storage.deleteItem('user_login');
    storageRutines.deleteItem('user_rutines');
  }

  _logoutLocalRoutines() {
    _user$.add({'id': userIdFirebase, 'routine': false});
    storageRutines.deleteItem('user_rutines');
  }

  // Rutinas

  _trasformRoutines(Map<String, dynamic> data) {
    _addToLocalRoutine(data);
    _user$.add({'id': userIdFirebase, 'routine': data});
    routine = data;
  }

  _trasformId(id) {
    _addToLocalUser(id);
    _user$.add({'id': id});
  }

  _getblocks(dayNumber) {
    // filter data Firebase
    print(dayNumber);
    var b = routine['blocks'].where((b) => b['day'] == dayNumber).toList();
    print(b);
    return b;
  }
  // Alerts

  _showAlertRutine() {
    ShowAlert().loadRutine(context).then((int value) {
      _getRoutines(value);
    });
  }

  _showAlertNewUser() {
    ShowAlert().newUser(context).then((User value) {
      _addUserFirebase(value);
    });
  }

  _showAlertLoginUser() {
    ShowAlert().newUser(context).then((User value) {
      _getUserFirebase(value);
    });
  }

// Casos
  Widget normalData() {
    return Column(
      children: <Widget>[
        DaysTabs(days, currentDay, _callback),
        RutineCards(blocks)
      ],
    );
  }

  Widget reqForUserLogin() {
    return Center(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // nuevo
            RaisedButton(
              onPressed: _showAlertNewUser,
              child: Text('Nuevo Usuario'),
            ),
            RaisedButton(
              onPressed: _showAlertLoginUser,
              child: Text('Iniciar Sesion'),
            ),
          ],
        ),
      ),
    );
  }

  Widget reqForRutine() {
    return Center(
      child: Container(
        child: RaisedButton(
          onPressed: _showAlertRutine,
          child: Text('Cargar Rutina'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
            style: Theme.of(context).textTheme.title,
          ),
          backgroundColor: Colors.deepPurple,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: _logoutLocalUser,
            )
          ],
        ),
        body: FutureBuilder(
          future: storage.ready,
          builder: (BuildContext context, snapshot) {
            // check localstorage
            if (snapshot.data == true) {
              print(storageRutines.getItem('user_rutines'));
              print(storage.getItem('user_login'));
              // check obs
              return StreamBuilder(
                stream: _user$.stream,
                builder: (BuildContext context, AsyncSnapshot snap) {
                  if (snap.hasData == true) {
                    if (snap.data == false) {
                      if (storage.getItem('user_login') == null) {
                        return reqForUserLogin();
                      } else if (storageRutines.getItem('user_rutines') ==
                          null) {
                        print(storageRutines.getItem('user_rutines'));
                        print(storage.getItem('user_login'));
                        return reqForRutine();
                      } else {
                        _user$.add({
                          'id': storage.getItem('user_login'),
                          'routine': storageRutines.getItem('user_rutines')
                        });
                        return new Container(width: 0.0, height: 0.0);
                      }
                    } else {
                      if (storageRutines.getItem('user_rutines') == null) {
                        return reqForRutine();
                      } else {
                        routine = snap.data['routine'];
                        _addToLocalUser(snap.data['id']);
                        blocks = _getblocks(currentDay);
                        return normalData();
                      }
                    }
                  } else {
                    return new Container(width: 0.0, height: 0.0);
                  }
                },
              );
            } else {
              return Center(
                child: Container(
                  child: Text('Cargando...'),
                ),
              );
            }
          },
        ));
  }
}
