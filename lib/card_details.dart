import 'package:flutter/material.dart';
import 'package:lift_app/cards.dart';

class CardDetail extends StatelessWidget {
  final block;
  final currentIdx;
  CardDetail(this.block, this.currentIdx);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 10),
        child: Stack(
          children: <Widget>[
            Hero(
              tag: "heroTag1$currentIdx",
              child: Cards(block),
            ),
            Positioned(
              left: 150,
              bottom: 30.0,
              child: Container(
                child: FloatingActionButton(
                    child: Icon(Icons.arrow_downward),
                    // onPressed: () => Navigator.pop(context),
                    onPressed: () => Navigator.of(context).pop()),
              ),
            )
          ],
        ),
      ),
    );
  }
}
