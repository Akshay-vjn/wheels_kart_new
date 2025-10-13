import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:wheels_kart/module/Dealer/features/screens/account/data/model/v_rsd_model.dart';
import 'package:wheels_kart/module/Dealer/features/screens/account/data/repo/v_get_rsd_repo.dart';

part 'rsd_controller_state.dart';

/// Controller for RSD (Refundable Security Deposit) operations
/// Manages the state of RSD data fetching and updates
class RsdControllerCubit extends Cubit<RsdControllerState> {
  RsdControllerCubit() : super(RsdControllerInitialState());

  /// Fetches RSD list from the server
  /// 
  /// Emits:
  /// - [RsdControllerLoadingState] while fetching
  /// - [RsdControllerSuccessState] on success with RSD list
  /// - [RsdControllerErrorState] on failure with error message
  Future<void> fetchRsdList(BuildContext context) async {
    try {
      emit(RsdControllerLoadingState());

      final response = await VGetRsdRepo.getRsdList(context);

      if (response.isNotEmpty) {
        if (response['error'] == false) {
          final data = response['data'] as List;
          final rsdList = data
              .map((item) => RsdModel.fromJson(item))
              .toList();

          emit(RsdControllerSuccessState(rsdList: rsdList));
        } else {
          emit(
            RsdControllerErrorState(
              errorMessage: response['message'] ?? 'Failed to fetch RSD data',
            ),
          );
        }
      } else {
        emit(
          RsdControllerErrorState(
            errorMessage: 'No response from server',
          ),
        );
      }
    } catch (e) {
      emit(
        RsdControllerErrorState(
          errorMessage: 'Error: ${e.toString()}',
        ),
      );
    }
  }

  /// Refreshes the RSD list
  /// Can be called on pull-to-refresh
  Future<void> refreshRsdList(BuildContext context) async {
    await fetchRsdList(context);
  }
}

