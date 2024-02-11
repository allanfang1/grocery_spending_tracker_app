class User {
  String id;
  String? email;
  String token;
  String? firstName;
  String? lastName;

  User(this.id, this.email, this.token, this.firstName, this.lastName);

  factory User.fromJson(dynamic json) {
    return User(
        json['id'] as String,
        json['email'] as String?,
        json['token'] as String,
        json['firstName'] as String?,
        json['lastName'] as String?);
  }
}
