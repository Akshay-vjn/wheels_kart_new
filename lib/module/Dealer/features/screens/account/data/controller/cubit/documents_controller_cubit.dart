import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wheels_kart/module/Dealer/features/screens/account/data/model/v_received_documents_model.dart';

part 'documents_controller_state.dart';

class DocumentsControllerCubit extends Cubit<DocumentsControllerState> {
  DocumentsControllerCubit() : super(DocumentsControllerInitial());
}
