import 'package:flutter/material.dart';

class RutineCards extends StatelessWidget {
// fake list

  final _rutinesList;

  RutineCards(this._rutinesList);

  _getArray(List<Map<String, Object>> obj) {
    List<Map<String, Object>> listOfValue = [];
    for (Map<String, Object> map in obj) {
      // loop through the maps
      listOfValue.add(map); // append the values in listOfValue
    }
    return listOfValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Expanded(
        child: ListView(
          children: <Widget>[
            Column(
              children: _rutinesList
                  .map<Widget>((block) => Card(
                        child: Column(
                          children: block['exercises']
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
                              .toList(),
                        ),
                      ))
                  .toList(),
            )
          ],
        ),
      ),
    );
  }
}
