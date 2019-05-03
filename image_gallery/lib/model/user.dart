class User {
  String _email;
  String _password;

  User(this._email, this._password);

  String get email => _email;
  String get password => _password;

  Map toJson() {
    return {
      "email": email,
      "username": "username",
      "password": password,
    };
  }
}
