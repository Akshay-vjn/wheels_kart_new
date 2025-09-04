import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:wheels_kart/module/Dealer/features/screens/account/data/model/v_payment_model.dart';
import 'package:wheels_kart/module/Dealer/features/screens/account/data/repo/v_get_payment_history_repo.dart';

part 'payment_history_controller_state.dart';

class PaymentHistoryControllerCubit
    extends Cubit<PaymentHistoryControllerState> {
  PaymentHistoryControllerCubit()
    : super(PaymentHistoryControllerInitialState());

  Future<void> onGetPaymentHistory(BuildContext context) async {
    try {
      emit(PaymentHistoryControllerLoadingState());
      final response = await VGetPaymentHistoryRepo.onGetPaymentHistory(
        context,
      );

      if (response.isNotEmpty) {
        if (response['error'] == false) {
          final data = response['data'] as List;
          emit(
            PaymentHistoryControllerSuccessState(
              payments:
                  data.map((e) => PaymentHistoryModel.fromJson(e)).toList(),
            ),
          );
        } else {
          emit(
            PaymentHistoryControllerErrorState(
              errorMesage: response['message'],
            ),
          );
        }
      }
    } catch (e) {
      emit(PaymentHistoryControllerErrorState(errorMesage: e.toString()));
    }
  }
}
