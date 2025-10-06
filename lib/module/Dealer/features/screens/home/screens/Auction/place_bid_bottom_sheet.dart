import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wheels_kart/common/components/app_spacer.dart';
import 'package:wheels_kart/common/utils/responsive_helper.dart';
import 'package:wheels_kart/module/Dealer/core/components/v_loading.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_colors.dart';
import 'package:wheels_kart/module/Dealer/core/v_style.dart';
import 'package:wheels_kart/module/Dealer/features/screens/favorates/data/controller/wishlist%20controller/v_wishlist_controller_cubit.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/controller/auctionu%20update%20controller/v_auction_update_controller_cubit.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/controller/v%20auction%20controller/v_dashboard_controlller_bloc.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/controller/v%20details%20controller/v_details_controller_bloc.dart';
import 'package:wheels_kart/module/Dealer/features/screens/my%20auction%20and%20ocb/data/controller/my%20auction%20controller/v_my_auction_controller_bloc.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_colors.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/widgets/ev_app_custom_button.dart';

class PlaceBidBottomSheet extends StatefulWidget {
  final String inspectionId;
  final String paymentStatus;
  final String from;
  const PlaceBidBottomSheet({
    super.key,
    required this.inspectionId,
    required this.from,
    required this.paymentStatus,
  });

  @override
  State<PlaceBidBottomSheet> createState() => _PlaceBidBottomSheetState();
}

late TextEditingController _formField;

final _formKey = GlobalKey<FormState>();

class _PlaceBidBottomSheetState extends State<PlaceBidBottomSheet> {
  @override
  void initState() {
    _formField = TextEditingController(text: "2000");
    super.initState();
  }

  void onAdd200() {
    HapticFeedback.selectionClick();
    int currentPrice = 0;
    if (_formField.text.isNotEmpty) {
      currentPrice = int.parse(_formField.text);
      currentPrice += 2000;
    } else {
      currentPrice = 2000;
    }

    _formField.text = currentPrice.toString();
    setState(() {});
  }

  void onChanged(int value) {
    int currentPrice = 0;
    if (_formField.text.isNotEmpty) {
      currentPrice = int.parse(_formField.text);
      currentPrice = value;
    } else {
      currentPrice = value;
    }

    _formField.text = currentPrice.toString();
    setState(() {});
  }

