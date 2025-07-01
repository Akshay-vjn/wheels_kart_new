import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wheels_kart/common/components/app_spacer.dart';
import 'package:wheels_kart/common/dimensions.dart';
import 'package:wheels_kart/common/utils/responsive_helper.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_colors.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/model/v_car_model.dart';
import 'package:wheels_kart/module/Dealer/helper/blocs/live%20price%20change%20controller/live_price_change_controller_bloc.dart';
import 'package:wheels_kart/module/Dealer/core/v_style.dart';

class CVehicleCard extends StatefulWidget {
  final VCarModel vehicle;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onPressCard;

  const CVehicleCard({
    super.key,
    required this.vehicle,
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.onPressCard,
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
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
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

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildDetailsGrid(),

                                    AppSpacer(heightPortion: .01),

                                    _buildRegistrationChip(),
                                  ],
                                ),
                              ],
                            ),
                            AppSpacer(heightPortion: .01),

                            _buildCurrentBidSection(),

                            // BlocBuilder<
                            //   LivePriceChangeControllerBloc,
                            //   LivePriceChangeControllerState
                            // >(
                            //   builder: (context, state) {
                            //     if (state is PriceUpdated) {
                            //       return Center(
                            //         child: Text(
                            //           'Price: ₹${state.price}',
                            //           style: TextStyle(fontSize: 28),
                            //         ),
                            //       );
                            //     } else {
                            //       return Center(
                            //         child: CircularProgressIndicator(),
                            //       );
                            //     }
                            //   },
                            // ),

                            // Current Bid Section
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Enhanced Favorite Button
                  _buildFavoriteButton(),

                  // Status Badge (if needed)
                  _buildStatusBadge(widget.vehicle.status),
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
                ? CachedNetworkImage(
                  imageUrl: widget.vehicle.frontImage,
                  fit: BoxFit.cover,
                  placeholder:
                      (context, url) => Container(
                        color: VColors.LIGHT_GREY,
                        child: const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(VColors.ACCENT),
                          ),
                        ),
                      ),
                  errorWidget: (context, url, error) => _buildPlaceholderIcon(),
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
                  size: 22,
                  fontWeight: FontWeight.bold,
                  color: VColors.BLACK,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    size: 15,
                    color: VColors.DARK_GREY,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    widget.vehicle.manufacturingYear,
                    style: VStyle.style(
                      context: context,
                      size: 15,
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

        // _buildEnhancedDetailChip(
        //   Icons.speed_rounded,
        //   '${widget.vehicle.inspectionId} km',
        //   VColors.SECONDARY,
        // ),
      ],
    );
  }

  Widget _buildRegistrationChip() {
    return SizedBox(
      width: w(context) * .26,
      child: _buildEnhancedDetailChip(
        Icons.confirmation_number_rounded,
        widget.vehicle.regNo.replaceRange(
          6,
          widget.vehicle.regNo.length,
          // '●●●●●●',
          "",
        ),
        const Color.fromARGB(255, 32, 138, 164),
        isFullWidth: true,
      ),
    );
  }

  Widget _buildCurrentBidSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        // gradient: LinearGradient(
        //   colors: [
        //     VColors.ACCENT.withOpacity(0.1),
        //     VColors.ACCENT.withOpacity(0.05),
        //   ],
        // ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: VColors.BLACK.withOpacity(0.2), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: VColors.BLACK,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.gavel_rounded,
              color: Colors.white,
              size: 16,
            ),
          ),
          AppSpacer(widthPortion: .01),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Current Bid",
                style: VStyle.style(
                  context: context,
                  size: 12,
                  color: VColors.DARK_GREY,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                "₹${widget.vehicle.currentBid}",
                style: VStyle.style(
                  context: context,
                  size: 18,
                  fontWeight: FontWeight.bold,
                  color: VColors.BLACK,
                ),
              ),
            ],
          ),
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(AppDimensions.radiusSize10),
        border: Border.all(color: color.withAlpha(50), width: 1),
      ),
      child: Row(
        mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: color.withAlpha(50),
              borderRadius: BorderRadius.circular(3),
            ),
            child: Icon(icon, size: 10, color: color),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              style: VStyle.style(
                context: context,
                size: 12,
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

  Widget _buildStatusBadge(String status) {
    Color color;
    String title;

    if (status == "APPROVED" || status.isEmpty) {
      title = "LIVE";
      color = VColors.SUCCESS;
    } else {
      title = "SOLD";
      color = VColors.REDHARD;
    }
    // You can customize this based on vehicle status
    return Positioned(
        left: 12,
        top: 12,
        child: Container(
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
        ),
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
