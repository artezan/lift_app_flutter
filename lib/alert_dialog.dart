import 'package:flutter/material.dart';

/* class ShowAlert extends StatefulWidget {
  @override
  _ShowAlertState createState() => _ShowAlertState();
} */

class ShowAlert {
  Future<bool> confirmDialog(BuildContext context) {
    return showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Cargar Rutinas'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Se cargara la nueva rutina'),
                  Text('✌'),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Aceptar'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        });
  }
}
