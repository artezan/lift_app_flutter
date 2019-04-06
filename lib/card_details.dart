import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lift_app/cards.dart';

class CardDetail extends StatefulWidget {
  final block;
  final currentIdx;
  CardDetail(this.block, this.currentIdx);
  @override
  _CardDetailState createState() => _CardDetailState();
}

class _CardDetailState extends State<CardDetail>
    with SingleTickerProviderStateMixin {
  /* double left = 0;
  Timer _timer; */
  // prueba
  AnimationController _controller;
  Animation _animation;
  @override
  void initState() {
    /*  _timer = Timer(Duration(milliseconds: 300), () {
      setState(() {
        print('mueve');
        left = 20;
      });
    }); */
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 700));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);

    super.initState();
  }

  @override
  void dispose() {
    /*  _timer.cancel();
    _timer = null;
    super.dispose(); */
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.forward();
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 10),
        child: Stack(
          children: <Widget>[
            Hero(
              tag: "heroTag1${widget.currentIdx}",
              child: Cards(widget.block),
            ),
            /* AnimatedPositioned(
              duration: Duration(milliseconds: 500),
              curve: Curves.elasticIn,
              left: left,
              bottom: 30,
              child: Container(
                child: FloatingActionButton(
                    child: Icon(Icons.arrow_downward),
                    // onPressed: () => Navigator.pop(context),
                    onPressed: () => Navigator.of(context).pop()),
              ),
            ) */
            Positioned(
                right: 30,
                top: 30,
                child:
                    /* FadeTransition(
                opacity: _animation,
                child: FloatingActionButton(
                  mini: true,
                  child: Icon(Icons.arrow_downward),
                  onPressed: () => Navigator.pop(context),
                ),
              ), */
                    Hero(
                  tag: "floatBtn",
                  child: FloatingActionButton(
                    mini: true,
                    child: Icon(Icons.arrow_downward),
                    onPressed: () => Navigator.pop(context),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
