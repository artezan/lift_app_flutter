import 'package:flutter/material.dart';
import 'package:lift_app/alert_dialog.dart';
import 'package:lift_app/models/user.model.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'dart:async';

class Login extends StatefulWidget {
  final Function callbackRes;
  Login(this.callbackRes);
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;
  Timer _timer;
  final FlareControls _controlsF = FlareControls();
  @override
  void initState() {
    _timer = Timer.periodic(new Duration(seconds: 5), (timer) {
      setState(() {
        _controlsF.play('go');
      });
    });
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  _showAlertLoginUser() {
    ShowAlert().newUser(context).then((User value) {
      widget.callbackRes(value);
    });
  }

  _flare(str) {
    return FlareActor(
      'assets/$str.flr',
      alignment: Alignment.center,
      fit: BoxFit.contain,
      animation: 'go',
    );
  }

  _flare2() {
    return FlareActor(
      'assets/weight.flr',
      alignment: Alignment.center,
      fit: BoxFit.contain,
      animation: 'go',
      controller: _controlsF,
    );
  }

  @override
  Widget build(BuildContext context) {
    _controller.forward();
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
                height: 150,
                child: Padding(
                  padding: EdgeInsets.only(top: 0),
                  child: _flare('LiftAppTitle'),
                )),
            Container(
              height: 200,
              child: _flare2(),
            ),
            GestureDetector(
                onTap: _showAlertLoginUser,
                child: FadeTransition(
                  opacity: _animation,
                  child: Container(
                    width: 200,
                    decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Center(
                      child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 6.0),
                          child: Text(
                            'Iniciar Sesion',
                            style: TextStyle(fontSize: 22),
                          )),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
