part of 'payment_history_controller_cubit.dart';

@immutable
sealed class PaymentHistoryControllerState {}

final class PaymentHistoryControllerInitialState
    extends PaymentHistoryControllerState {}

final class PaymentHistoryControllerLoadingState
    extends PaymentHistoryControllerState {}

final class PaymentHistoryControllerErrorState
    extends PaymentHistoryControllerState {
  final String errorMesage;

  PaymentHistoryControllerErrorState({required this.errorMesage});
}

final class PaymentHistoryControllerSuccessState
    extends PaymentHistoryControllerState {
  final List<PaymentHistoryModel> payments;

  PaymentHistoryControllerSuccessState({required this.payments});
}
