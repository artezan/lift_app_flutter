import 'package:flutter/material.dart';
import 'package:lift_app/models/user.model.dart';

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

  Future<User> newUser(BuildContext context) {
    User newUser = new User();
    final _formKey = GlobalKey<FormState>();
    return showDialog<User>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Datos Usuario'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Nombre',
                            icon: const Icon(Icons.person),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Anota Nombre';
                            }
                          },
                          onSaved: (val) => newUser.name = val,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                              labelText: 'Apellido',
                              icon: const Icon(Icons.person_outline)),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Anota Apellido';
                            }
                          },
                          onSaved: (val) => newUser.lastName = val,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Aceptar'),
                onPressed: () {
                  // Validate will return true if the form is valid, or false if
                  // the form is invalid.
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    Navigator.of(context).pop(newUser);
                  }
                },
              ),
            ],
          );
        });
  }

  Future<int> loadRutine(BuildContext context) {
    int numOfRutine;
    final _formKey = GlobalKey<FormState>();
    return showDialog<int>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Numero de Rutina'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Numero',
                            icon: const Icon(Icons.whatshot),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Anota Nombre';
                            }
                          },
                          onSaved: (val) => numOfRutine = int.parse(val),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Aceptar'),
                onPressed: () {
                  // Validate will return true if the form is valid, or false if
                  // the form is invalid.
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    Navigator.of(context).pop(numOfRutine);
                  }
                },
              ),
            ],
          );
        });
  }
}
