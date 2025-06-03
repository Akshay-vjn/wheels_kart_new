import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/model/picture_angle_model.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/repositories/master/fetch_picture_angle_repo.dart';

part 'fetch_picture_angles_state.dart';

class FetchPictureAnglesCubit extends Cubit<FetchPictureAnglesState> {
  FetchPictureAnglesCubit() : super(FetchPictureAnglesInitialState());

  Future<void> onFetchPictureAngles(BuildContext context) async {
    try {
      emit(FetchPictureAnglesLoadingState());
      final response = await FetchPictureAngleRepo.fetchPictureAAngles(context);
      if (response.isNotEmpty) {
        if (response['error'] == false) {
          final data = response['data'] as List;
          emit(
            FetchPictureAnglesSuccessState(
              pictureAngles:
                  data.map((e) => PictureAngleModel.fromJson(e)).toList(),
            ),
          );
        } else {
          emit(FetchPictureAnglesErrorState(error: response['message']));
        }
      } else {
        emit(FetchPictureAnglesErrorState(error: 'Error - No response fonud'));
      }
    } catch (e) {
      emit(FetchPictureAnglesErrorState(error: 'Error - $e'));
    }
  }
}
