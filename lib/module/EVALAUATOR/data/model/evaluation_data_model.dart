class EvaluationDataEntryModel {
  String inspectionId;
  String? engineTypeId;
  String? makeId;
  String? makeYear;
  String? carMake;
  String? carModel;
  String ?modelId;
  String? fuelType;
  String? transmissionType;
  String? varient;
  String? vehicleRegNumber;
  String? totalKmsDriven;
  String? carLocation;
  String? locationID;
  String? varientId;

  EvaluationDataEntryModel(
      {required this.inspectionId,
       this.modelId,
      this.engineTypeId,
      this.makeId,
      this.makeYear,
      this.carMake,
      this.carModel,
      this.varient,
      this.fuelType,
      this.vehicleRegNumber,
      this.totalKmsDriven,
      this.carLocation,
      this.varientId,
      this.transmissionType,
      this.locationID});
}
