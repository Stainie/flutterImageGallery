class User {
  String _id;
  String _email;
  String _password;

  User(this._email, this._password);

  String get email => _email;
  String get password => _password;
  String get id => _id;

  void setId(String id) {
    this._id = id;
  }

  Map toJson() {
    return {
      "email": email,
      "username": "username",
      "password": password,
      "confirm_password": password,
    };
  }
}
