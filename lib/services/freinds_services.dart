import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:graduation_project/constant/constant.dart';
import 'package:graduation_project/models/allUsers_model.dart';
import 'package:graduation_project/models/friendRequests_model.dart';
import 'package:graduation_project/models/friends_model.dart';
import 'package:graduation_project/models/userInfo_model.dart';

class FriendsServices {
  Future<AllUsersResponse> allUsersApi() async {
    Dio dio = Dio();
    String url = Constants().apiUrl + 'users';
    log(url);
    AllUsersResponse tempAllUsersResponse = AllUsersResponse();
    await dio
        .get(
      url,
    )
        .then(
      (value) {
        print(value.statusCode);
        print(value.data);
        tempAllUsersResponse = AllUsersResponse.fromJson(value.data);
      },
    );
    return tempAllUsersResponse;
  }

  Future<UserInfoResponse> userInfoApi({
    String userId,
  }) async {
    Dio dio = Dio();
    String url = Constants().apiUrl + 'info';
    log(url);
    UserInfoResponse tempUserInfoResponse = UserInfoResponse();
    await dio.get(url, options: Options(headers: {'id': userId})).then(
      (value) {
        print(value.statusCode);
        print(value.data);
        tempUserInfoResponse = UserInfoResponse.fromJson(value.data);
      },
    ).onError((error, stackTrace) {
      log(error);
    });
    return tempUserInfoResponse;
  }

  Future<FriendRequestsResponse> getFriendRequests({
    String userId,
  }) async {
    Dio dio = Dio();
    String url = Constants().apiUrl + 'friends/requests';
    log(url);
    FriendRequestsResponse tempFriendRequestsResponse =
        FriendRequestsResponse();
    await dio.get(url, options: Options(headers: {'userId': userId})).then(
      (value) {
        print(value.statusCode);
        print(value.data);
        tempFriendRequestsResponse =
            FriendRequestsResponse.fromJson(value.data);
      },
    );
    return tempFriendRequestsResponse;
  }

  Future<FriendRequestsResponse> setFriendRequests({
    String userId,
  }) async {
    Dio dio = Dio();
    String url = Constants().apiUrl + 'friends/sentRequests';
    log(url);
    FriendRequestsResponse tempFriendRequestsResponse =
        FriendRequestsResponse();
    await dio.get(url, options: Options(headers: {'userId': userId})).then(
      (value) {
        print(value.statusCode);
        print(value.data);
        tempFriendRequestsResponse =
            FriendRequestsResponse.fromJson(value.data);
      },
    );
    return tempFriendRequestsResponse;
  }

  Future<FriendsResponse> allFriendsApi({
    String userId,
  }) async {
    Dio dio = Dio();
    String url = Constants().apiUrl + 'friends/friends';
    log(url);
    FriendsResponse tempFriendsResponse = FriendsResponse();
    await dio.get(url, options: Options(headers: {'userId': userId})).then(
      (value) {
        print(value.statusCode);
        print(value.data);
        tempFriendsResponse = FriendsResponse.fromJson(value.data);
      },
    );
    return tempFriendsResponse;
  }
}
