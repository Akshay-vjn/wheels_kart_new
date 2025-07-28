import 'package:wheels_kart/module/EVALAUATOR/data/model/created_at_model.dart';

class VideoModel {
  final String videoId;
  final String inspectionId;
  final dynamic videoType;
  final String video;
  final String status;
  final CreatedAt createdAt;
  final DateTime modifiedAt;

  VideoModel({
    required this.videoId,
    required this.inspectionId,
    required this.videoType,
    required this.video,
    required this.status,
    required this.createdAt,
    required this.modifiedAt,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) => VideoModel(
    videoId: json["videoId"],
    inspectionId: json["inspectionId"],
    videoType: json["videoType"],
    video: json["video"],
    status: json["status"],
    createdAt: CreatedAt.fromJson(json["created_at"]),
    modifiedAt: DateTime.parse(json["modified_at"]),
  );

  Map<String, dynamic> toJson() => {
    "videoId": videoId,
    "inspectionId": inspectionId,
    "videoType": videoType,
    "video": video,
    "status": status,
    "created_at": createdAt.toJson(),
    "modified_at": modifiedAt.toIso8601String(),
  };
}
