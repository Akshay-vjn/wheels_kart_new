import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:wheels_kart/common/utils/custome_show_messages.dart';
import 'package:wheels_kart/module/Dealer/features/screens/favorates/data/controller/wishlist%20controller/v_wishlist_controller_cubit.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/controller/ocb%20controller/v_ocb_controller_bloc.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/controller/v%20details%20controller/v_details_controller_bloc.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/repo/v_buy_ocb_auction_repo.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/screens/OCB/place_ocbbotton_sheet.dart';

part 'ocb_purchace_controlle_state.dart';

class OcbPurchaceControlleCubit extends Cubit<OcbPurchaceControlleState> {
  OcbPurchaceControlleCubit() : super(OcbPurchaceControlleInitial());

  Future<void> onBuyOCB(BuildContext context, String inspectionId) async {
    try {
      emit(OcbPurchaseLoadingState());
      final response = await VBuyOcbAuctionRepo.buyOCB(context, inspectionId);
      if (response['error'] == false) {
        context.read<VOcbControllerBloc>().add(OnFechOncList(context: context));
        context.read<VWishlistControllerCubit>().onFetchWishList(context);
        Navigator.of(context).pop();
        showToastMessage(context, response['message'].toString());
      } else {
        emit(OcbPurchaseErrorState());
        Navigator.of(context).pop();
        showToastMessage(
          context,
          response['message'].toString(),
          isError: true,
        );
      }
    } catch (e) {
      emit(OcbPurchaseErrorState());
      Navigator.of(context).pop();
      showToastMessage(context, e.toString(), isError: true);
    }
  }

  static void showBuySheet(
    BuildContext context,
    String currentBid,
    String inspectionId,
    String from,
  ) {
    if (from == "DETAILS") {
      showModalBottomSheet(
        useSafeArea: true,
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        barrierColor: Colors.black.withOpacity(0.5),
        builder:
            (ctxt) => BlocProvider.value(
              value: context.read<VDetailsControllerBloc>(),
              child: PlaceOcbBottomSheet(
                currentBid: currentBid,
                inspectionId: inspectionId,
              ),
            ),
      );
    } else if (from == "OCB") {
      showModalBottomSheet(
        useSafeArea: true,
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        barrierColor: Colors.black.withOpacity(0.5),
        builder:
            (ctxt) => BlocProvider.value(
              value: context.read<VOcbControllerBloc>(),
              child: PlaceOcbBottomSheet(
                currentBid: currentBid,
                inspectionId: inspectionId,
              ),
            ),
      );
    } else if (from == "WISHLIST") {
      showModalBottomSheet(
        useSafeArea: true,
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        barrierColor: Colors.black.withOpacity(0.5),
        builder:
            (ctxt) => BlocProvider.value(
              value: context.read<VWishlistControllerCubit>(),
              child: PlaceOcbBottomSheet(
                currentBid: currentBid,
                inspectionId: inspectionId,
              ),
            ),
      );
    }
  }
}
