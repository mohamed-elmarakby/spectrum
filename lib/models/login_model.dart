import 'dart:convert';

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  LoginResponse({
    this.success,
    this.token,
    this.msg,
  });

  bool success;
  String token;
  String msg;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        success: json["success"],
        token: json["token"],
        msg: json["msg"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "token": token,
        "msg": msg,
      };
}
