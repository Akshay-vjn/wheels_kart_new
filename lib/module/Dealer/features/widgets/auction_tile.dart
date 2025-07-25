import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wheels_kart/common/components/app_spacer.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_colors.dart';
import 'package:wheels_kart/module/Dealer/core/v_style.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/controller/v%20details%20controller/v_details_controller_bloc.dart';
import 'package:wheels_kart/module/Dealer/features/screens/my%20auction%20and%20ocb/data/models/v_my_auction_model.dart';
import 'package:wheels_kart/module/Dealer/features/screens/my%20auction%20and%20ocb/screens/v_mybid_screen.dart';

class AuctionTile extends StatefulWidget {
  final VMyAuctionModel auction;

  const AuctionTile({super.key, required this.auction});

  @override
  State<AuctionTile> createState() => _AuctionTileState();
}

class _AuctionTileState extends State<AuctionTile> {
  @override
  void initState() {
    _endTime = "00:00:00";
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      getMinutesToStop();
    });
    super.initState();
  }

  Timer? _timer;
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  late String _endTime;

  void getMinutesToStop() {
    if (widget.auction.bidTime != null) {
      final now = DateTime.now();
      final difference = widget.auction.bidTime!.difference(now);

      if (difference.isNegative) {
        _endTime = "00:00:00";
      } else {
        final hour = difference.inHours % 60;
        final min = difference.inMinutes % 60;
        final sec = difference.inSeconds % 60;

        // Format with leading zeros if needed
        final minStr = min.toString().padLeft(2, '0');
        final secStr = sec.toString().padLeft(2, '0');

        _endTime = "$hour:$minStr:$secStr";
      }

      setState(() {});
    } else {
      _endTime = "00:00:00";
    }
    
  }

  bool get isSoldToMe => widget.auction.bidStatus == "SOLD";
  bool get isMeHighBidder =>
      !isSoldToMe ? widget.auction.bidAmount == widget.auction.yourBid : false;

  bool get _timeOut => _endTime == "00:00:00";
  @override
  Widget build(BuildContext context) {
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
                  widget.auction.frontImage,
                  widget.auction.inspectionId,
                ),
              ),
              AppSpacer(widthPortion: .02),
              Flexible(
                child: VMybidScreen.buildHeader(
                  context,
                  widget.auction.manufacturingYear,
                  widget.auction.brandName,
                  widget.auction.modelName,
                  widget.auction.city,
                  widget.auction.evaluationId,
                ),
              ),
              AppSpacer(widthPortion: .02),
            ],
          ),
          AppSpacer(heightPortion: .01),
          // SOLD TO ME
          if (isSoldToMe) ...[_buildPurchaseAuctionView()],
          // STILL ACTIVE
          if (!isSoldToMe) ...[_buildLiveActiveAuctionView()],
          // Text(widget.auction.bidTime.date.toIso8601String())
        ],
      ),
    );
  }

  Widget _buildLiveActiveAuctionView() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          decoration: BoxDecoration(
            color:
                isMeHighBidder
                    ? VColors.SECONDARY.withAlpha(100)
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Current Bid",
                          style: VStyle.style(
                            context: context,
                            color: VColors.BLACK.withAlpha(200),
                          ),
                        ),
                        Text(
                          "₹${widget.auction.bidAmount}",
                          style: VStyle.style(
                            context: context,
                            size: 20,
                            color: VColors.BLACK,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 50,
                      child: VerticalDivider(
                        color: VColors.DARK_GREY.withAlpha(140),
                        thickness: .5,
                      ),
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Your Bid",
                          style: VStyle.style(
                            context: context,
                            size: 8,
                            color: VColors.ERROR.withAlpha(200),
                          ),
                        ),
                        Text(
                          "₹${widget.auction.yourBid}",
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
                    if (!_timeOut) {
                      VDetailsControllerBloc.openWhatsApp(
                        context: context,
                        currentBid: widget.auction.bidAmount ?? '',
                        evaluationId: widget.auction.evaluationId,
                        image: widget.auction.frontImage,
                        kmDrive: widget.auction.kmsDriven,
                        manufactureYear: widget.auction.manufacturingYear,
                        model: widget.auction.modelName,
                        noOfOwners: '',
                        regNumber: widget.auction.regNo,
                      );
                    }
                  },
                  child: Container(
                    width: 100,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: _timeOut ? const Color.fromARGB(255, 187, 187, 187) : VColors.PRIMARY,
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Increase Bid",
                          style: VStyle.style(
                            context: context,
                            color: VColors.WHITE,
                          ),
                        ),
                        _buildTimer(),
                      ],
                    ),
                  ),
                ),
              ],
              // its LIVE/ ACTIVE an YOUR THE HIGHSET BIDDER
              if (isMeHighBidder) ...[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                      "₹${widget.auction.yourBid}",
                      style: VStyle.style(
                        context: context,
                        size: 18,
                        color: VColors.WHITE,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      "Winning",
                      style: VStyle.style(
                        context: context,
                        color: VColors.GREENHARD,
                      ),
                    ),
                    _buildTimer(),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPurchaseAuctionView() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(color: VColors.GREENHARD),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.auction.bidStatus ?? "ACTIVE",
            style: VStyle.style(
              context: context,
              size: 16,
              fontWeight: FontWeight.w500,
              color: VColors.WHITE,
            ),
          ),
          Text(
            "Price : ₹${widget.auction.bidAmount}",
            style: VStyle.style(
              context: context,
              size: 16,
              fontWeight: FontWeight.w500,
              color: VColors.WHITE,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimer() {
    if (_timeOut) {
      return Text(
        "Closed",
        style: VStyle.style(context: context, color: VColors.SECONDARY),
      );
    }
    return Text(
      _endTime,
      style: VStyle.style(context: context, color: VColors.SECONDARY),
    );
  }
}
