class User {
  String name;
  String lastName;

  User({this.name, this.lastName});

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return User(
      name: parsedJson['name'],
      lastName: parsedJson['lastName'],
    );
  }
  static Map<String, dynamic> doMap(User user) {
    return {'name': user.name, 'lastName': user.lastName};
  }
}
