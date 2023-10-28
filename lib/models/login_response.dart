class LoginResponse {
  String accessToken;

  LoginResponse({
    required this.accessToken
  });

  
  LoginResponse.fromMap(Map<String, dynamic> map)
      : accessToken = map['accessToken'];

  @override
  String toString() {
    return "Bearer: $accessToken";
  }

  Map<String, dynamic> toMap() {
    return {
      'accessToken': accessToken
    };
  }
}
