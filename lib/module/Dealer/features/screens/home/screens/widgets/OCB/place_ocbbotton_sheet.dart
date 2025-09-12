import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wheels_kart/common/components/app_spacer.dart';
import 'package:wheels_kart/module/Dealer/core/components/v_loading.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_colors.dart';
import 'package:wheels_kart/module/Dealer/core/v_style.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/controller/ocb%20purchase%20controller/ocb_purchace_controlle_cubit.dart';

class PlaceOcbBottomSheet extends StatelessWidget {
  final String currentBid;
  final String inspectionId;
  const PlaceOcbBottomSheet({
    super.key,
    required this.currentBid,
    required this.inspectionId,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Confirm Purchase",
                style: VStyle.style(
                  context: context,
                  fontWeight: FontWeight.bold,
                  size: 18,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "You're about to buy this vehicle.",
                style: VStyle.style(context: context, size: 14),
              ),
              const SizedBox(height: 8),
              Text(
                "Current Price: ₹$currentBid",
                style: VStyle.style(
                  context: context,
                  size: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Once you confirm, our team will contact you to complete the purchase process outside the app. Make sure you're ready to proceed.",
                style: VStyle.style(
                  context: context,
                  size: 13,
                  color: Colors.grey[700],
                ),
              ),
              AppSpacer(heightPortion: .03),
              InkWell(
                onTap: () async {
                  context.read<OcbPurchaceControlleCubit>().onBuyOCB(
                    context,
                    inspectionId,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 24,
                  ),

                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: const Color.fromARGB(255, 255, 152, 7),
                  ),
                  child: BlocBuilder<
                    OcbPurchaceControlleCubit,
                    OcbPurchaceControlleState
                  >(
                    builder: (context, state) {
                      return state is OcbPurchaseLoadingState
                          ? VLoadingIndicator()
                          : Text(
                            "Yes, Confirm & Proceed",
                            style: VStyle.style(
                              context: context,
                              size: 20,
                              fontWeight: FontWeight.bold,
                              color: VColors.WHITE,
                            ),
                          );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
