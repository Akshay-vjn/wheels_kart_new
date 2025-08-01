import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wheels_kart/common/components/app_spacer.dart';
import 'package:wheels_kart/common/utils/intl_helper.dart';
import 'package:wheels_kart/common/utils/routes.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_colors.dart';
import 'package:wheels_kart/module/Dealer/core/v_style.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/controller/v%20details%20controller/v_details_controller_bloc.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/screens/car_details_screen.dart';
import 'package:wheels_kart/module/Dealer/features/screens/my%20auction%20and%20ocb/data/models/v_my_auction_model.dart';
import 'package:wheels_kart/module/Dealer/features/screens/my%20auction%20and%20ocb/screens/v_mybid_screen.dart';

class AuctionTile extends StatefulWidget {
  final VMyAuctionModel auction;
  final int index;

  const AuctionTile({super.key, required this.auction, required this.index});

  @override
  State<AuctionTile> createState() => _AuctionTileState();
}

class _AuctionTileState extends State<AuctionTile>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _slideController;
  late Animation<double> _pulseAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _endTime = "00:00:00";

    // Initialize animation controllers
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    // Start animations
    _slideController.forward();
    if (!_timeOut && !isSoldToMe) {
      _pulseController.repeat(reverse: true);
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      getMinutesToStop();
    });
  }

  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  late String _endTime;

  void getMinutesToStop() {
    DateTime? bidTime = widget.auction.bidClosingTime;
    // final state = context.read<VMyAuctionControllerBloc>().state;
    // if (state is VMyAuctionControllerSuccessState) {
    //   log("message");
    //   bidTime = state.listOfMyAuctions[widget.index].bidClosingTime;
    // }
    if (bidTime != null) {
      if (widget.auction.evaluationId == "WK20023") {
        log("----------->$bidTime<-------------");
      }

      final now = DateTime.now();
      final difference = bidTime.difference(now);

      if (difference.isNegative) {
        _endTime = "00:00:00";
        _pulseController.stop();
      } else {
        final hour = difference.inHours % 60;
        final min = difference.inMinutes % 60;
        final sec = difference.inSeconds % 60;

        final hourStr = hour.toString().padLeft(2, '0');
        final minStr = min.toString().padLeft(2, '0');
        final secStr = sec.toString().padLeft(2, '0');

        _endTime = "$hourStr:$minStr:$secStr";

        // Start pulsing if time is running out (less than 5 minutes)
        if (difference.inMinutes < 5 &&
            !isSoldToMe &&
            !_pulseController.isAnimating) {
          _pulseController.repeat(reverse: true);
        }
      }

      if (mounted) setState(() {});
    } else {
      _endTime = "00:00:00";
    }
  }

  bool get isSoldToMe => widget.auction.bidStatus == "Sold";
  bool get isMeHighBidder =>
      !isSoldToMe
          ? widget.auction.bidAmount ==
              widget.auction.yourBids.first.amount.toString()
          : false;
  bool get _timeOut => _endTime == "00:00:00";
  bool get _urgentTime =>
      _endTime != "00:00:00" &&
      widget.auction.bidClosingTime != null &&
      widget.auction.bidClosingTime!.difference(DateTime.now()).inMinutes < 5;

  Color get _borderColor {
    if (isSoldToMe) return VColors.GREENHARD;
    if (isMeHighBidder) return VColors.SECONDARY;
    if (_urgentTime) return Colors.orange;
    return VColors.ERROR;
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _urgentTime && !_timeOut ? _pulseAnimation.value : 1.0,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                child: Material(
                  elevation: isSoldToMe ? 8 : 4,
                  shadowColor: _borderColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16),
                  child: InkWell(
                    onTap: _onTileTap,
                    borderRadius: BorderRadius.circular(16),
                    splashColor: _borderColor.withOpacity(0.1),
                    highlightColor: _borderColor.withOpacity(0.05),
                    child: Container(
                      decoration: BoxDecoration(
                        color: VColors.WHITE,
                        border: Border.all(width: .5, color: _borderColor),
                        borderRadius: BorderRadius.circular(16),
                        gradient:
                            isSoldToMe
                                ? LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    VColors.WHITE,
                                    VColors.GREENHARD.withOpacity(0.05),
                                  ],
                                )
                                : null,
                      ),
                      child: Column(
                        children: [_buildMainContent(), _buildStatusSection()],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _onTileTap() {
    // Add haptic feedback
    HapticFeedback.lightImpact();

    Navigator.of(context).push(
      AppRoutes.createRoute(
        VCarDetailsScreen(
          isLiked: false,
          auctionType: "AUCTION",
          frontImage: widget.auction.frontImage,
          hideBidPrice: true,
          inspectionId: widget.auction.inspectionId,
          isShowingInHistoryScreen: true,
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // Image section with enhanced styling
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: VMybidScreen.buildImageSection(
                  widget.auction.frontImage,
                  widget.auction.evaluationId,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Details section
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                VMybidScreen.buildHeader(
                  context,
                  widget.auction.manufacturingYear,
                  widget.auction.brandName,
                  widget.auction.modelName,
                  widget.auction.city,
                  widget.auction.evaluationId,
                ),
                if (!isSoldToMe && !_timeOut) ...[
                  const SizedBox(height: 8),
                  _buildQuickStats(),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: VColors.PRIMARY.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timer_outlined,
            size: 14,
            color: _urgentTime ? Colors.orange : VColors.PRIMARY,
          ),
          const SizedBox(width: 4),
          Text(
            _timeOut ? "Closed" : _endTime,
            style: VStyle.style(
              context: context,
              size: 12,
              color: _urgentTime ? Colors.orange : VColors.PRIMARY,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusSection() {
    if (isSoldToMe) {
      return _buildPurchaseAuctionView();
    } else {
      return _buildLiveActiveAuctionView();
    }
  }

  Widget _buildLiveActiveAuctionView() {
    return Container(
      decoration: BoxDecoration(
        color:
            isMeHighBidder
                ? VColors.SECONDARY.withOpacity(0.15)
                : VColors.ACCENT.withOpacity(0.15),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: _buildBidInfo()),
                const SizedBox(width: 12),
                _buildActionButton(),
              ],
            ),

            _showAllBids(),
            if (isMeHighBidder && _timeOut) ...[
              AppSpacer(heightPortion: .01),
              Text(
                "Auction closed. You are the highest bidder. Our team will be in touch shortly.",
                style: VStyle.style(context: context, color: VColors.DARK_GREY),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBidInfo() {
    if (isMeHighBidder) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(Icons.emoji_events, color: VColors.SECONDARY, size: 16),
              const SizedBox(width: 4),
              Text(
                "You're winning!",
                style: VStyle.style(
                  context: context,
                  size: 12,
                  color: VColors.SECONDARY,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            "₹${widget.auction.yourBids.first.amount}",
            style: VStyle.style(
              context: context,
              size: 18,
              color: VColors.SECONDARY,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Current Bid",
                style: VStyle.style(
                  context: context,
                  size: 11,
                  color: VColors.BLACK.withOpacity(0.7),
                ),
              ),
              Text(
                "₹${widget.auction.bidAmount}",
                style: VStyle.style(
                  context: context,
                  size: 16,
                  color: VColors.BLACK,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Container(
            height: 40,
            width: 1,
            color: VColors.DARK_GREY.withOpacity(0.3),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Your Bid",
                style: VStyle.style(
                  context: context,
                  size: 11,
                  color: VColors.ERROR.withOpacity(0.8),
                ),
              ),
              Text(
                "₹${widget.auction.yourBids.first.amount}",
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
      );
    }
  }

  Widget _buildActionButton() {
    if (isMeHighBidder) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: VColors.SECONDARY,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: VColors.SECONDARY.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.timer, color: VColors.WHITE, size: 16),
            const SizedBox(height: 2),
            _buildTimer(),
          ],
        ),
      );
    } else {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _timeOut ? null : _onIncreaseBidTap,
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: _timeOut ? Colors.grey.withOpacity(0.5) : VColors.PRIMARY,
              boxShadow:
                  _timeOut
                      ? null
                      : [
                        BoxShadow(
                          color: VColors.PRIMARY.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _timeOut ? Icons.timer_off : Icons.gavel,
                  color: VColors.WHITE,
                  size: 16,
                ),
                const SizedBox(height: 4),
                Text(
                  _timeOut ? "Closed" : "Bid Now",
                  style: VStyle.style(
                    context: context,
                    size: 12,
                    color: VColors.WHITE,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (!_timeOut) _buildTimer(),
              ],
            ),
          ),
        ),
      );
    }
  }

  void _onIncreaseBidTap() {
    HapticFeedback.mediumImpact();
    VDetailsControllerBloc.showDiologueForBidWhatsapp(
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

  Widget _buildPurchaseAuctionView() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [VColors.GREENHARD, VColors.GREENHARD.withOpacity(0.8)],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: VColors.GREENHARD.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.check_circle, color: VColors.WHITE, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      widget.auction.bidStatus ?? "SOLD",
                      style: VStyle.style(
                        context: context,
                        size: 16,
                        fontWeight: FontWeight.w600,
                        color: VColors.WHITE,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: VColors.WHITE.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "₹${widget.auction.bidAmount}",
                    style: VStyle.style(
                      context: context,
                      size: 16,
                      fontWeight: FontWeight.bold,
                      color: VColors.WHITE,
                    ),
                  ),
                ),
              ],
            ),
            _showAllBids(),
          ],
        ),
      ),
    );
  }

  Widget _buildTimer() {
    if (_timeOut) {
      return Text(
        "Closed",
        style: VStyle.style(
          context: context,
          size: 10,
          color: VColors.WHITE.withOpacity(0.8),
        ),
      );
    }
    return Text(
      _endTime,
      style: VStyle.style(
        context: context,
        size: 10,
        color: VColors.WHITE,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _showAllBids() {
    return Padding(
      padding: EdgeInsetsGeometry.only(top: 10),
      child: ExpansionTile(
        collapsedShape: ContinuousRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(20),
        ),
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(20),
        ),
        backgroundColor: VColors.WHITE,
        collapsedIconColor: VColors.BLACK,
        iconColor: VColors.BLACK,
        collapsedBackgroundColor: VColors.WHITE,

        childrenPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        title: Text(
          "See Your Bids",
          style: VStyle.style(
            context: context,
            color: VColors.BLACK,
            fontWeight: FontWeight.bold,
          ),
        ),
        children:
            widget.auction.yourBids
                .map(
                  (e) => Container(
                    margin: EdgeInsets.only(bottom: 5),
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: VColors.LIGHT_GREY,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "₹${e.amount.toString()}",
                          style: VStyle.style(
                            context: context,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              IntlHelper.formteDate(e.time),
                              style: VStyle.style(
                                context: context,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              IntlHelper.formteTime(e.time),
                              style: VStyle.style(
                                context: context,
                                color: VColors.DARK_GREY,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
      ),
    );
  }
}
