import 'dart:async';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:wheels_kart/common/components/app_margin.dart';
import 'package:wheels_kart/common/components/app_spacer.dart';
import 'package:wheels_kart/common/controllers/auth%20cubit/auth_cubit.dart';
import 'package:wheels_kart/common/dimensions.dart';
import 'package:wheels_kart/common/utils/routes.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_colors.dart';
import 'package:wheels_kart/module/Dealer/features/screens/favorates/data/controller/wishlist%20controller/v_wishlist_controller_cubit.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/controller/v%20details%20controller/v_details_controller_bloc.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/model/v_car_model.dart';
import 'package:wheels_kart/module/Dealer/core/v_style.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/screens/car_details_screen.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_colors.dart';

class VAuctionVehicleCard extends StatefulWidget {
  final VCarModel vehicle;
  final String myId;
  // final bool isFavorite;
  // final VoidCallback onFavoriteToggle;
  // final VoidCallback onPressCard;

  const VAuctionVehicleCard({
    required this.myId,
    super.key,
    required this.vehicle,
    // required this.isFavorite,
    // required this.onFavoriteToggle,
    // required this.onPressCard,
  });

  @override
  State<VAuctionVehicleCard> createState() => _VAuctionVehicleCardState();
}

class _VAuctionVehicleCardState extends State<VAuctionVehicleCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;
  late bool _isLiked;
  @override
  void initState() {
    _endTime = "00:00:00";
    _isLiked = widget.vehicle.wishlisted == 1 ? true : false;
    log(widget.vehicle.wishlisted.toString());
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
    if (!_isColsed || widget.vehicle.bidStatus == "Not Started") {
      // widget.onPressCard();
      onPressCard();
    }
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

  void onPressCard() async {
    _isLiked = await Navigator.of(context).push(
      AppRoutes.createRoute(
        VCarDetailsScreen(
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
  bool get _isOpened => widget.vehicle.bidStatus == "Open";

  bool get _isColsed => (_endTime == "00:00:00") || _isSold;

  bool get _soldToMe => widget.myId == widget.vehicle.soldTo;

  @override
  Widget build(BuildContext context) {
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
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        _buildHighAndLowBid(),
                                        _buildWhatsAppButton(),
                                      ],
                                    ),
                                  ],
                                ),
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
                              // bidSoldSecion(),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // Enhanced Favorite Button
                    Positioned(
                      right: 10,
                      top: 10,
                      child: _buildFavoriteButton(),
                    ),

                    // Status Badge (if needed)
                    Positioned(
                      left: 12,
                      top: 12,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildStatusBadge(widget.vehicle.bidStatus ?? ""),
                        ],
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
        height: 100,
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
                          child: const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(
                                VColors.ACCENT,
                              ),
                            ),
                          ),
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
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${widget.vehicle.manufacturingYear} ${widget.vehicle.brandName}",
          style: VStyle.style(context: context, color: VColors.BLACK, size: 17),
        ),
        Text(
          widget.vehicle.modelName,
          style: VStyle.style(context: context, color: VColors.BLACK, size: 14),
        ),
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
                      style: VStyle.style(
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
                style: VStyle.style(context: context, color: VColors.DARK_GREY),
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
        _buildEnhancedDetailChip(
          Icons.local_gas_station_rounded,
          getFuelType(widget.vehicle.fuelType),
          getFuelTypeColor(widget.vehicle.fuelType),
        ),
        AppSpacer(widthPortion: .01),
        _buildEnhancedDetailChip(
          Icons.speed_rounded,
          '${widget.vehicle.kmsDriven} km',
          VColors.SECONDARY,
        ),
        AppSpacer(widthPortion: .01),
        _buildEnhancedDetailChip(
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
      ],
    );
  }

  Widget _buildTimerViewChip() {
    return Flexible(
      child: Row(
        children: [
          Icon(
            Icons.timelapse_sharp,
            color: _isColsed ? VColors.GREY : VColors.BLACK,
            size: 16,
          ),
          AppSpacer(widthPortion: .01),
          Text(
            _isColsed ? "Closed" : _endTime,
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
            _isColsed ? "Closing bid" : "Current bid",
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

  Widget _buildHighAndLowBid() {
    Color color;
    Icon icon;
    String text;
    if (_isHigestBidderIsMe) {
      color = VColors.SUCCESS;
      text = "Your bid is leading";
      icon = Icon(Icons.trending_up, color: color);
    } else {
      color = VColors.ERROR;
      icon = Icon(Icons.trending_down, color: color);
      text = "Outbid: Increase your offer";
    }
    return !_isIamInThisBid
        ? SizedBox.shrink()
        : Flexible(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 5),
            padding: EdgeInsets.all(10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withAlpha(40),
              border: Border.all(width: .2, color: color),
              borderRadius: BorderRadius.circular(10),
            ),

            width: double.infinity,
            height: 50,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
                AppSpacer(widthPortion: .02),

                Flexible(
                  child: Text(
                    text,
                    style: VStyle.style(
                      context: context,
                      color: color,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
  }

  Widget _buildWhatsAppButton() {
    return Flexible(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        height: 50,
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(10),
            ),
            backgroundColor: VColors.SECONDARY,
          ),
          onPressed: () {
            VDetailsControllerBloc.openWhatsApp(
              currentBid: widget.vehicle.currentBid ?? "",
              evaluationId: widget.vehicle.evaluationId,
              image: widget.vehicle.frontImage,
              kmDrive: widget.vehicle.kmsDriven,
              manufactureYear: widget.vehicle.manufacturingYear,
              model: widget.vehicle.modelName,
              noOfOwners: '',
              regNumber: widget.vehicle.regNo,
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment:
                    CrossAxisAlignment.start, // if you prefer left align
                children: [
                  Text(
                    "Bid",
                    style: VStyle.style(
                      context: context,
                      color: VColors.WHITE,
                      size: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Bid your price",
                    style: VStyle.style(context: context, color: VColors.WHITE),
                  ),
                ],
              ),
              Icon(SolarIconsBold.chatRound, color: VColors.WHITE),
            ],
          ),
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
              style: VStyle.style(
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

    switch (status) {
      case "Open":
        {
          if (_isColsed) {
            title = "OPEN SOON";
            color = VColors.ACCENT;
          } else {
            title = "OPEN";
            color = VColors.SUCCESS;
          }
        }
      case "Sold":
        {
          title = "SOLD";
          color = VColors.ERROR;
        }
      case "Not Started":
        {
          title = "NOT STARTED";
          color = VColors.DARK_GREY;
        }
      default:
        {
          title = "";
          color = VColors.SUCCESS;
        }
    }
    // You can customize this based on vehicle status
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
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
        return 'Not Specified';
    }
  }
}
