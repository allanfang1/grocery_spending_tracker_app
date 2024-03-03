class User {
  int? id;
  String? email;
  String? token;
  String? firstName;
  String? lastName;

  User.empty();

  User(this.id, this.email, this.token, this.firstName, this.lastName);

  void setUser(
      int id, String email, String token, String firstName, String lastName) {
    this.id = id;
    this.email = email;
    this.token = token;
    this.firstName = firstName;
    this.lastName = lastName;
  }

  void fromJson(dynamic json) {
    if (json['user_id'] != null) {
      id = json['user_id'] as int;
    }
    if (json['email'] != null) {
      email = json['email'] as String;
    }
    if (json['token'] != null) {
      token = json['token'] as String;
    }
    if (json['first_name'] != null) {
      firstName = json['first_name'] as String;
    }
    if (json['last_name'] != null) {
      lastName = json['last_name'] as String;
    }
  }

  void clear() {
    id = null;
    email = null;
    token = null;
    firstName = null;
    lastName = null;
  }
}
