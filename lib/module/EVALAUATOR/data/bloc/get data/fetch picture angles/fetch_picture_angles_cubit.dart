import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/model/picture_angle_model.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/repositories/master/fetch_picture_angle_repo.dart';

part 'fetch_picture_angles_state.dart';

class FetchPictureAnglesCubit extends Cubit<FetchPictureAnglesState> {
  FetchPictureAnglesCubit() : super(FetchPictureAnglesInitialState());

  // Future<void> onFetchPictureAngles(BuildContext context) async {
  //   try {
  //     emit(FetchPictureAnglesLoadingState());
  //     final response = await FetchPictureAngleRepo.fetchPictureAAngles(context);
  //     if (response.isNotEmpty) {
  //       if (response['error'] == false) {
  //         final data = response['data'] as Map;
  //         log(data.toString());
  //         emit(
  //           FetchPictureAnglesSuccessState(
  //             pictureAngles:
  //                 data.map((e) => PictureAngleModel.fromJson(e)).toList(),
  //           ),
  //         );
  //       } else {
  //         emit(FetchPictureAnglesErrorState(error: response['message']));
  //       }
  //     } else {
  //       emit(FetchPictureAnglesErrorState(error: 'Error - No response fonud'));
  //     }
  //   } catch (e) {
  //     log(e.toString());
  //     emit(FetchPictureAnglesErrorState(error: 'Error - $e'));
  //   }
  // }

  Future<void> onFetchPictureAngles(BuildContext context) async {
    try {
      emit(FetchPictureAnglesLoadingState());

      final response = await FetchPictureAngleRepo.fetchPictureAAngles(context);

      if (response == null || response.isEmpty) {
        emit(FetchPictureAnglesErrorState(error: 'Error - No response found'));
        return;
      }

      if (response['error'] == true) {
        emit(
          FetchPictureAnglesErrorState(
            error: response['message']?.toString() ?? 'Unknown error',
          ),
        );
        return;
      }

      final data = response['data'];
      if (data == null || data is! Map) {
        emit(FetchPictureAnglesErrorState(error: 'Invalid data format'));
        return;
      }

      // Parse each category -> list of PictureAngleModel
      final Map<String, List<PictureAngleModel>> parsed = {};

      data.forEach((key, value) {
        // key example: "Exterior Shots"
        if (value is List) {
          final List<PictureAngleModel> list =
              value
                  .where((e) => e is Map)
                  .map<PictureAngleModel>(
                    (e) => PictureAngleModel.fromJson(
                      Map<String, dynamic>.from(e as Map),
                    ),
                  )
                  .toList();

          // sort by order numeric if possible
          // list.sort((a, b) => a.orderAsInt.compareTo(b.orderAsInt));

          parsed[key.toString()] = list;
        } else {
          // if backend sometimes returns single object rather than list
          if (value is Map) {
            final item = PictureAngleModel.fromJson(
              Map<String, dynamic>.from(value),
            );
            parsed[key.toString()] = [item];
          } else {
            parsed[key.toString()] = [];
          }
        }
      });

      log('Parsed picture angles: ${parsed.keys.toList()}');

      final entries = parsed.entries.toList();
      final List<AngleItem> list = [];
      for (var i = 0; i < entries.length; i++) {
        final catName = entries[i].key;
        final angles = entries[i].value;
        for (var angle in angles) {
          list.add(
            AngleItem(
              angleId: angle.angleId,
              angleName: angle.angleName,
              samplePicture: angle.samplePicture,
              category: catName,
              categoryIndex: i,
            ),
          );
        }
      }
      emit(
        FetchPictureAnglesSuccessState(
          pictureAnglesByCategory: parsed,
          flattenedAngles: list,
        ),
      );
    } catch (e, st) {
      log('onFetchPictureAngles error: $e\n$st');
      emit(FetchPictureAnglesErrorState(error: 'Error - $e'));
    }
  }
}
