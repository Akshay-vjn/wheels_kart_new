class AuthUserModel {
  String? mobileNumber;
  String? password;
  String? token;
  String? userName;
  String? userId;
  String? userType;
  // String tokenExpireMessage;

  AuthUserModel({
    this.mobileNumber,
    this.password,
    this.token,
    this.userId,
    this.userName,
    this.userType,
    // required this.tokenExpireMessage
  });
}
