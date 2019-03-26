class Routine {
  final DateTime endDate;
  final int number;
  final DateTime startDate;
  final String uid;
  final List<Block> blocks;

  Routine({this.number, this.startDate, this.uid, this.blocks, this.endDate});

  factory Routine.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['blocks'] as List;
    print(list.runtimeType);
    List<Block> blocksList = list.map((i) => Block.fromJson(i)).toList();

    return Routine(
        endDate: parsedJson['endDate'],
        startDate: parsedJson['startDate'],
        uid: parsedJson['uid'],
        number: parsedJson['number'],
        blocks: blocksList);
  }
}

class Block {
  final int day;
  final exercises;

  Block({this.day, this.exercises});
  factory Block.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['exercises'] as List;
    print(list.runtimeType);
    List<Exercise> exercisesList =
        list.map((i) => Exercise.fromJson(i)).toList();

    return Block(day: parsedJson['day'], exercises: exercisesList);
  }
}

class Exercise {
  final String description;
  final String name;
  final int reps;
  final int number;
  final int series;
  final String typeMuscle;

  Exercise(
      {this.description,
      this.name,
      this.reps,
      this.number,
      this.series,
      this.typeMuscle});

  factory Exercise.fromJson(Map<String, dynamic> parsedJson) {
    return Exercise(
      description: parsedJson['description'],
      name: parsedJson['name'],
      reps: parsedJson['reps'],
      number: parsedJson['number'],
      series: parsedJson['series'],
      typeMuscle: parsedJson['typeMuscle'],
    );
  }
}
