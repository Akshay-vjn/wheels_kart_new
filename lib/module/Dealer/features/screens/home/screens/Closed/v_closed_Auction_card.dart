import 'dart:async';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:wheels_kart/common/components/app_margin.dart';
import 'package:wheels_kart/common/components/app_spacer.dart';
import 'package:wheels_kart/common/dimensions.dart';
import 'package:wheels_kart/common/utils/responsive_helper.dart';
import 'package:wheels_kart/common/utils/routes.dart';
import 'package:wheels_kart/module/Dealer/core/blocs/v%20nav%20controller/v_nav_controller_cubit.dart';
import 'package:wheels_kart/module/Dealer/core/components/v_loading.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_colors.dart';
import 'package:wheels_kart/module/Dealer/features/screens/favorates/data/controller/wishlist%20controller/v_wishlist_controller_cubit.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/controller/auctionu%20update%20controller/v_auction_update_controller_cubit.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/controller/v%20details%20controller/v_details_controller_bloc.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/model/v_car_model.dart';
import 'package:wheels_kart/module/Dealer/core/v_style.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/screens/car_details_screen.dart';
import 'package:wheels_kart/module/Dealer/features/screens/my%20auction%20and%20ocb/screens/v_mybid_screen.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_colors.dart';

class VClosedAuctionCard extends StatefulWidget {
  final VCarModel vehicle;
  final String myId;

  const VClosedAuctionCard({
    required this.myId,
    super.key,
    required this.vehicle,
  });

  @override
  State<VClosedAuctionCard> createState() => _VAuctionVehicleCardState();
}

