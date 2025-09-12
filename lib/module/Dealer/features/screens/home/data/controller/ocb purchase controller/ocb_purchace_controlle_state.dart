part of 'ocb_purchace_controlle_cubit.dart';

@immutable
sealed class OcbPurchaceControlleState {}

final class OcbPurchaceControlleInitial extends OcbPurchaceControlleState {}

final class OcbPurchaseLoadingState extends OcbPurchaceControlleState {}

final class OcbPurchaseErrorState extends OcbPurchaceControlleState {}

final class OcbPurchaseSuccesState extends OcbPurchaceControlleState {}
