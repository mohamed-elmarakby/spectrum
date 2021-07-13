class AllGroupsModel {
  String sId;
  List<Groups> groups;

  AllGroupsModel({this.sId, this.groups});

  AllGroupsModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    if (json['groups'] != null) {
      groups = new List<Groups>();
      json['groups'].forEach((v) {
        groups.add(new Groups.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.groups != null) {
      data['groups'] = this.groups.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Groups {
  String sId;
  Admin admin;
  String groupId;
  String name;

  Groups({this.sId, this.admin, this.groupId, this.name});

  Groups.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    admin = json['admin'] != null ? new Admin.fromJson(json['admin']) : null;
    groupId = json['groupId'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.admin != null) {
      data['admin'] = this.admin.toJson();
    }
    data['groupId'] = this.groupId;
    data['name'] = this.name;
    return data;
  }
}

class Admin {
  String sId;
  String name;

  Admin({this.sId, this.name});

  Admin.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    return data;
  }
}
