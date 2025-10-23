import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wheels_kart/common/components/app_spacer.dart';
import 'package:wheels_kart/common/utils/custome_show_messages.dart';
import 'package:wheels_kart/common/utils/responsive_helper.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_colors.dart';
import 'package:wheels_kart/module/Dealer/core/v_style.dart';
import 'package:wheels_kart/module/Dealer/features/screens/favorates/data/controller/wishlist%20controller/v_wishlist_controller_cubit.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/controller/ocb%20controller/v_ocb_controller_bloc.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/controller/v%20details%20controller/v_details_controller_bloc.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/repo/v_buy_ocb_auction_repo.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/screens/OCB/place_ocbbotton_sheet.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_colors.dart';

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

  static Future<void> showDiologueForOcbPurchase({
    required BuildContext context,
    required String inspectionId,
    required String from,
    required String paymentStatus,
    required String currentBid,
  }) async {
    HapticFeedback.mediumImpact();

    if (paymentStatus == "No") {
      // Payment not completed - Show contact bottom sheet (same as bid)
      showModalBottomSheet(
        useSafeArea: true,
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        barrierColor: Colors.black.withOpacity(0.5),
        builder: (context) => SafeArea(
          top: false,
          bottom: Platform.isAndroid,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              color: VColors.WHITE,
              border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 28, horizontal: 15),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Oops!",
                      style: VStyle.poppins(
                        context: context,
                        size: 30,
                        fontWeight: FontWeight.w400,
                        color: VColors.ERROR,
                      ),
                    ),
                    AppSpacer(heightPortion: .02),
                    Text(
                      "To purchase OCB vehicles, please complete the security deposit. For more details, please contact the administrator.",
                      textAlign: TextAlign.center,
                      style: VStyle.poppins(
                        context: context,
                        size: 14,
                      ),
                    ),
                    AppSpacer(heightPortion: .02),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () async {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "Cancel",
                            style: VStyle.poppins(
                              context: context,
                              fontWeight: FontWeight.bold,
                              color: VColors.GREY,
                              size: 20,
                            ),
                          ),
                        ),
                        AppSpacer(widthPortion: .05),
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              try {
                                final Uri launchUri = Uri(
                                  scheme: 'tel',
                                  path: "9964955575",
                                );
                                await launchUrl(launchUri);
                              } catch (e) {
                                print('Could not launch $e');
                              }
                            },
                            child: Container(
                              height: 50,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    EvAppColors.DEFAULT_ORANGE.withAlpha(150),
                                    EvAppColors.DEFAULT_ORANGE,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                    color: EvAppColors.DEFAULT_ORANGE.withAlpha(60),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Contact Us",
                                      style: VStyle.poppins(
                                        context: context,
                                        fontWeight: FontWeight.bold,
                                        color: VColors.WHITE,
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      // Payment completed - Show OCB purchase confirmation
      showModalBottomSheet(
        useSafeArea: true,
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        barrierColor: Colors.black.withOpacity(0.5),
        builder: (ctc) => BlocProvider.value(
          value: context.read<OcbPurchaceControlleCubit>(),
          child: PlaceOcbBottomSheet(
            inspectionId: inspectionId,
            currentBid: currentBid,
          ),
        ),
      );
    }
  }
}
