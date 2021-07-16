import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:graduation_project/main.dart';
import 'package:graduation_project/models/token_decryption_model.dart';
import 'package:graduation_project/provider/application_provider.dart';
import 'package:graduation_project/services/freinds_services.dart';
import 'package:graduation_project/services/home_services.dart';
import 'package:graduation_project/sharedPreference.dart';
import 'package:graduation_project/widgets/alrert_manger.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import './profile_screen.dart';

class EditProfileScreen extends StatefulWidget {
  EditProfileScreen({Key key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController _emailController;
  TextEditingController _oldPasswordController;
  TextEditingController _newPasswordController;
  TextEditingController _nameController;
  TextEditingController _addressController;
  TextEditingController _ageController;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final pickerProfile = ImagePicker();
  String base64ImageProfile;
  File profileFile;
  Uint8List bytesProfile;
  Future getProfileImage() async {
    ImageSource source;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Theme(
          data: ThemeData.light(),
          child: AlertDialog(
            elevation: 3,
            title: Text("Add Image"),
            content: Text("Where do you want to get the image?"),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "Camera",
                ),
                onPressed: () {
                  setState(() {
                    source = ImageSource.camera;
                  });
                  Navigator.pop(context);
                },
              ),
              Builder(
                builder: (context) {
                  return FlatButton(
                    child: Text(
                      "Gallery",
                    ),
                    onPressed: () {
                      setState(() {
                        source = ImageSource.gallery;
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              )
              // usually buttons at the bottom of the dialog
              ,
            ],
          ),
        );
      },
    ).then((value) async {
      var image = await pickerProfile.getImage(
        source: source,
        imageQuality: 60,
      );
      if (image != null) {
        List<int> imageBytes = File(image.path).readAsBytesSync();
        setState(() {
          profileFile = File(image.path);
          base64ImageProfile = base64Encode(imageBytes);
          bytesProfile = base64.decode(base64ImageProfile);
          print('Encoded Image here $base64ImageProfile');
        });
      }
    }).catchError((onError) {
      log(onError.toString());
      AlertsManager().showError(
          context: context,
          title: 'Ops..',
          body: 'Something Went Wrong',
          description: 'Something Went Wrong');
    });
  }

  bool loading = false;
  final coverPicker = ImagePicker();
  String base64ImageCover;
  File coverFile;
  Uint8List bytesCover;
  Future getCoverImage() async {
    ImageSource source;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Theme(
          data: ThemeData.light(),
          child: AlertDialog(
            elevation: 3,
            title: Text("Add Image"),
            content: Text("Where do you want to get the image?"),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "Camera",
                ),
                onPressed: () {
                  setState(() {
                    source = ImageSource.camera;
                  });
                  Navigator.pop(context);
                },
              ),
              Builder(
                builder: (context) {
                  return FlatButton(
                    child: Text(
                      "Gallery",
                    ),
                    onPressed: () {
                      setState(() {
                        source = ImageSource.gallery;
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              )
              // usually buttons at the bottom of the dialog
              ,
            ],
          ),
        );
      },
    ).then((value) async {
      var image = await coverPicker.getImage(
        source: source,
        imageQuality: 60,
      );
      if (image != null) {
        List<int> imageBytes = File(image.path).readAsBytesSync();
        setState(() {
          coverFile = File(image.path);
          base64ImageCover = base64Encode(imageBytes);
          bytesCover = base64.decode(base64ImageCover);
          print('Encoded Image here $base64ImageCover');
        });
      }
    }).catchError((onError) {
      log(onError.toString());
      AlertsManager().showError(
          context: context,
          title: 'Ops..',
          body: 'Something Went Wrong',
          description: 'Something Went Wrong');
    });
  }

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: user.email);
    _oldPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _nameController = TextEditingController(text: user.name);
    _addressController =
        TextEditingController(text: user.address == null ? '' : user.address);
    _ageController =
        TextEditingController(text: user.age == null ? '' : user.age);
  }

