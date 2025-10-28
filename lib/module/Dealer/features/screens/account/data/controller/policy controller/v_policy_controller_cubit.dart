import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:wheels_kart/module/Dealer/features/screens/account/data/repo/v_policy_repo.dart';

part 'v_policy_controller_state.dart';

class VPolicyControllerCubit extends Cubit<VPolicyControllerState> {
  VPolicyControllerCubit() : super(VPolicyControllerInitialState());

  Future<void> fetchPolicy(BuildContext context) async {
    emit(VPolicyControllerLoadingState());
    final response = await VPolicyRepo.fetchPolicy(context);
    
    if (response.isNotEmpty) {
      if (response['error'] == false) {
        // The API returns data as an array with the first element containing the policy
        final List dataList = response['data'] as List;
        if (dataList.isNotEmpty) {
          final policyData = dataList[0] as Map<String, dynamic>;
          final terms = policyData['terms'] as String?;
          
          log("Policy Fetched Successfully");
          emit(VPolicyControllerSuccessState(htmlContent: terms ?? ''));
        } else {
          emit(VPolicyControllerErrorState(error: 'No policy data found'));
        }
      } else {
        emit(VPolicyControllerErrorState(error: response['message'] ?? 'Failed to fetch policy'));
      }
    } else {
      emit(VPolicyControllerErrorState(error: "Failed to fetch policy"));
    }
  }
}

