import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:wheels_kart/common/components/app_spacer.dart';
import 'package:wheels_kart/common/dimensions.dart';
import 'package:wheels_kart/common/utils/responsive_helper.dart';
import 'package:wheels_kart/common/utils/routes.dart';
import 'package:wheels_kart/module/Dealer/core/blocs/v%20nav%20controller/v_nav_controller_cubit.dart';
import 'package:wheels_kart/module/Dealer/features/screens/favorates/data/controller/wishlist%20controller/v_wishlist_controller_cubit.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/controller/auctionu%20update%20controller/v_auction_update_controller_cubit.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/controller/ocb%20purchase%20controller/ocb_purchace_controlle_cubit.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/model/v_car_model.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/screens/car_details_screen.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_colors.dart';
import 'package:wheels_kart/module/Dealer/core/v_style.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/screens/OCB/place_ocbbotton_sheet.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_colors.dart';

class VWhishlistCard extends StatefulWidget {
  final VCarModel model;
  final String myId;
  final VoidCallback onPressFavoureButton;
  const VWhishlistCard({
    required this.myId,
    super.key,
    required this.model,
    required this.onPressFavoureButton,
  });

  @override
  State<VWhishlistCard> createState() => _VWhishlistCardState();
}

class _VWhishlistCardState extends State<VWhishlistCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;
  late String _endTime;

  @override
  void initState() {
    super.initState();
    _endTime = "00:00:00";

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
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
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  void getMinutesToStop() {
    if (widget.model.bidClosingTime != null) {
      final now = DateTime.now();
      final difference = widget.model.bidClosingTime!.difference(now);

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

  List<String> get _bidders => widget.model.vendorIds;

  bool get _isIamInThisBid =>
      _haveTheBidders
          ? _bidders.any((element) => element == widget.myId)
          : false;
  bool get _haveTheBidders => widget.model.vendorIds.isNotEmpty;

  bool get _isSold => widget.model.bidStatus == "Sold";
  bool get _isOpened =>
      (widget.model.bidStatus == "Open") && (_endTime != "00:00:00");
  bool get _isNotStarted => widget.model.bidStatus == "Not Started";

  bool get _isColsed => (_endTime == "00:00:00") || _isSold;
  bool get _isCancelled => widget.model.bidStatus == "Cancelled";

  bool get _soldToMe => widget.myId == widget.model.soldTo && _isSold;
  bool get _isHigestBidderIsMe =>
      _haveTheBidders ? widget.model.vendorIds.last == widget.myId : false;

  // bool get _enableViewButton => _soldToMe || _isOpened || _isNotStarted;
  bool get _enableViewButton => true;
  @override
  Widget build(BuildContext context) {
    // log("Have the bidders -> $_haveTheBidders");
    // log("last Id -> ${widget.model.vendorIds.last}");
    //    log("first Id -> ${widget.model.vendorIds.first}");
    // log("My Id : ${widget.myId}");

    // log(widget.model.vendorIds.map((e) => e.toString()).toList().toString());

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTap: () async {
              if (_enableViewButton) {
                final isLiked = await Navigator.of(context).push(
                  AppRoutes.createRoute(
                    VCarDetailsScreen(
                      paymentStatus: widget.model.paymentStatus,
                      auctionType: widget.model.auctionType,
                      hideBidPrice: widget.model.bidStatus != "Open",
                      frontImage: widget.model.frontImage,
                      inspectionId: widget.model.inspectionId,
                      isLiked: widget.model.wishlisted == 1 ? true : false,
                    ),
                  ),
                );
                if (isLiked == false) {
                  context.read<VWishlistControllerCubit>().onFetchWishList(
                    context,
                  );
                }
              }
            },
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: Stack(
                children: [
                  // Main card with gradient background
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.white, Colors.grey.shade50],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: VColors.GREENHARD.withOpacity(0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                          spreadRadius: 0,
                        ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: _buildCardContent(),
                    ),
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

                  if (_isColsed)
                    Positioned(
                      top: 15,
                      left: w(context) * 0.28 + 25,
                      child: _buildStatusBadge(widget.model.bidStatus ?? ''),
                    ),

                  // Favorite button with improved positioning
                  // Status indicator
                  _buildEnhancedFavoriteButton(widget.model.inspectionId),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCardContent() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main content row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Enhanced image container
              _buildEnhancedImageContainer(),
              const SizedBox(width: 10),
              // Content column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title with better typography
                    if (_isColsed) SizedBox(height: 15),
                    _buildCarTitle(),
                    const SizedBox(height: 10),
                    // Fuel and mileage chips
                    _buildDetailsChips(),
                    const SizedBox(height: 10),
                    // Location and price row
                    _buildLocationAndPriceRow(),
                  ],
                ),
              ),
            ],
          ),
          // const SizedBox(height: 20),
          // Action buttons row
          _buildActionButtons(),

          if ((_isHigestBidderIsMe && _isColsed) || (_isSold && _soldToMe)) ...[
            _buildMyAuctionMessage(),
          ],
        ],
      ),
    );
  }

  Widget _buildEnhancedImageContainer() {
    return Container(
      width: w(context) * 0.28,
      height: h(context) * 0.12,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            CachedNetworkImage(
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              imageUrl: widget.model.frontImage,
              errorListener: (value) {},
              placeholder:
                  (context, url) => Container(
                    color: Colors.grey.shade100,
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
              errorWidget:
                  (context, url, error) => Container(
                    color: Colors.grey.shade100,
                    child: Icon(
                      CupertinoIcons.car_detailed,
                      color: VColors.GREY,
                      size: 32,
                    ),
                  ),
            ),
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

  Widget _buildCarTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (!_isColsed) _buildStatusBadge(widget.model.bidStatus ?? ''),
            _buildAuctionStatus(),
          ],
        ),
        AppSpacer(heightPortion: .01),
        Text(
          '${widget.model.brandName}',
          style: VStyle.style(
            context: context,
            color: VColors.BLACK,
            fontWeight: FontWeight.w500,
            size: AppDimensions.fontSize13(context),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          '${widget.model.manufacturingYear} ${widget.model.modelName}',
          style: VStyle.style(
            context: context,
            color: VColors.GREENHARD,
            fontWeight: FontWeight.w700,
            size: AppDimensions.fontSize15(context),
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildDetailsChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildEnhancedDetailChip(
          Icons.local_gas_station_rounded,
          getFuelType(widget.model.fuelType),
          getFuelTypeColor(widget.model.fuelType),
        ),
        if (widget.model.noOfOwners.isNotEmpty) ...[
          _buildEnhancedDetailChip(
            CupertinoIcons.person_3,
            _getOwnerPrefix(widget.model.noOfOwners),
            VColors.ACCENT,
          ),
        ],
        _buildEnhancedDetailChip(
          Icons.speed_rounded,
          '${widget.model.kmsDriven}',
          VColors.SECONDARY,
        ),
      ],
    );
  }

  Widget _buildLocationAndPriceRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Location
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.location_on_rounded,
                    size: 14,
                    color: VColors.BLACK,
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      widget.model.city,
                      style: VStyle.style(
                        context: context,
                        size: 12,
                        color: VColors.BLACK,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Current bid
        if (_isSold || _isOpened)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Text(
                    widget.model.auctionType == "OCB"
                        ? "OCB Pirce"
                        : _isColsed || _isCancelled
                        ? "Closing Bid"
                        : "Current Bid",
                    style: VStyle.style(
                      context: context,
                      size: 10,
                      color: VColors.GREY,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  AppSpacer(widthPortion: .01),

                  Text(
                    _isCancelled
                        ? ""
                        : _isColsed
                        ? "(Closed)"
                        : "(${_endTime})",
                    style: VStyle.style(
                      color: _isColsed ? VColors.GREY : VColors.BLACK,
                      context: context,
                      fontWeight: FontWeight.w600,
                      size: 10,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                "₹${widget.model.currentBid}",
                style: VStyle.style(
                  context: context,
                  size: 14,
                  color: VColors.GREENHARD,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        if (_isOpened && !_isColsed) ...[
          Expanded(
            child: Padding(
              padding: EdgeInsetsGeometry.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [_buildBidButton()],
              ),
            ),
          ),

          // New bid button widget
        ],
      ],
    );
  }

  Widget _buildEnhancedDetailChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: VStyle.style(
              context: context,
              size: 11,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedFavoriteButton(String inspectionId) {
    return Positioned(
      right: 10,
      top: 10,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
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
            borderRadius: BorderRadius.circular(10),
            onTap: widget.onPressFavoureButton,
            // onTap: () {
            //   // Add haptic feedback
            //   HapticFeedback.lightImpact();
            //   context.read<VWishlistControllerCubit>().onChangeFavState(
            //     context,
            //     inspectionId,
            //     fetch: true,
            //   );
            // },
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  Icons.favorite_rounded,
                  color: VColors.ACCENT,
                  size: 18,
                ),
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

    switch (status) {
      case "Open":
        {
          if (!_isColsed) {
            title = "OPEN";
            color = VColors.SUCCESS;
            break;
          } else {
            title = "CLOSED";
            color = EvAppColors.DARK_SECONDARY;
            break;
          }
        }
      case "Sold":
        {
          title = "SOLD";
          color = VColors.ERROR;
          break;
        }
      case "Not Started":
        {
          title = "NOT STARTED";
          color = VColors.DARK_GREY;
          break;
        }
      case "Cancelled":
        {
          title = "CANCELLED";
          color = VColors.REDHARD;
          break;
        }
      default:
        {
          title = "";
          color = VColors.DARK_GREY;
          break;
        }
    }
    // You can customize this based on vehicle status
    return Container(
      // margin: EdgeInsets.only(left: 15, top: 15, bottom: 3),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(200),
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
  //               from: "WISHLIST",
  //               context: context,
  //               inspectionId: widget.model.inspectionId,
  //             );
  //           },
  //           child: Container(
  //             width: double.infinity,
  //             // height: 60,
  //             // margin: const EdgeInsets.symmetric(horizontal: 8),
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
  //         child: SizedBox(
  //           // margin: EdgeInsets.symmetric(horizontal: 5),
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
  //               if (widget.model.auctionType == "OCB") {
  //                 OcbPurchaceControlleCubit.showBuySheet(
  //                   context,
  //                   widget.model.currentBid ?? '',
  //                   widget.model.inspectionId,
  //                   "WISHLIST",
  //                 );
  //               } else {
  //                 VAuctionUpdateControllerCubit.showDiologueForBidWhatsapp(
  //                   from: "WISHLIST",
  //                   context: context,

  //                   inspectionId: widget.model.inspectionId,
  //                 );
  //               }
  //             },
  //             child: Text(
  //               widget.model.auctionType == "OCB" ? "Buy" : "Bid your price",
  //               style: VStyle.style(
  //                 context: context,
  //                 color: VColors.WHITE,
  //                 size: 15,
  //                 fontWeight: FontWeight.bold,
  //               ),
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
      margin: EdgeInsets.only(left: 5),

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

    return Flexible(
      flex: 2,
      child: InkWell(
        onTap: () {
          if (widget.model.auctionType == "OCB") {
            OcbPurchaceControlleCubit.showDiologueForOcbPurchase(
              paymentStatus: widget.model.paymentStatus,
              from: "WISHLIST",
              context: context,
              inspectionId: widget.model.inspectionId,
              currentBid: widget.model.currentBid ?? '',
            );
          } else {
            VAuctionUpdateControllerCubit.showDiologueForBidWhatsapp(
              paymentStatus: widget.model.paymentStatus,
              from: "WISHLIST",
              context: context,

              inspectionId: widget.model.inspectionId,
            );
          }
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
              if (widget.model.auctionType != "OCB") ...[
                Icon(buttonIcon, color: VColors.WHITE, size: 20),
                const SizedBox(width: 8),
              ],

              Text(
                widget.model.auctionType == "OCB" ? "Buy Now" : buttonText,
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
      ),
    );
  }

  String _getOwnerPrefix(String numberOfOwners) {
    if (numberOfOwners.isEmpty) return '';
    final numberOfOwner = int.parse(numberOfOwners);
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
