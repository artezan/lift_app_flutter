import 'package:flutter/material.dart';

class Cards extends StatefulWidget {
  final block;
  final bool isDecorator;
  Cards(this.block, this.isDecorator);
  @override
  _CardsState createState() => _CardsState();
}

class _CardsState extends State<Cards> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;
  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animation = Tween(begin: 0.5, end: 1.0).animate(_controller);

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

  _buildExercises(BuildContext context) {
    return widget.block['exercises']
        .map<Widget>((exercise) => Column(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.fitness_center),
                  title: Text(
                    exercise['name'],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  subtitle: Text(exercise['description']),
                ),
                Container(
                  child: widget.isDecorator
                      ? decoratedBoxNumber('Series ${widget.block['series']} ',
                          'Reps ${exercise['reps']}', context)
                      : columnNumber(context, exercise),
                ),
                Divider(
                  height: 25,
                )
              ],
            ))
        .toList();
  }

  Column columnNumber(BuildContext context, exercise) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Series ${widget.block['series']} ',
          style: TextStyle(fontSize: 20, color: Theme.of(context).accentColor),
        ),
        Icon(
          Icons.cancel,
          color: Theme.of(context).accentColor,
        ),
        Text(
          'Reps ${exercise['reps']}',
          style: TextStyle(fontSize: 20, color: Theme.of(context).accentColor),
        ),
      ],
    );
  }

  decoratedBoxNumber(String series, String reps, context) {
    _controller.forward();
    return FadeTransition(
        opacity: _animation,
        child: DecoratedBox(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey, width: 2)),
            child: Container(
              width: 300,
              height: 100,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    series,
                    style: TextStyle(
                        fontSize: 20, color: Theme.of(context).accentColor),
                  ),
                  Icon(
                    Icons.cancel,
                    color: Theme.of(context).accentColor,
                  ),
                  Text(
                    reps,
                    style: TextStyle(
                        fontSize: 20, color: Theme.of(context).accentColor),
                  ),
                ],
              ),
            )));
  }

  _typeOfMuscle(String muscle) {
    if (muscle == 'cuadriceps') {
      return 'workout.png';
    } else if (muscle == 'femoral') {
      return 'weight.png';
    } else if (muscle == 'biceps') {
      return 'barbell.png';
    } else if (muscle == 'triceps') {
      return 'triceps.png';
    } else if (muscle == 'hombro') {
      return 'fitness.png';
    } else if (muscle == 'pecho') {
      return 'chest.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                    'assets/${_typeOfMuscle(widget.block['typeMuscle'])}'),
                colorFilter: ColorFilter.mode(
                    Color.fromARGB(30, 0, 0, 0), BlendMode.srcIn),
                fit: BoxFit.scaleDown)),
        child: ListView(children: _buildExercises(context)),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0,
    );
  }
}
