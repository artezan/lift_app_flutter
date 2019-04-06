import 'package:flutter/material.dart';

class Cards extends StatelessWidget {
  final block;
  Cards(this.block);

  _buildExercises() {
    return block['exercises']
        .map<Widget>((exercise) => Column(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.album),
                  title: Text(exercise['name']),
                  subtitle: Text(exercise['description']),
                ),
                Chip(
                  label: Text('Reps ${exercise['reps']}'),
                )
              ],
            ))
        .toList();
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
                image:
                    AssetImage('assets/${_typeOfMuscle(block['typeMuscle'])}'),
                colorFilter: ColorFilter.mode(
                    Color.fromARGB(30, 0, 0, 0), BlendMode.srcIn),
                fit: BoxFit.scaleDown)),
        child: Column(
          children: _buildExercises(),
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0,
    );
  }
}
