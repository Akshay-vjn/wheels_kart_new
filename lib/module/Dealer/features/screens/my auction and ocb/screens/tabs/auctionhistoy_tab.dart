import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wheels_kart/common/components/app_empty_text.dart';
import 'package:wheels_kart/common/components/app_spacer.dart';
import 'package:wheels_kart/module/Dealer/core/components/v_loading.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_colors.dart';
import 'package:wheels_kart/module/Dealer/core/v_style.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/controller/v%20details%20controller/v_details_controller_bloc.dart';
import 'package:wheels_kart/module/Dealer/features/screens/my%20auction%20and%20ocb/data/controller/bloc/v_my_auction_controller_bloc.dart';
import 'package:wheels_kart/module/Dealer/features/screens/my%20auction%20and%20ocb/screens/v_mybid_screen.dart';

class AuctionHistoryTab extends StatefulWidget {
  const AuctionHistoryTab({super.key});

  @override
  State<AuctionHistoryTab> createState() => _AuctionHistoryTabState();
}

class _AuctionHistoryTabState extends State<AuctionHistoryTab> {
  @override
  void initState() {
    context.read<VMyAuctionControllerBloc>().add(
      OnGetMyAuctions(context: context),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VMyAuctionControllerBloc, VMyAuctionControllerState>(
      builder: (context, state) {
        switch (state) {
          case VMyAuctionControllerSuccessState():
            {
              final list = state.listOfMyAuctions;
              return ListView.separated(
                itemCount: list.length,
                separatorBuilder:
                    (context, index) => AppSpacer(heightPortion: .01),
                padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                itemBuilder: (context, index) {
                  final auction = list[index];
                  bool isSoldToMe = auction.bidStatus == "SOLD";
                  bool isMeHighBidder =
                      !isSoldToMe
                          ? auction.bidAmount == auction.yourBid
                          : false;
                  return Container(
                    // padding: EdgeInsets.all(10)
                    // ,\
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: BoxDecoration(
                      color: VColors.WHITE,
                      border: Border.all(
                        width: .5,
                        color:
                            isSoldToMe
                                ? VColors.GREENHARD
                                : isMeHighBidder
                                ? VColors.SECONDARY
                                : VColors.ERROR,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: VMybidScreen.buildImageSection(
                                auction.frontImage,
                                auction.inspectionId,
                              ),
                            ),
                            AppSpacer(widthPortion: .02),
                            Flexible(
                              child: VMybidScreen.buildHeader(
                                context,
                                auction.manufacturingYear,
                                auction.brandName,
                                auction.modelName,
                                auction.city,
                                auction.evaluationId,
                              ),
                            ),
                            AppSpacer(widthPortion: .02),
                          ],
                        ),
                        AppSpacer(heightPortion: .01),
                        // SOLD TO ME
                        if (isSoldToMe) ...[
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(color: VColors.GREENHARD),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  auction.bidStatus,
                                  style: VStyle.style(
                                    context: context,
                                    size: 16,
                                    fontWeight: FontWeight.w500,
                                    color: VColors.WHITE,
                                  ),
                                ),
                                Text(
                                  "Price : ₹${auction.bidAmount}",
                                  style: VStyle.style(
                                    context: context,
                                    size: 16,
                                    fontWeight: FontWeight.w500,
                                    color: VColors.WHITE,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        // STILL ACTIVE
                        if (!isSoldToMe) ...[
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isMeHighBidder
                                      ? VColors.GREENHARD.withAlpha(100)
                                      : VColors.ACCENT.withAlpha(100),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // its LIVE/ ACTIVE an YOUR THE LOOSING BIDDER
                                if (!isMeHighBidder) ...[
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,

                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Current Bid",
                                            style: VStyle.style(
                                              context: context,
                                              color: VColors.WHITE.withAlpha(
                                                200,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "₹${auction.bidAmount}",
                                            style: VStyle.style(
                                              context: context,
                                              size: 20,
                                              color: VColors.WHITE,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 50,
                                        child: VerticalDivider(
                                          color: VColors.DARK_GREY.withAlpha(
                                            140,
                                          ),
                                          thickness: .5,
                                        ),
                                      ),

                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Your Bid",
                                            style: VStyle.style(
                                              context: context,
                                              size: 8,
                                              color: VColors.ERROR.withAlpha(
                                                200,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "₹${auction.yourBid}",
                                            style: VStyle.style(
                                              context: context,
                                              size: 14,
                                              color: VColors.ERROR,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  InkWell(
                                    onTap: () {
                                      VDetailsControllerBloc.openWhatsApp(
                                        context: context,
                                        currentBid: auction.bidAmount,
                                        evaluationId: auction.evaluationId,
                                        image: auction.frontImage,
                                        kmDrive: auction.kmsDriven,
                                        manufactureYear:
                                            auction.manufacturingYear,
                                        model: auction.modelName,
                                        noOfOwners: '',
                                        regNumber: auction.regNo,
                                      );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: VColors.PRIMARY,
                                      ),
                                      child: Text(
                                        "Bid Price",
                                        style: VStyle.style(
                                          context: context,
                                          color: VColors.WHITE,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                                // its LIVE/ ACTIVE an YOUR THE HIGHSET BIDDER
                                if (isMeHighBidder) ...[
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Your Bid",
                                        style: VStyle.style(
                                          context: context,
                                          size: 13,
                                          color: VColors.WHITE.withAlpha(200),
                                        ),
                                      ),
                                      Text(
                                        "₹${auction.yourBid}",
                                        style: VStyle.style(
                                          context: context,
                                          size: 18,
                                          color: VColors.WHITE,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "Winning",
                                    style: VStyle.style(
                                      context: context,
                                      color: VColors.GREENHARD,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              );
            }
          case VMyAuctionControllerErrorState():
            {
              return AppEmptyText(text: state.error);
            }
          default:
            {
              return VLoadingIndicator();
            }
        }
      },
    );
  }
}
