class UserLogin {
  User? user;
  late String message;
  late String token;

  UserLogin({this.user, required this.message, required this.token});

  UserLogin.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    message = json['message'];
    token = json['token'];
    print(token);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user?.toJson();
    }
    data['message'] = message;
    data['token'] = token;
    return data;
  }
}

class User {
  late int id;
  late String name;
  late String email;
  String? emailVerifiedAt;
  late String userType;
  late String personalEmail;
  late String contact;
  late String department;
  late String createdAt;
  late String updatedAt;
  late String suspended;
  String? role;
  String? personalNumber;
  String? lastLogin;
  String? active;
  String? profileImage;
  String? deletedAt;
  String? profileImageUrl;
  bool isLeader = false;
  bool approved = false;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.emailVerifiedAt,
    required this.userType,
    required this.createdAt,
    required this.updatedAt,
    required this.approved,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    userType = json['user_type'];
    personalEmail = json['personal_email'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    approved = json['approved'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['user_type'] = userType;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;

    return data;
  }
}
