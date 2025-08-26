import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wheels_kart/common/components/app_spacer.dart';
import 'package:wheels_kart/common/utils/responsive_helper.dart';
import 'package:wheels_kart/common/utils/routes.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_colors.dart';
import 'package:wheels_kart/module/Dealer/core/v_style.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/screens/car_details_screen.dart';
import 'package:wheels_kart/module/Dealer/features/screens/my%20auction%20and%20ocb/data/models/my_ocb_model.dart';
import 'package:wheels_kart/module/Dealer/features/screens/my%20auction%20and%20ocb/screens/v_mybid_screen.dart';

class OcbTile extends StatefulWidget {
  final MyOcbModel ocb;
  const OcbTile({super.key, required this.ocb});

  @override
  State<OcbTile> createState() => _OcbTileState();
}

class _OcbTileState extends State<OcbTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    // Start entrance animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTileTap() {
    HapticFeedback.lightImpact();
    Navigator.of(context).push(
      AppRoutes.createRoute(
        VCarDetailsScreen(
          isLiked: false,
          auctionType: "OCB",
          frontImage: widget.ocb.frontImage,
          hideBidPrice: true,
          inspectionId: widget.ocb.inspectionId,
          isShowingInHistoryScreen: true,
        ),
      ),
    );
  }

  void _onDetailsButtonTap() {
    HapticFeedback.mediumImpact();
    _onTileTap();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
            child: Material(
              elevation: 6,
              shadowColor: VColors.GREENHARD.withOpacity(0.25),
              borderRadius: BorderRadius.circular(18),
              child: InkWell(
                onTap: _onTileTap,
                borderRadius: BorderRadius.circular(18),
                splashColor: VColors.GREENHARD.withOpacity(0.1),
                highlightColor: VColors.GREENHARD.withOpacity(0.05),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        VColors.WHITE,
                        VColors.GREENHARD.withOpacity(0.03),
                      ],
                    ),
                    border: Border.all(
                      width: 2,
                      color: VColors.GREENHARD,
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    children: [
                      // _buildHeader(),
                      _buildMainContent(),
                      _buildFooterSection(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            VColors.GREENHARD,
            VColors.GREENHARD.withOpacity(0.8),
          ],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_outline,
            color: VColors.WHITE,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            "OCB Purchase",
            style: VStyle.style(
              context: context,
              size: 14,
              color: VColors.WHITE,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: VColors.WHITE.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              "COMPLETED",
              style: VStyle.style(
                context: context,
                size: 10,
                color: VColors.WHITE,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Enhanced image section
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AspectRatio(
                  aspectRatio: 16 / 10,
                  child: VMyBidTab.buildImageSection(
                    widget.ocb.frontImage,
                    widget.ocb.evaluationId,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Enhanced details section
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                VMyBidTab.buildHeader(
                  context,
                  widget.ocb.manufacturingYear,
                  widget.ocb.brandName,
                  widget.ocb.modelName,
                  widget.ocb.city,
                  widget.ocb.evaluationId,
                ),
                const SizedBox(height: 12),
           
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: VColors.GREENHARD.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: VColors.GREENHARD.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.account_balance_wallet,
                color: VColors.GREENHARD,
                size: 16,
              ),
              Text(
                "Purchase Price",
                style: VStyle.style(
                  context: context,
                  size: 12,
                  color: VColors.GREENHARD.withOpacity(0.8),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Text(
            "₹${widget.ocb.bidAmount}",
            style: VStyle.style(
              context: context,
              size: 20,
              fontWeight: FontWeight.bold,
              color: VColors.GREENHARD,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterSection() {
    return Container(
      width: w(context),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: VColors.GREENHARD.withOpacity(0.05),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(18),
          bottomRight: Radius.circular(18),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

               _buildPriceInfo(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoChip(
                icon: Icons.calendar_today,
                label: widget.ocb.bidTime,
                color: VColors.GREENHARD,
              ),
              AppSpacer(heightPortion: .01,),
              _buildDetailsButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: 14,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: VStyle.style(
              context: context,
              size: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _onDetailsButtonTap,
        borderRadius: BorderRadius.circular(25),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                VColors.GREENHARD,
                VColors.GREENHARD.withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: VColors.GREENHARD.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.visibility,
                color: VColors.WHITE,
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                "View Details",
                style: VStyle.style(
                  context: context,
                  fontWeight: FontWeight.w600,
                  size: 12,
                  color: VColors.WHITE,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 12,
                color: VColors.WHITE,
              ),
            ],
          ),
        ),
      ),
    );
  }
}