class AllOfCurrentUserModel {
  String image;
  String cover;
  List<String> friendRequests;
  List<String> sentRequests;
  dynamic verificationKey;
  List<String> posts;
  String sId;
  String name;
  String email;
  String password;
  int age;
  String address;
  List<Friends> friends;
  List<Notifications> notifications;
  List<Groups> groups;
  int iV;

  AllOfCurrentUserModel(
      {this.image,
      this.cover,
      this.friendRequests,
      this.sentRequests,
      this.verificationKey,
      this.posts,
      this.sId,
      this.name,
      this.email,
      this.password,
      this.age,
      this.address,
      this.friends,
      this.notifications,
      this.groups,
      this.iV});

  AllOfCurrentUserModel.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    cover = json['cover'];
    friendRequests = json['friendRequests'].cast<String>();
    sentRequests = json['sentRequests'].cast<String>();
    verificationKey = json['verificationKey'];
    posts = json['posts'].cast<String>();
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    age = json['age'];
    address = json['address'];
    if (json['friends'] != null) {
      friends = new List<Friends>();
      json['friends'].forEach((v) {
        friends.add(new Friends.fromJson(v));
      });
    }
    if (json['notifications'] != null) {
      notifications = new List<Notifications>();
      json['notifications'].forEach((v) {
        notifications.add(new Notifications.fromJson(v));
      });
    }
    if (json['groups'] != null) {
      groups = new List<Groups>();
      json['groups'].forEach((v) {
        groups.add(new Groups.fromJson(v));
      });
    }
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['cover'] = this.cover;
    data['friendRequests'] = this.friendRequests;
    data['sentRequests'] = this.sentRequests;
    data['verificationKey'] = this.verificationKey;
    data['posts'] = this.posts;
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['password'] = this.password;
    data['age'] = this.age;
    data['address'] = this.address;
    if (this.friends != null) {
      data['friends'] = this.friends.map((v) => v.toJson()).toList();
    }
    if (this.notifications != null) {
      data['notifications'] =
          this.notifications.map((v) => v.toJson()).toList();
    }
    if (this.groups != null) {
      data['groups'] = this.groups.map((v) => v.toJson()).toList();
    }
    data['__v'] = this.iV;
    return data;
  }
}

class Friends {
  String sId;
  Id id;
  String chatId;
  String date;

  Friends({this.sId, this.id, this.chatId, this.date});

  Friends.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    id = json['id'] != null ? new Id.fromJson(json['id']) : null;
    chatId = json['chatId'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.id != null) {
      data['id'] = this.id.toJson();
    }
    data['chatId'] = this.chatId;
    data['date'] = this.date;
    return data;
  }
}

class Id {
  String image;
  List<Posts> posts;
  String sId;
  String name;

  Id({this.image, this.posts, this.sId, this.name});

  Id.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    if (json['posts'] != null) {
      posts = new List<Posts>();
      json['posts'].forEach((v) {
        posts.add(new Posts.fromJson(v));
      });
    }
    sId = json['_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    if (this.posts != null) {
      data['posts'] = this.posts.map((v) => v.toJson()).toList();
    }
    data['_id'] = this.sId;
    data['name'] = this.name;
    return data;
  }
}

class Posts {
  dynamic image;
  bool isEdited;
  String sId;
  AuthorId authorId;
  String text;
  String date;
  List<Likes> likes;
  List<Comments> comments;
  int iV;

  Posts(
      {this.image,
      this.isEdited,
      this.sId,
      this.authorId,
      this.text,
      this.date,
      this.likes,
      this.comments,
      this.iV});

  Posts.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    isEdited = json['isEdited'];
    sId = json['_id'];
    authorId = json['authorId'] != null
        ? new AuthorId.fromJson(json['authorId'])
        : null;
    text = json['text'];
    date = json['date'];
    if (json['likes'] != null) {
      likes = new List<Likes>();
      json['likes'].forEach((v) {
        likes.add(new Likes.fromJson(v));
      });
    }
    if (json['comments'] != null) {
      comments = new List<Comments>();
      json['comments'].forEach((v) {
        comments.add(new Comments.fromJson(v));
      });
    }
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['isEdited'] = this.isEdited;
    data['_id'] = this.sId;
    if (this.authorId != null) {
      data['authorId'] = this.authorId.toJson();
    }
    data['text'] = this.text;
    data['date'] = this.date;
    if (this.likes != null) {
      data['likes'] = this.likes.map((v) => v.toJson()).toList();
    }
    if (this.comments != null) {
      data['comments'] = this.comments.map((v) => v.toJson()).toList();
    }
    data['__v'] = this.iV;
    return data;
  }
}

class AuthorId {
  dynamic image;
  String sId;
  String name;

  AuthorId({this.image, this.sId, this.name});

  AuthorId.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    sId = json['_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['_id'] = this.sId;
    data['name'] = this.name;
    return data;
  }
}

class Likes {
  String sId;
  AuthorId id;
  String date;

  Likes({this.sId, this.id, this.date});

  Likes.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    id = json['id'] != null ? new AuthorId.fromJson(json['id']) : null;
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.id != null) {
      data['id'] = this.id.toJson();
    }
    data['date'] = this.date;
    return data;
  }
}

class Comments {
  bool isEdited;
  String sId;
  AuthorId commenterId;
  String text;

  Comments({this.isEdited, this.sId, this.commenterId, this.text});

  Comments.fromJson(Map<String, dynamic> json) {
    isEdited = json['isEdited'];
    sId = json['_id'];
    commenterId = json['commenterId'] != null
        ? new AuthorId.fromJson(json['commenterId'])
        : null;
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isEdited'] = this.isEdited;
    data['_id'] = this.sId;
    if (this.commenterId != null) {
      data['commenterId'] = this.commenterId.toJson();
    }
    data['text'] = this.text;
    return data;
  }
}

class Notifications {
  String sId;
  String notification;
  String postId;
  bool isViewed;
  String likeId;
  String date;
  String commentId;

  Notifications(
      {this.sId,
      this.notification,
      this.postId,
      this.isViewed,
      this.likeId,
      this.date,
      this.commentId});

  Notifications.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    notification = json['notification'];
    postId = json['postId'];
    isViewed = json['isViewed'];
    likeId = json['likeId'];
    date = json['date'];
    commentId = json['commentId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['notification'] = this.notification;
    data['postId'] = this.postId;
    data['isViewed'] = this.isViewed;
    data['likeId'] = this.likeId;
    data['date'] = this.date;
    data['commentId'] = this.commentId;
    return data;
  }
}

class Groups {
  String sId;
  String admin;
  String groupId;
  String name;

  Groups({this.sId, this.admin, this.groupId, this.name});

  Groups.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    admin = json['admin'];
    groupId = json['groupId'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['admin'] = this.admin;
    data['groupId'] = this.groupId;
    data['name'] = this.name;
    return data;
  }
}