class _VAuctionVehicleCardState extends State<VClosedAuctionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;
  late bool _isLiked;
  @override
  void initState() {
    _endTime = "00:00:00";

    _isLiked = widget.vehicle.wishlisted == 1 ? true : false;
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      getMinutesToStop();
    });
  }

  Timer? _timer;
  @override
  void dispose() {
    _animationController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _animationController.reverse();
    // log(widget.vehicle.soldTo.toString());
    // if ((!_isColsed || _isNotStarted) && !_isCancelled) {
    onPressCard();
    // }
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  late String _endTime;

  void getMinutesToStop() {
    if (widget.vehicle.bidClosingTime != null) {
      final now = DateTime.now();
      final difference = widget.vehicle.bidClosingTime!.difference(now);

      if (difference.isNegative) {
        _endTime = "00:00:00";
      } else {
        // Fixed: Remove % 60 from hours to show correct total hours
        final hour = difference.inHours;
        final min = difference.inMinutes % 60;
        final sec = difference.inSeconds % 60;

        // Format with leading zeros if needed
        final hourStr = hour.toString().padLeft(2, '0');
        final minStr = min.toString().padLeft(2, '0');
        final secStr = sec.toString().padLeft(2, '0');

        _endTime = "$hourStr:$minStr:$secStr";
      }

      setState(() {});
    } else {
      _endTime = "00:00:00";
    }
  }

  void onPressCard() async {
    _isLiked = await Navigator.of(context).push(
      AppRoutes.createRoute(
        VCarDetailsScreen(
          paymentStatus: widget.vehicle.paymentStatus,
          auctionType: "AUCTION",
          hideBidPrice: widget.vehicle.bidStatus != "Open",
          frontImage: widget.vehicle.frontImage,
          inspectionId: widget.vehicle.inspectionId,
          isLiked: widget.vehicle.wishlisted == 1 ? true : false,
        ),
      ),
    );
  }

  void onPressLikeButton() async {
    await context.read<VWishlistControllerCubit>().onChangeFavState(
      context,
      widget.vehicle.inspectionId,
    );
    if (_isLiked) {
      _isLiked = false;
    } else {
      _isLiked = true;
    }
    setState(() {});
  }

  // ---- vendors check
  bool get _haveTheBidders => widget.vehicle.vendorIds.isNotEmpty;
  List<String> get _bidders => widget.vehicle.vendorIds;
  List<String> get _getOtherBidders =>
      _haveTheBidders
          ? widget.vehicle.vendorIds.sublist(
            0,
            widget.vehicle.vendorIds.length - 1,
          )
          : [];

  bool get _isIamInThisBid =>
      _haveTheBidders
          ? _bidders.any((element) => element == widget.myId)
          : false;
  bool get _isHigestBidderIsMe =>
      _haveTheBidders ? widget.vehicle.vendorIds.last == widget.myId : false;

  bool get isIamLoosingThisBid =>
      _getOtherBidders.any((element) => widget.myId == element);

  // status Check------
  bool get _isSold => widget.vehicle.bidStatus == "Sold";
  bool get _isCancelled => widget.vehicle.bidStatus == "Cancelled";
  bool get _isOpened =>
      (widget.vehicle.bidStatus == "Open") && (_endTime != "00:00:00");
  bool get _isNotStarted => widget.vehicle.bidStatus == "Not Started";

  bool get _isColsed => (_endTime == "00:00:00") || _isSold;

  bool get _soldToMe => widget.myId == widget.vehicle.soldTo;

  @override
  Widget build(BuildContext context) {
    // log("Have the bidders -> $_haveTheBidders");
    // log("last Id -> ${widget.vehicle.vendorIds.last}");
    // log("My Id : ${widget.myId}");
    return AppMargin(
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                margin: const EdgeInsets.only(bottom: 20),

                decoration: BoxDecoration(
                  color: VColors.WHITE,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: VColors.REDHARD.withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                      spreadRadius: 0,
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Flexible(child: _buildImageSection()),
                            AppSpacer(widthPortion: .02),
                            Flexible(child: _buildHeader()),
                            AppSpacer(widthPortion: .02),
                          ],
                        ),

                        Padding(
                          padding: EdgeInsetsGeometry.all(10),
                          child: Column(
                            children: [
                              _buildDetailsGrid(),

                              if (_isOpened || _isSold) ...[
                                AppSpacer(heightPortion: .01),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildTimerViewChip(),
                                    _buildBidPriceChip(),
                                  ],
                                ),
                                AppSpacer(heightPortion: .01),
                              ],

                              if (_isOpened && !_isColsed) ...[
                                _buildBidButton(),
                              ],

                              // _buildOpenBidSection(),
                              if (_isSold) ...[
                                DottedBorder(
                                  options: RoundedRectDottedBorderOptions(
                                    color:
                                        _soldToMe
                                            ? VColors.SUCCESS
                                            : VColors.GREY,
                                    radius: Radius.circular(10),
                                  ),
                                  child: Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.all(5),
                                    width: double.infinity,
                                    color: Colors.white,
                                    child: Text(
                                      _soldToMe
                                          ? "You won this auction"
                                          : "Auction closed – Item sold",
                                      style: VStyle.style(
                                        color:
                                            _soldToMe ? VColors.SUCCESS : null,
                                        context: context,
                                        fontWeight: FontWeight.bold,
                                        size: 15,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                              if ((_isHigestBidderIsMe && _isColsed) ||
                                  (_isSold && _soldToMe)) ...[
                                _buildMyAuctionMessage(),
                              ],
                              // bidSoldSecion(),
                            ],
                          ),
                        ),
                      ],
                    ),

                    if (_isColsed)
                      Positioned(
                        left: 0,
                        right: 0,
                        top: 0,
                        bottom: 0,
                        child: Material(
                          color: VColors.WHITE.withAlpha(120),
                          borderRadius: BorderRadius.circular(15),

                          child: SizedBox(height: 200, width: 200),
                        ),
                      ),

                    // Enhanced Favorite Button
                    Positioned(
                      right: 10,
                      top: 10,
                      child: _buildFavoriteButton(),
                    ),

                    // Status Badge (if needed)
                    // Positioned(
                    //   left: 12,
                    //   top: 12,
                    //   child: Row(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     mainAxisSize: MainAxisSize.min,
                    //     children: [
                    //       _buildStatusBadge(widget.vehicle.bidStatus ?? ""),
                    //       AppSpacer(widthPortion: .02),
                    //       _buildAuctionStatus(),
                    //     ],
                    //   ),
                    // ),
                    if (_isColsed)
                      Positioned(
                        top: 10,
                        left: w(context) / 2 - 15,
                        child: _buildStatusBadge(
                          widget.vehicle.bidStatus ?? "",
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(15),
        bottomRight: Radius.circular(15),
      ),
      child: Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [VColors.LIGHT_GREY.withOpacity(0.3), VColors.LIGHT_GREY],
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            widget.vehicle.frontImage.isNotEmpty
                ? Hero(
                  tag: widget.vehicle.evaluationId,
                  child: CachedNetworkImage(
                    imageUrl: widget.vehicle.frontImage,
                    fit: BoxFit.cover,
                    placeholder:
                        (context, url) => Container(
                          color: VColors.LIGHT_GREY,
                          child: const Center(child: VLoadingIndicator()),
                        ),
                    errorWidget:
                        (context, url, error) => _buildPlaceholderIcon(),
                  ),
                )
                : _buildPlaceholderIcon(),

            // Gradient overlay for better text visibility
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.1)],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSpacer(heightPortion: .01),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!_isColsed) _buildStatusBadge(widget.vehicle.bidStatus ?? ""),
            AppSpacer(widthPortion: .02),
            _buildAuctionStatus(),
          ],
        ),
        AppSpacer(heightPortion: .01),
        Text(
          widget.vehicle.manufacturingYear + " " + widget.vehicle.brandName,
          style: VStyle.poppins(
            context: context,
            color: VColors.BLACK,
            size: 14,
          ),
        ),
        Text(
          widget.vehicle.modelName,
          style: VStyle.poppins(
            context: context,
            color: VColors.BLACK,
            size: 17,
          ),
        ),

        // Text(
        //   widget.vehicle.manufacturingYear,
        //   style: VStyle.style(context: context, color: VColors.BLACK, size: 14),
        // ),
        AppSpacer(heightPortion: .01),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.location_on_rounded,
                    color: VColors.DARK_GREY,
                    size: 15,
                  ),
                  SizedBox(width: 1),
                  Flexible(
                    child: Text(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      widget.vehicle.city,
                      style: VStyle.poppins(
                        context: context,
                        color: VColors.DARK_GREY,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: Text(
                "ID: ${widget.vehicle.evaluationId}",
                style: VStyle.poppins(
                  context: context,
                  color: VColors.DARK_GREY,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPlaceholderIcon() {
    return Container(
      color: VColors.LIGHT_GREY,
      child: const Center(
        child: Icon(
          Icons.directions_car_rounded,
          size: 60,
          color: VColors.DARK_GREY,
        ),
      ),
    );
  }

  Widget _buildDetailsGrid() {
    return Row(
      children: [
        Flexible(
          child: _buildEnhancedDetailChip(
            Icons.local_gas_station_rounded,
            getFuelType(widget.vehicle.fuelType),
            getFuelTypeColor(widget.vehicle.fuelType),
          ),
        ),
        AppSpacer(widthPortion: .01),
        Flexible(
          child: _buildEnhancedDetailChip(
            Icons.speed_rounded,
            '${widget.vehicle.kmsDriven}',
            VColors.SECONDARY,
          ),
        ),
        AppSpacer(widthPortion: .01),
        if (widget.vehicle.noOfOwners.isNotEmpty) ...[
          Flexible(
            child: _buildEnhancedDetailChip(
              CupertinoIcons.person_3,
              _getOwnerPrefix(widget.vehicle.noOfOwners),
              VColors.ACCENT,
            ),
          ),
          AppSpacer(widthPortion: .01),
        ],

        widget.vehicle.regNo.isNotEmpty
            ? Flexible(
                child: _buildEnhancedDetailChip(
                  Icons.confirmation_number_rounded,
                  widget.vehicle.regNo.replaceRange(
                    6,
                    widget.vehicle.regNo.length,
                    // '●●●●●●',
                    "",
                  ),
                  const Color.fromARGB(255, 32, 138, 164),
                  isFullWidth: false,
                ),
              )
            : SizedBox.shrink(),
      ],
    );
  }

  Widget _buildTimerViewChip() {
    return Flexible(
      child: Row(
        children: [
          if (!_isCancelled)
            Icon(
              Icons.timelapse_sharp,
              color: _isColsed ? VColors.GREY : VColors.BLACK,
              size: 16,
            ),
          AppSpacer(widthPortion: .01),
          Text(
            _isColsed
                ? "Closed"
                : _isCancelled
                ? ""
                : _endTime,
            style: VStyle.style(
              color: _isColsed ? VColors.GREY : VColors.BLACK,
              context: context,
              fontWeight: FontWeight.w600,
              size: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBidPriceChip() {
    return Flexible(
      flex: 2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            _isColsed || _isCancelled ? "Closing bid" : "Current bid",
            style: VStyle.style(
              color: _isColsed ? VColors.GREY : VColors.BLACK,
              context: context,
              fontWeight: FontWeight.bold,
              size: 14,
            ),
          ),
          Text(
            " ₹${widget.vehicle.currentBid}",
            style: VStyle.style(
              color: _isColsed ? VColors.GREY : VColors.BLACK,

              context: context,

              fontWeight: FontWeight.bold,
              size: 17,
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildHighAndLowBid() {
  //   Color color;
  //   String titleText;
  //   String subtitleText;

  //   if (_isHigestBidderIsMe) {
  //     color = VColors.SUCCESS;
  //     titleText = "WINNING";
  //     subtitleText = "";
  //   } else {
  //     color = VColors.ERROR;
  //     titleText = "LOSING";
  //     subtitleText = "Increase Bid";
  //   }

  //   return !_isIamInThisBid
  //       ? SizedBox.shrink()
  //       : Flexible(
  //         child: InkWell(
  //           borderRadius: BorderRadius.circular(12),
  //           onTap: () {
  //             VAuctionUpdateControllerCubit.showDiologueForBidWhatsapp(
  //               from: "AUCTION",
  //               context: context,
  //               inspectionId: widget.vehicle.inspectionId,
  //             );
  //           },
  //           child: Container(
  //             width: double.infinity,
  //             // height: 60,
  //             margin: const EdgeInsets.symmetric(horizontal: 8),
  //             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  //             decoration: BoxDecoration(
  //               color: color,
  //               border: Border.all(color: color.withOpacity(0.6), width: 0.6),
  //               borderRadius: BorderRadius.circular(12),
  //               boxShadow: [
  //                 BoxShadow(
  //                   color: color.withAlpha(21),
  //                   blurRadius: 6,
  //                   offset: Offset(0, 2),
  //                 ),
  //               ],
  //             ),
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Column(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Text(
  //                       titleText,
  //                       style: VStyle.style(
  //                         context: context,
  //                         color: VColors.WHITE,
  //                         fontWeight: FontWeight.w900,
  //                         size: 18,
  //                       ),
  //                     ),
  //                     if (subtitleText.isNotEmpty) ...[
  //                       const SizedBox(height: 2),
  //                       Text(
  //                         subtitleText,
  //                         style: VStyle.style(
  //                           context: context,
  //                           color: VColors.WHITE,
  //                           fontWeight: FontWeight.w400,
  //                           size: 12,
  //                         ),
  //                       ),
  //                     ],
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       );
  // }

  // Widget _buildWhatsAppButton() {
  //   return _isIamInThisBid
  //       ? SizedBox.shrink()
  //       : Flexible(
  //         child: Container(
  //           margin: EdgeInsets.symmetric(horizontal: 5),
  //           height: 50,
  //           width: double.infinity,
  //           child: ElevatedButton(
  //             style: ElevatedButton.styleFrom(
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadiusGeometry.circular(10),
  //               ),
  //               backgroundColor: VColors.SECONDARY,
  //             ),
  //             onPressed: () {
  //               VAuctionUpdateControllerCubit.showDiologueForBidWhatsapp(
  //                 from: "AUCTION",
  //                 context: context,

  //                 inspectionId: widget.vehicle.inspectionId,
  //               );
  //             },
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Text(
  //                   "Bid your price",
  //                   style: VStyle.style(
  //                     context: context,
  //                     color: VColors.WHITE,
  //                     size: 15,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //                 AppSpacer(widthPortion: .03),
  //                 Icon(SolarIconsBold.chatRound, color: VColors.WHITE),
  //               ],
  //             ),
  //           ),
  //         ),
  //       );
  // }

  Widget _buildAuctionStatus() {
    if (!_isIamInThisBid || _isColsed) return SizedBox.shrink();

    Color statusColor;
    String statusText;
    IconData statusIcon;

    if (_isHigestBidderIsMe) {
      statusColor = VColors.SUCCESS;
      statusText = "WINNING";
      statusIcon = Icons.trending_up;
    } else {
      statusColor = VColors.ERROR;
      statusText = "LOSING";
      statusIcon = Icons.trending_down;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        border: Border.all(color: statusColor.withOpacity(0.3), width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(width: 6),
          Text(
            statusText,
            style: VStyle.poppins(
              context: context,
              color: statusColor,
              fontWeight: FontWeight.w500,
              size: 10,
            ),
          ),
          const SizedBox(width: 6),
          Icon(statusIcon, color: statusColor, size: 10),
          const SizedBox(width: 6),
        ],
      ),
    );
  }

  Widget _buildBidButton() {
    // Don't show bid button if user is winning
    // if (_isIamInThisBid && _isHigestBidderIsMe) return SizedBox.shrink();

    // Don't show if user is not in bid and WhatsApp button is already shown
    // if (!_isIamInThisBid) return SizedBox.shrink();

    String buttonText;
    Color buttonColor;
    IconData buttonIcon;

    if (!_isIamInThisBid) {
      // New auction state
      buttonText = "Place Your Bid";
      buttonColor = VColors.PRIMARY;
      buttonIcon = Icons.gavel_outlined;
    } else {
      // Losing state - user is in bid but not winning
      buttonText = "Increase Your Bid";
      buttonColor = VColors.WARNING; // or VColors.PRIMARY
      buttonIcon = Icons.arrow_upward;
    }

    return InkWell(
      onTap: () {
        VAuctionUpdateControllerCubit.showDiologueForBidWhatsapp(
          paymentStatus: widget.vehicle.paymentStatus,
          from: "AUCTION",
          context: context,
          inspectionId: widget.vehicle.inspectionId,
        );
      },
      child: Container(
        // width: double.infinity,
        height: 50,
        margin: const EdgeInsets.symmetric(horizontal: 8),

        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [buttonColor.withAlpha(150), buttonColor],
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: buttonColor.withAlpha(60),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(buttonIcon, color: VColors.WHITE, size: 20),
            const SizedBox(width: 8),
            Text(
              buttonText,
              style: VStyle.style(
                context: context,
                color: VColors.WHITE,
                size: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedDetailChip(
    IconData icon,
    String text,
    Color color, {
    bool isFullWidth = false,
  }) {
    return Container(
      width: isFullWidth ? double.infinity : null,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(AppDimensions.radiusSize5),
        border: Border.all(color: color.withAlpha(50), width: 1),
      ),
      child: Row(
        mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: color.withAlpha(50),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, size: 8, color: color),
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              text,
              style: VStyle.poppins(
                context: context,
                size: 10,
                color: color,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // ---->>>>> STACK ITEMS <<<<----

  Widget _buildFavoriteButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onPressLikeButton,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Icon(
                _isLiked
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                key: ValueKey(_isLiked),
                color: _isLiked ? VColors.ACCENT : VColors.DARK_GREY,
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    String title;

    // For closed auction tab, prioritize showing CLOSED, SOLD, or CANCELLED
    if (status == "Cancelled") {
      title = "CANCELLED";
      color = VColors.REDHARD;
    } else if (status == "Sold" || _isSold) {
      title = "SOLD";
      color = VColors.ERROR;
    } else {
      // Default to CLOSED for items in closed auction tab
      title = "CLOSED";
      color = EvAppColors.DARK_SECONDARY;
    }
    // You can customize this based on vehicle status
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(180),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: color.withAlpha(40),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.circle, size: 6, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            title,
            style: VStyle.style(
              context: context,
              size: 10,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // --------->>
  Color getFuelTypeColor(String fuelType) {
    switch (fuelType.toLowerCase().trim()) {
      case "electric":
        return VColors.SUCCESS;
      case 'diesel':
        return VColors.ACCENT;
      case 'petrol':
        return const Color(0xFF4220D8);
      case 'petrol+cng':
        return const Color(0xFFB02525);
      case 'petrol+lpg':
        return VColors.WARNING;
      case 'hybrid':
        return const Color(0xFF155D79);
      case 'cng':
        return const Color(0xFF07FFC5);
      default:
        return VColors.DARK_GREY;
    }
  }

  String getFuelType(String fuelType) {
    switch (fuelType.toLowerCase().trim()) {
      case "electric":
        return 'Electric';
      case 'diesel':
        return "Diesel";
      case 'petrol':
        return "Petrol";
      case 'petrol+cng':
        return "Petrol + CNG";
      case 'petrol+lpg':
        return "Petrol + LPG";
      case 'hybrid':
        return "Hybrid";
      case 'cng':
        return "CNG";
      default:
        return fuelType.isNotEmpty ? fuelType.toUpperCase() : 'Not Specified';
    }
  }

  Widget _buildMyAuctionMessage() {
    return Column(
      children: [
        AppSpacer(heightPortion: .01),

        InkWell(
          onTap: () {
            context.read<VNavControllerCubit>().onChangeNav(2);
          },
          child: RichText(
            text: TextSpan(
              text:
                  "Auction closed. You are the highest bidder. Our team will be in touch shortly.",
              style: VStyle.style(context: context, color: VColors.DARK_GREY),
              children: [
                TextSpan(
                  text: " See History",
                  style: VStyle.style(
                    context: context,
                    color: EvAppColors.DARK_SECONDARY,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _getOwnerPrefix(String numberOfOwners) {
    // Handle empty or invalid strings
    if (numberOfOwners.isEmpty || numberOfOwners == 'N/A' || numberOfOwners == 'null') {
      return '';
    }
    
    // Try to parse, return empty if not a valid number
    final numberOfOwner = int.tryParse(numberOfOwners);
    if (numberOfOwner == null) {
      return '';
    }
    
    if (numberOfOwner == 1) {
      return "$numberOfOwners st owner";
    }
    if (numberOfOwner == 2) {
      return "$numberOfOwners nd owner";
    }
    if (numberOfOwner == 3) {
      return "$numberOfOwners rd owner";
    }
    return "$numberOfOwners th owner";
  }
}
