import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:graduation_project/constant/constant.dart';
import 'package:graduation_project/main.dart';
import 'package:graduation_project/models/allMyFriends_model.dart';
import 'package:graduation_project/models/socket_models.dart/my_post_model_socket.dart';
import 'package:graduation_project/models/socket_models.dart/user_info_socket_model.dart';
import '../models/allOfCurrentUser_model.dart';

class HomeServices {
  Future<AllOfCurrentUserModel> getAllOfCurrentUser({String userId}) async {
    Dio dio = Dio();
    String url = Constants().apiUrl + 'allOfCurrent';
    log(url);
    AllOfCurrentUserModel tempAllOfCuurentUserModel = AllOfCurrentUserModel();
    await dio
        .get(
      url,
      options: Options(
        headers: {
          'id': userId,
        },
      ),
    )
        .then(
      (value) {
        print(value.statusCode);
        print(value.data);
        tempAllOfCuurentUserModel = AllOfCurrentUserModel.fromJson(value.data);
      },
    );
    return tempAllOfCuurentUserModel;
  }

  Future<List<UserInfoSocketModel>> getAllUsers() async {
    Dio dio = Dio();
    String url = Constants().apiUrl + 'users';
    log(url);
    List<UserInfoSocketModel> tempAllUsers = [];
    await dio
        .get(
      url,
    )
        .then(
      (value) {
        print(value.statusCode);
        print(value.data);
        for (var user in value.data) {
          tempAllUsers.add(UserInfoSocketModel(
            name: user['name'],
            sId: user['_id'],
            image: user['image'],
          ));
        }
      },
    );
    return tempAllUsers;
  }

  Future<MyFriendsModel> getAllMyFriends({String userId}) async {
    Dio dio = Dio();
    String url = Constants().apiUrl + 'friends';
    log(url);
    MyFriendsModel tempAllMyFriends = MyFriendsModel();
    await dio
        .get(
      url,
      options: Options(headers: {
        'userId': userId,
      }),
    )
        .then(
      (value) {
        print(value.statusCode);
        print(value.data);
        tempAllMyFriends = MyFriendsModel.fromJson(value.data);
        log(tempAllMyFriends.toString());
      },
    );
    return tempAllMyFriends;
  }

  Future<List<Posts>> getMyPost({String userId}) async {
    Dio dio = Dio();
    String url = Constants().apiUrl + 'currentUserPosts';
    log(url);
    List tempPosts = [];
    List<Posts> returnedPostsList = [];
    await dio
        .get(
      url,
      options: Options(
        headers: {
          'id': userId,
        },
      ),
    )
        .then(
      (value) {
        print(value.statusCode);
        print(value.data);
        tempPosts = value.data;
        for (var post in tempPosts) {
          MyPostModel myLikes = MyPostModel.fromJson(post);
          List<Likes> likes = [];
          List<Comments> comments = [];
          for (var like in myLikes.likes) {
            likes.add(Likes(
              date: like.date,
              id: AuthorId(
                sId: like.id,
              ),
              sId: like.sId,
            ));
          }
          print('done adding likes');

          for (var comment in myLikes.comments) {
            comments.add(Comments(
                isEdited: comment.isEdited,
                sId: comment.sId,
                text: comment.text,
                commenterId: AuthorId(
                  image: comment.commenterId.image,
                  name: comment.commenterId.name,
                  sId: comment.commenterId.sId,
                )));
          }
          print('done adding Comments');
          returnedPostsList.add(
            Posts(
              comments: comments,
              date: myLikes.date,
              image: myLikes.image,
              isEdited: myLikes.isEdited,
              likes: likes,
              sId: myLikes.sId,
              text: myLikes.text,
              authorId: AuthorId(
                image: user.image,
                sId: user.id,
                name: user.name,
              ),
            ),
          );
        }
      },
    );
    return returnedPostsList;
  }
}
