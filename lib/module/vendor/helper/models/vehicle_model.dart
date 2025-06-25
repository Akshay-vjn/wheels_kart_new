class VehicleModel {
  final String id;
  final String name;
  final String model;
  final String fuelType;
  final String regNumber;
  final String ownership;
  final String kmDriven;
  final String price;
  final String imageUrl;
  final List<String> features;

  VehicleModel({
    required this.id,
    required this.name,
    required this.model,
    required this.fuelType,
    required this.regNumber,
    required this.ownership,
    required this.kmDriven,
    required this.price,
    required this.imageUrl,
    required this.features,
  });
}