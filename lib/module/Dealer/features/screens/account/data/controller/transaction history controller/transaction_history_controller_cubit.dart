import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'transaction_history_controller_state.dart';

class TransactionHistoryControllerCubit extends Cubit<TransactionHistoryControllerState> {
  TransactionHistoryControllerCubit() : super(TransactionHistoryControllerInitial());
}
