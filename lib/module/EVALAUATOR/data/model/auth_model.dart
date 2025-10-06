class AuthUserModel {
  String? mobileNumber;
  // String? password;
  String? token;
  String? userName;
  String? userId;
  String? userType;
  bool? isDealerAcceptedTermsAndCondition;
  // String tokenExpireMessage;

  AuthUserModel({
    this.mobileNumber,
    // this.password,
    this.token,
    this.userId,
    this.userName,
    this.userType,
    this.isDealerAcceptedTermsAndCondition,
    // required this.tokenExpireMessage
  });
}
