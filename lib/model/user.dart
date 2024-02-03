class User {
  String? email;
  String? token;
  String? firstName;
  String? lastName;

  User(this.email, this.token, this.firstName, this.lastName);

  factory User.fromJson(dynamic json) {
    return User(json['email'] as String?, json['token'] as String?,
        json['firstName'] as String?, json['lastName'] as String?);
  }
}
