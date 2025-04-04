class AppString {
  static const String mobileNumberKey = 'MOBILE_NUMBER';
  static const String passwordKey = 'PASSWORD_KEY';
  static const String tokenKey = 'TOKEN_KEY';
  static const String userId = "USER_ID";
  static const String userName = "USER_NAME";
  static const String userType = "USER_TYPE";
  // static const String tokenExpireMessage = 'TOKEN_EXPIRE_MESSAGE';
  static const String baseUrl = 'https://crisantdemo.in/wheels/api/';

  static RegExp carRegNumberRegex = RegExp(r'^[A-Z]{2}\d{2}[A-Z]{1,2}\d{4}$');

  static const List<String> listOfSteps = [
    'Brand',
    'Year',
    'Model',
    'Varient',
    'Reg. No.',
    'Kms Driven',
    'Car location'
  ];
}
