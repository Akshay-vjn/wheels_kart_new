import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wheels_kart/common/components/app_spacer.dart';
import 'package:wheels_kart/common/dimensions.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_colors.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/model/v_car_model.dart';
import 'package:wheels_kart/module/Dealer/core/v_style.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_colors.dart';

class CVehicleCard extends StatefulWidget {
  final VCarModel vehicle;
  final String myId;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onPressCard;
  final DateTime? endTime;

  const CVehicleCard({
    super.key,
    required this.myId,
    required this.vehicle,
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.onPressCard,
    required this.endTime,
  });

  @override
  State<CVehicleCard> createState() => _CVehicleCardState();
}

class _CVehicleCardState extends State<CVehicleCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;
  @override
  void initState() {
    _endTime = '00:00';
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
    widget.onPressCard();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  late String _endTime;

  void getMinutesToStop() {
    if (widget.endTime != null) {
      final now = DateTime.now();
      final difference = widget.endTime!.difference(now);

      if (difference.isNegative) {
        _endTime = "00:00";
      } else {
        final min = difference.inMinutes;
        final sec = difference.inSeconds % 60;

        // Format with leading zeros if needed
        final minStr = min.toString().padLeft(2, '0');
        final secStr = sec.toString().padLeft(2, '0');

        _endTime = "$minStr:$secStr";
      }

      setState(() {});
    } else {
      _endTime = "00:00";
    }
  }

  bool get soldToMe => widget.myId == widget.vehicle.soldTo;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
                borderRadius: BorderRadius.circular(20),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Enhanced Vehicle Image Section
                      _buildImageSection(),

                      // Content Section
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Vehicle Header
                            _buildVehicleHeader(),

                            AppSpacer(heightPortion: .01),
                            if (widget.vehicle.bidStatus != "Sold")
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [_buildDetailsGrid()],
                                  ),
                                ],
                              ),
                            if (widget.vehicle.bidStatus != "Sold")
                              AppSpacer(heightPortion: .01),

                            if (widget.vehicle.bidStatus == "Open")
                              _buildOpenBidSection(),

                            if (widget.vehicle.bidStatus == "Sold")
                              bidSoldSecion(),
                            // Current Bid Section
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Enhanced Favorite Button
                  _buildFavoriteButton(),

                  // Status Badge (if needed)
                  Positioned(
                    left: 12,
                    top: 12,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildStatusBadge(widget.vehicle.bidStatus ?? ""),
                        if (soldToMe) _buildStatusForSoldToMe(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildImageSection() {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: Container(
        height: 180,
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

  Widget _buildVehicleHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.vehicle.modelName,
                style: VStyle.style(
                  context: context,
                  size: 19,
                  fontWeight: FontWeight.bold,
                  color: VColors.BLACK,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    size: 10,
                    color: VColors.DARK_GREY,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    widget.vehicle.manufacturingYear,
                    style: VStyle.style(
                      context: context,
                      size: 10,
                      color: VColors.DARK_GREY,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        _buildEnhancedDetailChip(
          Icons.location_on_rounded,
          widget.vehicle.city,
          VColors.ACCENT,
        ),
      ],
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

  Widget bidSoldSecion() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            VColors.SECONDARY.withOpacity(0.1),
            VColors.REDHARD.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: VColors.BLACK.withOpacity(0.2), width: 1),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildSectionTile(
            iconIsRightSide: true,
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(Icons.directions_car, size: 18, color: VColors.WHITE),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Icon(
                    Icons.check_circle,
                    size: 10, // Adjust size relative to car icon
                    color: VColors.ACCENT,
                  ),
                ),
              ],
            ),
            title: "Bid Status",
            value: "Sold",
            iconBgColor: VColors.GREENHARD,
          ),
          _buildSectionTile(
            icon: Icon(Icons.person, size: 18, color: VColors.WHITE),
            title: "Sold to",
            value: widget.vehicle.soldName ?? '',
            iconBgColor: const Color.fromARGB(255, 24, 82, 168),
          ),
        ],
      ),
    );
  }

  Widget _buildOpenBidSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            VColors.SECONDARY.withOpacity(0.1),
            VColors.REDHARD.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: VColors.BLACK.withOpacity(0.2), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildSectionTile(
            iconIsRightSide: true,
            iconBgColor:
                _endTime == "00:00" ? VColors.ERROR : VColors.GREENHARD,
            icon: const Icon(
              Icons.timelapse_sharp,
              color: Colors.white,
              size: 16,
            ),
            title: "Bid Status",
            value: "$_endTime min",
          ),

          _buildSectionTile(
            iconBgColor: VColors.BLACK,
            icon: const Icon(
              Icons.gavel_rounded,
              color: Colors.white,
              size: 16,
            ),
            title: "Current Bid",
            value: "₹${widget.vehicle.currentBid}",
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTile({
    required Widget icon,
    required String title,
    required String value,
    required Color iconBgColor,
    bool? iconIsRightSide = false,
  }) {
    return Flexible(
      child: Row(
        mainAxisAlignment:
            iconIsRightSide == true
                ? MainAxisAlignment.start
                : MainAxisAlignment.end,
        children: [
          if (iconIsRightSide == true) ...[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: icon,
            ),
            AppSpacer(widthPortion: .02),
          ],
          Column(
            crossAxisAlignment:
                iconIsRightSide == true
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.end,
            children: [
              Text(
                title,
                style: VStyle.style(
                  context: context,
                  size: 12,
                  color: VColors.DARK_GREY,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: VStyle.style(
                  context: context,
                  size: 18,
                  fontWeight: FontWeight.bold,
                  color: iconBgColor,
                ),
              ),
            ],
          ),
          if (iconIsRightSide == false) ...[
            AppSpacer(widthPortion: .02),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: icon,
            ),
          ],
        ],
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

  Widget _buildFavoriteButton() {
    return Positioned(
      right: 12,
      top: 12,
      child: Container(
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
            onTap: widget.onFavoriteToggle,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Icon(
                  widget.isFavorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  key: ValueKey(widget.isFavorite),
                  color: widget.isFavorite ? VColors.ACCENT : VColors.DARK_GREY,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentBidder() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: EvAppColors.DEFAULT_ORANGE,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: EvAppColors.DEFAULT_ORANGE.withAlpha(40),
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
            "YOU",
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

  Widget _buildStatusBadge(String status) {
    Color color;
    String title;

    switch (status) {
      case "Open":
        {
          title = "OPEN";
          color = VColors.SUCCESS;
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

  Widget _buildStatusForSoldToMe() {
    return Row(
      children: [
        AppSpacer(widthPortion: .01),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: VColors.ERROR,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: VColors.ERROR.withAlpha(40),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            "TO",
            style: VStyle.style(
              context: context,
              size: 10,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        AppSpacer(widthPortion: .01),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: VColors.ERROR,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: VColors.ERROR.withAlpha(40),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            "YOU",
            style: VStyle.style(
              context: context,
              size: 10,
              color: Colors.white,
              fontWeight: FontWeight.bold,
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
        return 'Not Specified';
    }
  }
}
