import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:graduation_project/constant/constant.dart';
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
}