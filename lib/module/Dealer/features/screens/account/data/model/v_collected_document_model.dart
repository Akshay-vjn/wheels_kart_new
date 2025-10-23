class CollectedDocumetsModel {
    final String collectionId;
    final String inspection;
    final String documentName;
    final String isCollected;
    final DateTime collectedDate;
    final String image;

    CollectedDocumetsModel({
        required this.collectionId,
        required this.inspection,
        required this.documentName,
        required this.isCollected,
        required this.collectedDate,
        required this.image,
    });

    factory CollectedDocumetsModel.fromJson(Map<String, dynamic> json) => CollectedDocumetsModel(
        collectionId: json["collectionId"]??'',
        inspection: json["inspection"]??'',
        documentName: json["documentName"]??'',
        isCollected: json["isCollected"]??'',
        collectedDate: DateTime.parse(json["collectedDate"]),
        image: json["image"]??'',
    );

    Map<String, dynamic> toJson() => {
        "collectionId": collectionId,
        "inspection": inspection,
        "documentName": documentName,
        "isCollected": isCollected,
        "collectedDate": "${collectedDate.year.toString().padLeft(4, '0')}-${collectedDate.month.toString().padLeft(2, '0')}-${collectedDate.day.toString().padLeft(2, '0')}",
        "image": image,
    };
}