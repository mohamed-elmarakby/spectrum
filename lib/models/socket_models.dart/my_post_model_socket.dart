class MyPostModel {
  dynamic image;
  bool isEdited;
  String sId;
  String authorId;
  String text;
  String date;
  List<MyLikes> likes;
  List<MyComments> comments;
  int iV;

  MyPostModel(
      {this.image,
      this.isEdited,
      this.sId,
      this.authorId,
      this.text,
      this.date,
      this.likes,
      this.comments,
      this.iV});

  MyPostModel.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    isEdited = json['isEdited'];
    sId = json['_id'];
    authorId = json['authorId'];
    text = json['text'];
    date = json['date'];
    if (json['likes'] != null) {
      likes = new List<MyLikes>();
      json['likes'].forEach((v) {
        likes.add(new MyLikes.fromJson(v));
      });
    }
    if (json['comments'] != null) {
      comments = new List<MyComments>();
      json['comments'].forEach((v) {
        comments.add(new MyComments.fromJson(v));
      });
    }
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['isEdited'] = this.isEdited;
    data['_id'] = this.sId;
    data['authorId'] = this.authorId;
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

class MyLikes {
  String sId;
  String id;
  String date;

  MyLikes({this.sId, this.id, this.date});

  MyLikes.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    id = json['id'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['id'] = this.id;
    data['date'] = this.date;
    return data;
  }
}

class MyComments {
  bool isEdited;
  String sId;
  CommenterId commenterId;
  String text;

  MyComments({this.isEdited, this.sId, this.commenterId, this.text});

  MyComments.fromJson(Map<String, dynamic> json) {
    isEdited = json['isEdited'];
    sId = json['_id'];
    commenterId = json['commenterId'] != null
        ? new CommenterId.fromJson(json['commenterId'])
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

class CommenterId {
  dynamic image;
  String sId;
  String name;

  CommenterId({this.image, this.sId, this.name});

  CommenterId.fromJson(Map<String, dynamic> json) {
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
