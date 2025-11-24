class User {
  String? userId;
  String? userName;
  String? userEmail;
  String? userPassword;
  String? userPhone;
  String? userRegdate;

  //userid, name, email, password, phone, reg_date
  User(
    {this.userId,
    this.userName,
    this.userEmail,
    this.userPassword,
    this.userPhone,
    this.userRegdate});

  User.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userName = json['name'];
    userEmail = json['email'];
    userPassword = json['password'];
    userPhone = json['phone'];
    userRegdate = json['reg_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['name'] = userName;
    data['email'] = userEmail;
    data['password'] = userPassword;
    data['phone'] = userPhone;
    data['reg_date'] = userRegdate;
    return data;
  }
} //user
