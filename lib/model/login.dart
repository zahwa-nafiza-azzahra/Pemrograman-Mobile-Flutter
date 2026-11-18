class Login {
  int? code;
  bool? status;
  String? token;
  int? userID;
  String? userEmail;

  Login({this.code, this.status, this.token, this.userID, this.userEmail});

  factory Login.fromJson(Map<String, dynamic> obj) {
    final code = obj['code'] is int
        ? obj['code'] as int?
        : int.tryParse(obj['code'].toString());
    if (code == 200 && obj['data'] is Map<String, dynamic>) {
      final data = obj['data'] as Map<String, dynamic>;
      final user = data['user'] as Map<String, dynamic>?;
      return Login(
        code: code,
        status: obj['status'] as bool?,
        token: data['token']?.toString(),
        userID: user != null ? int.tryParse(user['id'].toString()) : null,
        userEmail: user?['email']?.toString(),
      );
    }
    return Login(
      code: code,
      status: obj['status'] as bool?,
    );
  }
}
