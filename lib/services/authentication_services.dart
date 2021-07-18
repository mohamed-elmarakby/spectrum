import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:graduation_project/constant/constant.dart';
import 'package:graduation_project/main.dart';
import 'package:graduation_project/models/login_model.dart';
import 'package:graduation_project/models/register_model.dart';

class AuthenticationServices {
  Future<RegisterResponse> registerApi({
    String name,
    String email,
    String password,
    String age,
    String address,
  }) async {
    Dio dio = Dio();
    String url = Constants().apiUrl + 'register';
    log(url);
    RegisterResponse tempRegisterResponse = RegisterResponse();
    Map registerData = {
      "name": name,
      "email": email,
      "password": password,
      "age": age,
      "address": address,
    };
    log(registerData.toString());
    await dio
        .post(
      url,
      data: registerData,
    )
        .then(
      (value) {
        print(value.statusCode);
        print(value.data);
        tempRegisterResponse = RegisterResponse.fromJson(value.data);
      },
    );
    return tempRegisterResponse;
  }

  Future<LoginResponse> loginApi({
    String email,
    String password,
  }) async {
    Dio dio = Dio();
    String url = Constants().apiUrl + 'login';
    log(url);
    LoginResponse tempLoginResponse = LoginResponse();
    Map loginData = {
      "email": email,
      "password": password,
    };
    log(loginData.toString());
    await dio
        .post(
      url,
      data: loginData,
    )
        .then(
      (value) {
        print(value.statusCode);
        print(value.data);
        tempLoginResponse = LoginResponse.fromJson(value.data);
      },
    );
    return tempLoginResponse;
  }

  Future<bool> sendToken({
    String userId,
  }) async {
    Dio dio = Dio();
    String url = Constants().apiUrl + 'mobileToken';
    log(url);
    bool success = false;
    Map tokenData = {
      "userId": userId,
      "mobile_token": mobileToken,
    };
    log(tokenData.toString());
    await dio
        .post(
      url,
      data: tokenData,
    )
        .then(
      (value) {
        print(value.statusCode);
        print('sent token successfully');
        print(value.data);
        success = value.data['success'];
      },
    );
    return success;
  }

  Future<bool> checkEmail({
    String email,
  }) async {
    Dio dio = Dio();
    String url = Constants().apiUrl + 'forget-pass';
    log(url);
    bool found = false;
    await dio
        .get(
      url,
      options: Options(headers: {'email': email}),
    )
        .then(
      (value) {
        print(value.statusCode);
        print(value.data);
        found = value.data['success'];
      },
    );
    return found;
  }

  Future<bool> checkCode({
    String email,
    String code,
  }) async {
    Dio dio = Dio();
    String url = Constants().apiUrl + 'check-code';
    log(url);
    bool checked = false;
    await dio
        .get(
      url,
      options: Options(headers: {'email': email, 'code': code}),
    )
        .then(
      (value) {
        print(value.statusCode);
        print(value.data);
        checked = value.data['correct'];
      },
    );
    return checked;
  }

  Future<bool> setNewPassword({
    String email,
    String password,
  }) async {
    Dio dio = Dio();
    String url = Constants().apiUrl + 'reset-pass';
    log(url);
    Map loginData = {
      "email": email,
      "pass": password,
    };
    bool changed = false;
    log(loginData.toString());
    await dio
        .post(
      url,
      data: loginData,
    )
        .then(
      (value) {
        print(value.statusCode);
        print(value.data);
        changed = value.data['changed'];
      },
    );
    return changed;
  }
}
