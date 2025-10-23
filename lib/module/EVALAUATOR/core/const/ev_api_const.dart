class EvApiConst {
  static const String baseUrl = 'https://wheelskart.in/api/';

  static const String deleteDoc = "inspections/deletedocument";
  static const String deleteVehiclePhoto = "inspections/deletepicture";
  static const String dowloadinspectionPdf = "pdf";
  static const String fetchDocs = "inspections/viewdocuments";
  static const String fetchInspectionsPrefill = "inspections/details";
  static const String fetchInspections = "inspections";
  static const String fetchUploadedVehicle = "inspections/viewpictures";
  static const String newInspection = "inspections/create";
  static const String updateInspection = "inspections/update";
  static const String updatedInspectionStatus = "inspections/changestatus";
  static const String uploadDoc = "inspections/uploaddocuments";
  static const String uploadInspection = "inspections/recordresponse";
  static const String uploadVehiclePhoto = "inspections/uploadpictures";
  static const String deleteVideo = "inspections/deleteVideo";
  static const String viewVideos = "inspections/viewvideos";
  static const String uploadVideo = "inspections/uploadvideos";
  static const String updateRemarks = "inspections/updateremarks";

  static const String fetchDahsbord = "login/dashboard";
  static const String fetchProfile = "login/profile";
  static const String login = "login";
  static const String verifyOTP = "login/verify";
  static const String resendOTP = "login/resend";
  static const String register = "inspections/register";

  static const String fetchDocTypes = 'masters/documenttypes';
  static const String fetchPictureAngles = 'masters/pictureangles';
  static const String fetchPortions = 'masters/portions';
  static const String fetchQuestions = "masters/questions";
  static const String fetchSystems = "masters/systems";
  static const String fetchInstructions = "masters/instructions";

  static const String fetchCarMake = "make";
  static const String fetchCarModel = "makemodels";
  static const String fetchCarVarient = "variants";
  static const String fetchCity = "city";

  static const String deleteAccount = "login/deleteevaluator";
}
