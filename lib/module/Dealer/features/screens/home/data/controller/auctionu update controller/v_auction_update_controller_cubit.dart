import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:wheels_kart/common/utils/custome_show_messages.dart';
import 'package:wheels_kart/module/Dealer/features/screens/favorates/data/controller/wishlist%20controller/v_wishlist_controller_cubit.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/controller/v%20auction%20controller/v_dashboard_controlller_bloc.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/controller/v%20details%20controller/v_details_controller_bloc.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/repo/v_onupdate_auction_repo.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/screens/Auction/place_bid_bottom_sheet.dart';
import 'package:wheels_kart/module/Dealer/features/screens/my%20auction%20and%20ocb/data/controller/my%20auction%20controller/v_my_auction_controller_bloc.dart';

part 'v_auction_update_controller_state.dart';

class VAuctionUpdateControllerCubit
    extends Cubit<VAuctionUpdateControllerState> {
  VAuctionUpdateControllerCubit()
    : super(VAuctionUpdateControllerInitialState());

  Future<void> oUpdateAuction(
    BuildContext context,
    String id,
    String price,
  ) async {
    try {
      emit(VAuctionUpdateLoadingState());
      final response = await VOnupdateAuctionRepo.onUpdateAuction(
        context,
        id,
        price,
      );

      if (response.isNotEmpty) {
        if (response['error'] == false) {
          emit(VAcutionUpdateSuccessState());
          showToastMessage(
            context,
            "Great! Your new bid is in.",
            isError: false,
          );
        } else {
          showToastMessage(context, response['message'], isError: false);
          emit(VAuctionUpdateErrorState());
        }
      } else {
        emit(VAuctionUpdateErrorState());
      }
    } catch (e) {
      emit(VAuctionUpdateErrorState());
    }
  }

  static Future<void> showDiologueForBidWhatsapp({
    required BuildContext context,
    required String inspectionId,
    required String from,
  }) async {
    HapticFeedback.mediumImpact();

    if (from == "AUCTION") {
      showModalBottomSheet(
        useSafeArea: true,
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        barrierColor: Colors.black.withOpacity(0.5),
        builder:
            (ctc) => BlocProvider.value(
              value: context.read<VAuctionControlllerBloc>(),
              child: PlaceBidBottomSheet(
                inspectionId: inspectionId,
                from: from,
              ),
            ),
      );
    } else if (from == "DETAILS") {
      showModalBottomSheet(
         useSafeArea: true,
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        barrierColor: Colors.black.withOpacity(0.5),
        builder:
            (ctc) => BlocProvider.value(
              value: context.read<VDetailsControllerBloc>(),
              child: PlaceBidBottomSheet(
                inspectionId: inspectionId,
                from: from,
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
            (ctc) => BlocProvider.value(
              value: context.read<VWishlistControllerCubit>(),
              child: PlaceBidBottomSheet(
                inspectionId: inspectionId,
                from: from,
              ),
            ),
      );
    } else {
      showModalBottomSheet(
         useSafeArea: true,
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        barrierColor: Colors.black.withOpacity(0.5),
        builder:
            (ctc) => BlocProvider.value(
              value: context.read<VMyAuctionControllerBloc>(),
              child: PlaceBidBottomSheet(
                inspectionId: inspectionId,
                from: from,
              ),
            ),
      );
    }
  }
}
