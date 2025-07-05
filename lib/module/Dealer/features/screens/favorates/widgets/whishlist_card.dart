import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wheels_kart/common/dimensions.dart';
import 'package:wheels_kart/common/utils/responsive_helper.dart';
import 'package:wheels_kart/common/utils/routes.dart';
import 'package:wheels_kart/module/Dealer/features/screens/favorates/data/controller/wishlist%20controller/v_wishlist_controller_cubit.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/model/v_car_model.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/screens/car_details_screen.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_colors.dart';
import 'package:wheels_kart/module/Dealer/core/v_style.dart';

class VWhishlistCard extends StatefulWidget {
  final VCarModel model;
  const VWhishlistCard({super.key, required this.model});

  @override
  State<VWhishlistCard> createState() => _VWhishlistCardState();
}

class _VWhishlistCardState extends State<VWhishlistCard>
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
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
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
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
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
                  // Favorite button with improved positioning
                  // Status indicator
                  _buildStatusBadge(widget.model.status),
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
              const SizedBox(width: 16),
              // Content column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title with better typography
                    _buildCarTitle(),
                    const SizedBox(height: 12),
                    // Fuel and mileage chips
                    _buildDetailsChips(),
                    const SizedBox(height: 16),
                    // Location and price row
                    _buildLocationAndPriceRow(),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Action buttons row
          _buildActionButtons(),
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
        Text(
          widget.model.modelName,
          style: VStyle.style(
            context: context,
            color: VColors.GREENHARD,
            fontWeight: FontWeight.w700,
            size: AppDimensions.fontSize15(context),
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          '${widget.model.manufacturingYear}',
          style: VStyle.style(
            context: context,
            color: VColors.GREY,
            fontWeight: FontWeight.w500,
            size: AppDimensions.fontSize12(context),
          ),
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
        _buildEnhancedDetailChip(
          Icons.speed_rounded,
          '${widget.model.kmsDriven} km',
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
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.location_on_rounded, size: 14, color: VColors.REDHARD),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  widget.model.city,
                  style: VStyle.style(
                    context: context,
                    size: 12,
                    color: VColors.REDHARD,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        // Current bid
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "Current Bid",
              style: VStyle.style(
                context: context,
                size: 10,
                color: VColors.GREY,
                fontWeight: FontWeight.w500,
              ),
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
        // View Details button
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () async {
              await Navigator.of(context).push(
                AppRoutes.createRoute(
                  VCarDetailsScreen(
                    frontImage: widget.model.frontImage,
                    inspectionId: widget.model.inspectionId,
                    isLiked: widget.model.wishlisted == 1 ? true : false,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.visibility_rounded, size: 16),
            label: const Text("View Details"),
            style: OutlinedButton.styleFrom(
              foregroundColor: VColors.GREENHARD,
              side: BorderSide(color: VColors.GREENHARD.withOpacity(0.3)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 8),
            ),
          ),
        ),
        const SizedBox(width: 12),
        _buildEnhancedFavoriteButton(widget.model.inspectionId),

        // Bid Now button
        // Expanded(
        //   child: ElevatedButton.icon(
        //     onPressed: () async {
        //       // await VCarDetailsScreen().openWhatsApp(widge);
        //     },
        //     icon: const Icon(Icons.gavel_rounded, size: 16),
        //     label: const Text("Bid Now"),
        //     style: ElevatedButton.styleFrom(
        //       backgroundColor: VColors.GREENHARD,
        //       foregroundColor: Colors.white,
        //       elevation: 0,
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(8),
        //       ),
        //       padding: const EdgeInsets.symmetric(vertical: 8),
        //     ),
        //   ),
        // ),
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
    return Container(
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
          onTap: () {
            // Add haptic feedback
            HapticFeedback.lightImpact();
            context.read<VWishlistControllerCubit>().onChangeFavState(
              context,
              inspectionId,
              fetch: true,
            );
          },
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
    // if (widget.model.currentBid.isNotEmpty) {
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
