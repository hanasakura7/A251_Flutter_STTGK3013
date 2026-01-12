class User {
  String? userId;
  String? userName;
  String? userEmail;
  String? userPassword;
  String? userPhone;
  String? userRegdate;
  String? userprofileImage;

  //userid, name, email, password, phone, reg_date
  User({
    this.userId,
    this.userName,
    this.userEmail,
    this.userPassword,
    this.userPhone,
    this.userRegdate,
    this.userprofileImage,
  });

  User.fromJson(Map<String, dynamic> json) {
    userId = json['user_id']?.toString() ?? '0'; // Ensure it's a string
    userName = json['name'] ?? 'Guest';
    userEmail = json['email'] ?? '';
    userPassword = json['password'] ?? '';
    userPhone = json['phone'] ?? '';
    userRegdate = json['reg_date'] ?? '';
    userprofileImage = json['profile_image'] ?? ""; // Turn null into empty string
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['name'] = userName;
    data['email'] = userEmail;
    data['password'] = userPassword;
    data['phone'] = userPhone;
    data['reg_date'] = userRegdate;
    data['profile_image'] = userprofileImage;
    return data;
  }
} //user
