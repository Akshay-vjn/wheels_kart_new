part of 'fetch_document_type_bloc.dart';

@immutable
sealed class FetchDocumentTypeEvent {

}

final class OnFetchDocumentTypeEvent extends FetchDocumentTypeEvent {
  final BuildContext context;

  OnFetchDocumentTypeEvent({required this.context});
}

final class OnChangeIndex extends FetchDocumentTypeEvent {

}
