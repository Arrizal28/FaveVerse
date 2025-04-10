
class LoginResponse {
  final bool error;
  final String message;
  final LoginResult loginResult;

  LoginResponse({
    required this.error,
    required this.message,
    required this.loginResult,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      error: json['error'] as bool,
      message: json['message'] as String,
      loginResult: LoginResult.fromJson(json['loginResult']),
    );
  }

  Map<String, dynamic> toJson() => {
    'error': error,
    'message': message,
    'loginResult': loginResult.toJson(),
  };
}

class LoginResult {
  final String userId;
  final String name;
  final String token;

  LoginResult({
    required this.userId,
    required this.name,
    required this.token,
  });

  factory LoginResult.fromJson(Map<String, dynamic> json) {
    return LoginResult(
      userId: json['userId'] as String,
      name: json['name'] as String,
      token: json['token'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'name': name,
    'token': token,
  };
}
