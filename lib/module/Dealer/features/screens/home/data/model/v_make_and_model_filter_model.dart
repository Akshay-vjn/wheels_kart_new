class MakeAndModelForFilterModel {
  final String makeId;
  final String makeName;
  final List<Model> models;

  MakeAndModelForFilterModel({
    required this.makeId,
    required this.makeName,
    required this.models,
  });

  factory MakeAndModelForFilterModel.fromJson(Map<String, dynamic> json) {
    // Set<Model> models = json["models"].map((x) {
    //   if()
    //   Model.fromJson(x);
    // });
    final modelMaps = json["models"] as List;
    List<Model> models = [];
    if (modelMaps.isNotEmpty) {
      for (var x in modelMaps) {
        if (!models.any((element) => element.modelName == x['modelName'])) {
          models.add(Model.fromJson(x));
        }
      }
    }
    return MakeAndModelForFilterModel(
      makeId: json["makeId"],
      makeName: json["makeName"],
      models: models,
      // List<Model>.from(
      //   json["models"].map((x) => Model.fromJson(x)),
      // ),
    );
  }

  Map<String, dynamic> toJson() => {
    "makeId": makeId,
    "makeName": makeName,
    "models": List<dynamic>.from(models.map((x) => x.toJson())),
  };
}

class Model {
  final String modelId;
  final String modelName;
  final String modelFullName;

  Model({
    required this.modelId,
    required this.modelName,
    required this.modelFullName,
  });

  factory Model.fromJson(Map<String, dynamic> json) => Model(
    modelId: json["modelId"],
    modelName: json["modelName"],
    modelFullName: json["modelFullName"],
  );

  Map<String, dynamic> toJson() => {
    "modelId": modelId,
    "modelName": modelName,
    "modelFullName": modelFullName,
  };
}