  @override
  void dispose() {
    _formField.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.from == "AUCTION") {
      return BlocBuilder<VAuctionControlllerBloc, VAuctionControlllerState>(
        builder: (context, state) {
          if (state is VAuctionControllerSuccessState) {
            return _buildWidget(
              state.listOfAllAuctionFromServer
                  .firstWhere(
                    (element) => element.inspectionId == widget.inspectionId,
                  )
                  .currentBid
                  .toString(),
            );
          } else {
            return SizedBox();
          }
        },
      );
    } else if (widget.from == "DETAILS") {
      return BlocBuilder<VDetailsControllerBloc, VDetailsControllerState>(
        builder: (context, state) {
          if (state is VDetailsControllerSuccessState) {
            return _buildWidget(state.detail.carDetails.currentBid.toString());
          } else {
            return SizedBox();
          }
        },
      );
    } else if (widget.from == "HISTORY") {
      return BlocBuilder<VMyAuctionControllerBloc, VMyAuctionControllerState>(
        builder: (context, state) {
          if (state is VMyAuctionControllerSuccessState) {
            return _buildWidget(
              state.listOfMyAuctions
                  .firstWhere(
                    (element) => element.inspectionId == widget.inspectionId,
                  )
                  .bidAmount
                  .toString(),
            );
          } else {
            return SizedBox();
          }
        },
      );
    } else if (widget.from == "WISHLIST") {
      return BlocBuilder<VWishlistControllerCubit, VWishlistControllerState>(
        builder: (context, state) {
          if (state is VWishlistControllerSuccessState) {
            return _buildWidget(
              state.myWishList
                  .firstWhere(
                    (element) => element.inspectionId == widget.inspectionId,
                  )
                  .currentBid
                  .toString(),
            );
          } else {
            return SizedBox();
          }
        },
      );
    } else {
      return SizedBox();
    }
  }

  Widget _buildWidget(String price) {
    return SafeArea(
      top: false,
      bottom: Platform.isAndroid,
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          // margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            color: VColors.WHITE,
            border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
          ),
          child: Padding(
            padding:
                widget.paymentStatus == "No"
                    ? EdgeInsetsGeometry.symmetric(vertical: 28, horizontal: 15)
                    : const EdgeInsets.all(28),
            child:
                widget.paymentStatus == "No"
                    ? SizedBox(
                      width: w(context),
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
                            "To participate in this auction, please complete the security deposit. For more details, please contact the administrator.",
                            textAlign: TextAlign.center,
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
                                      log('Could not launch   $e');
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
                                          EvAppColors.DEFAULT_ORANGE.withAlpha(
                                            150,
                                          ),
                                          EvAppColors.DEFAULT_ORANGE,
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(25),
                                      boxShadow: [
                                        BoxShadow(
                                          color: EvAppColors.DEFAULT_ORANGE
                                              .withAlpha(60),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                    )
                    : Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Update Bid",
                            style: VStyle.style(
                              context: context,
                              fontWeight: FontWeight.bold,
                              size: 20,
                            ),
                          ),

                          AppSpacer(heightPortion: .02),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                flex: 2,
                                child: SizedBox(
                                  // height: 50,
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return "Please enter a bid amount";
                                      }

                                      final parsed = int.tryParse(value.trim());
                                      if (parsed == null) {
                                        return "Please enter a valid number";
                                      }

                                      if (parsed < 2000) {
                                        return "Minimum bid amount should be 2000";
                                      }

                                      return null; // valid
                                    },
                                    inputFormatters: [
                                      FilteringTextInputFormatter
                                          .digitsOnly, // only numbers
                                    ],
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      if (value.isNotEmpty) {
                                        onChanged(int.parse(value));
                                      }
                                    },
                                    cursorColor: VColors.BLACK,
                                    controller: _formField,
                                    style: VStyle.style(
                                      context: context,
                                      size: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 10,
                                      ),

                                      // border: OutlineInputBorder(
                                      //   borderRadius: BorderRadius.circular(10),
                                      // ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                child: SizedBox(
                                  height: 50,
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(
                                        color: Color.fromARGB(255, 255, 152, 7),
                                      ),

                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadiusGeometry.circular(10),
                                      ),
                                    ),
                                    onPressed: onAdd200,
                                    child: Text(
                                      "+ 2000",
                                      style: VStyle.style(
                                        context: context,
                                        size: 15,
                                        color: Color.fromARGB(255, 255, 152, 7),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          AppSpacer(heightPortion: .01),
                          Row(
                            children: [
                              Text(
                                "Your Price : ${price}",
                                style: VStyle.style(
                                  context: context,
                                  size: 15,
                                  color: VColors.DARK_GREY,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                " + ${_formField.text}",
                                style: VStyle.style(
                                  context: context,

                                  size: 15,
                                  color: VColors.SECONDARY,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          AppSpacer(heightPortion: .02),
                          BlocBuilder<
                            VAuctionUpdateControllerCubit,
                            VAuctionUpdateControllerState
                          >(
                            builder: (context, state) {
                              if (state is VAuctionUpdateLoadingState) {
                                return Align(child: VLoadingIndicator());
                              }
                              return InkWell(
                                onTap: () async {
                                  if (_formKey.currentState!.validate()) {
                                    await onUpdate();
                                    Navigator.of(context).pop();
                                  }
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 24,
                                  ),

                                  height: 50,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),

                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        VColors.WARNING.withAlpha(150),
                                        VColors.WARNING,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(25),
                                    boxShadow: [
                                      BoxShadow(
                                        color: VColors.WARNING.withAlpha(60),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    "Bid Now",
                                    style: VStyle.style(
                                      context: context,
                                      size: 20,
                                      fontWeight: FontWeight.bold,
                                      color: VColors.WHITE,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
          ),
        ),
      ),
    );
  }

  Future<void> onUpdate() async {
    HapticFeedback.mediumImpact();
    await context.read<VAuctionUpdateControllerCubit>().oUpdateAuction(
      context,
      widget.inspectionId,
      _formField.text,
    );
  }
}
