class User {
  String email;
  String password;

  User({
    required this.email,
    required this.password
  });

  
  User.fromMap(Map<String, dynamic> map)
      : email = map['email'],
        password = map['password'];

  @override
  String toString() {
    return "Usuário: $email";
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password
    };
  }
}
