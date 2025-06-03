class AuthUserModel {
  String mobileNumber;
  String password;
  String token;
  String userName;
  String userId;
  String userType;
  // String tokenExpireMessage;

  AuthUserModel({
    required this.mobileNumber,
    required this.password,
    required this.token,
    required this.userId,
    required this.userName,
    required this.userType
    // required this.tokenExpireMessage
  });
}
