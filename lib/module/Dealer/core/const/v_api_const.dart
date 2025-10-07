class VApiConst {
  static const String baseUrl = 'https://wheelskart.in/api/';
  static const String socket = "ws://82.112.238.223:3050";

  static const vendorLogin = "vendorlogin";
  static const vendorVerifyOTP = "vendorlogin/verify";
  static const vendorResendOTP = "vendorlogin/resend";
  static const vendorRegister = "vendorlogin/register";
  static const vendorSavePushToken = "vendorlogin/settoken";
  static const auctionData = "vendorlogin/dashboard";
  static const ocbData = "vendorlogin/ocb";

  static const details = "vendorlogin/details";
  static const profile = "vendorlogin/profile";
  static const editProfile = "vendorlogin/editprofile";
  static const addOrRemoveFromWisglist = "vendorlogin/wishlist";
  static const whishList = "vendorlogin/mywishlist";

  static const myAuctions = "vendorlogin/bidhistory";
  static const myOCB = "vendorlogin/ocbhistory";

  static const buyOCB = "vendorlogin/buynow";
  static const updateAuciton = "vendorlogin/bid";

  static const deleteAccount = "vendorlogin/deletevendor";

  static const transactionHistory = "vendorlogin/payments";

  static const recievedDocuments = "vendorlogin/collecteddocuments";

  static const fetchCity = "masters/city";
  static const fetchMakeModel = "masters/makemodel";
}
