class User {
  int? id;
  String? email;
  String? token;
  String? firstName;
  String? lastName;

  User.empty();

  User(this.id, this.email, this.token, this.firstName, this.lastName);

  void setUser(String id, String email, String token, String firstName,
      String lastName) {
    id = id;
    email = email;
    token = token;
    firstName = firstName;
    lastName = lastName;
  }

  void fromJson(dynamic json) {
    id = json['user_id'] as int?;
    email = json['email'] as String?;
    token = json['token'] as String?;
    firstName = json['first_name'] as String?;
    lastName = json['last_name'] as String?;
  }

  void clear() {
    id = null;
    email = null;
    token = null;
    firstName = null;
    lastName = null;
  }
}
