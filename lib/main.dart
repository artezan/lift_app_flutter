import 'dart:async';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:lift_app/alert_dialog.dart';
import 'package:lift_app/cards.dart';
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
  // BehaviorSubject exSelect$ = BehaviorSubject.seeded(false);

  int currentDay;
  int currentPage = 0;
  bool flagPageGo = false;

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

  //  callback

  _callback(Map<String, Object> newDay) {
    setState(() {
      dayOfTab = newDay;
      currentDay = dayOfTab['id'];
    });
  }

  _callbackPage(int newCurrentPage) {
    setState(() {
      currentPage = newCurrentPage;
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
    storageRutines.setItem('user_rutines', routine);
  }

  _logoutLocalUser() {
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
    return RutineCards(
        blocks, days, currentDay, currentPage, _callbackPage, _callback);
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

// ANIMACIONES

/*    Widget normalData() {
  return StreamBuilder(
        stream: exSelect$,
        builder: (BuildContext context, AsyncSnapshot snap) {
          if (snap.hasData) {
            /*   return AnimatedCrossFade(
              duration: const Duration(milliseconds: 500),
              firstChild: RutineCards(blocks, days, currentDay, currentPage,
                  _callbackPage, _callback),
              secondChild:
                  _selectedCard(blocks[currentPage == 0 ? 0 : currentPage - 1]),
              crossFadeState: !snap.data
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
            ); */
            double top = snap.data ? 0 : 25;
            double bottom = snap.data ? 0 : 25;
            double right = snap.data ? 0 : 15;
            double left = snap.data ? 0 : 5;
            return AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.bounceIn,
              margin: EdgeInsets.only(
                  top: top, bottom: bottom, left: left, right: right),
              child: snap.data
                  ? _selectedCard(blocks[currentPage - 1])
                  : RutineCards(blocks, days, currentDay, currentPage,
                      _callbackPage, _callback),
            );
            /* if (!snap.data) {
              return RutineCards(blocks, days, currentDay, currentPage,
                  _callbackPage, _callback);
            } else {
              return AnimatedContainer(
                duration: Duration(milliseconds: 500),
                curve: Curves.bounceIn,
                margin: EdgeInsets.all(0),
                child: _selectedCard(blocks[currentPage - 1]),
              );

              // return _selectedCard(blocks[currentPage - 1]);
            } */
          } else {
            return new Container(width: 0.0, height: 0.0);
          }
        }); 
  }*/

/*  Widget _selectedCard(block) {
    return Stack(
      children: <Widget>[
        Cards(block),
        Positioned(
          left: 150,
          bottom: 30.0,
          child: Container(
            child: FloatingActionButton(
              child: Icon(Icons.arrow_downward),
              onPressed: () {
                exSelect$.add(false);
              },
            ),
          ),
        )
      ],
    );
  } */