  @override
  Widget build(BuildContext context) {
    ApplicationProvider applicationProvider =
        Provider.of<ApplicationProvider>(context, listen: true);
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          backgroundColor: Color(0xFF707070),
          iconTheme: IconThemeData(color: Colors.white),
          automaticallyImplyLeading: true,
          title: Text('Edit Profile'),
          // centerTitle: true,
          elevation: 1,
        ),
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 4, bottom: 8),
                        child: Text(
                          'Profile Photo',
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          getProfileImage();
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(9),
                          child: profileFile == null
                              ? CachedNetworkImage(
                                  imageUrl: user.image,
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * 0.25,
                                  fit: BoxFit.cover,
                                )
                              : Image.file(profileFile),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 4, bottom: 8),
                        child: Text(
                          'Cover Photo',
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          getCoverImage();
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(9),
                          child: coverFile == null
                              ? CachedNetworkImage(
                                  imageUrl: user.cover,
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * 0.25,
                                  fit: BoxFit.cover,
                                )
                              : Image.file(coverFile),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 4, bottom: 8),
                        child: Text(
                          'Email',
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Color(0x4D707070),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                          child: TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            obscureText: false,
                            decoration: InputDecoration(
                              hintText: 'user@user.user',
                              hintStyle: TextStyle(
                                  color: Color(0xff707070).withOpacity(0.7)),
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: EdgeInsets.all(8),
                            ),
                            style: TextStyle(color: Colors.black),
                            // textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 4, bottom: 8),
                        child: Text(
                          'Current Password',
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Color(0x4D707070),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                          child: TextFormField(
                            controller: _oldPasswordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'Your Password',
                              hintStyle: TextStyle(
                                  color: Color(0xff707070).withOpacity(0.7)),
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: EdgeInsets.all(8),
                            ),
                            style: TextStyle(color: Colors.black),
                            // textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 4, bottom: 8),
                        child: Text(
                          'New Password',
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Color(0x4D707070),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                          child: TextFormField(
                            controller: _newPasswordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'New Password',
                              hintStyle: TextStyle(
                                  color: Color(0xff707070).withOpacity(0.7)),
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: EdgeInsets.all(8),
                            ),
                            style: TextStyle(color: Colors.black),
                            // textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 4, bottom: 8),
                        child: Text(
                          'Name',
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Color(0x4D707070),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                          child: TextFormField(
                            controller: _nameController,
                            obscureText: false,
                            decoration: InputDecoration(
                              hintText: 'Your Name',
                              hintStyle: TextStyle(
                                  color: Color(0xff707070).withOpacity(0.7)),
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: EdgeInsets.all(8),
                            ),
                            style: TextStyle(color: Colors.black),
                            // textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 4, bottom: 8),
                        child: Text(
                          'Address',
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Color(0x4D707070),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                          child: TextFormField(
                            controller: _addressController,
                            obscureText: false,
                            decoration: InputDecoration(
                              hintText: 'Your Address',
                              hintStyle: TextStyle(
                                  color: Color(0xff707070).withOpacity(0.7)),
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: EdgeInsets.all(8),
                            ),
                            style: TextStyle(color: Colors.black),
                            // textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    setState(() {
                      loading = true;
                    });
                    await HomeServices()
                        .updateProfile(
                      cImage: coverFile,
                      pImage: profileFile,
                      address: _addressController.text.trim().isEmpty
                          ? null
                          : _addressController.text.trim(),
                      email: _emailController.text.trim().isEmpty
                          ? null
                          : _emailController.text.trim(),
                      name: _nameController.text.trim().isEmpty
                          ? null
                          : _nameController.text.trim(),
                      newPassword: _newPasswordController.text.trim().isEmpty
                          ? null
                          : _newPasswordController.text.trim(),
                      oldPassword: _oldPasswordController.text.trim().isEmpty
                          ? null
                          : _oldPasswordController.text.trim(),
                    )
                        .then((value) async {
                      await FriendsServices()
                          .userInfoApi(userId: user.id)
                          .then((value) async {
                        Map<String, dynamic> info = {
                          'id': user.id,
                          'name': value.name,
                          'email': value.email,
                          'image': value.image,
                          'cover': value.cover,
                          'address': value.address,
                        };

                        await SharedPref().save('user', info);
                        String tempUser = await readData(key: 'user');
                        setState(() {
                          user = UserInfo.fromJson(json.decode(tempUser));
                          loading = false;
                        });
                        Navigator.pushReplacement(
                            context,
                            PageTransition(
                                duration: Duration(milliseconds: 600),
                                type: PageTransitionType.fade,
                                child: ProfilePageScreen(
                                  userId: user.id,
                                  isMine: true,
                                )));
                      }).catchError((onError) {
                        log(onError.toString());
                        setState(() {
                          loading = false;
                        });
                        AlertsManager().showError(
                            context: context,
                            title: 'Ops..',
                            body: 'Something Went Wrong',
                            description: 'Something Went Wrong');
                      });
                    }).catchError((onError) {
                      log(onError.toString());
                      setState(() {
                        loading = false;
                      });
                      AlertsManager().showError(
                          context: context,
                          title: 'Ops..',
                          body: 'Something Went Wrong',
                          description: 'Something Went Wrong');
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(35, 0, 35, 0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: MediaQuery.of(context).size.height * 0.08,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Center(
                          child: loading
                              ? SpinKitWave(
                                  color: Colors.white,
                                  size: 14,
                                )
                              : Text(
                                  'Save Edits',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
