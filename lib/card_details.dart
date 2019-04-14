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

class _CardDetailState extends State<CardDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 10),
        child: Stack(
          children: <Widget>[
            Hero(
              tag: "heroTag1${widget.currentIdx}",
              child: Cards(widget.block, true),
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
                child: Hero(
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
