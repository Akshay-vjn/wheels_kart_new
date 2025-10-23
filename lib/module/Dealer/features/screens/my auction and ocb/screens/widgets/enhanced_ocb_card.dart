import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wheels_kart/common/components/app_spacer.dart';
import 'package:wheels_kart/common/utils/responsive_helper.dart';
import 'package:wheels_kart/common/utils/routes.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_colors.dart';
import 'package:wheels_kart/module/Dealer/core/v_style.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/model/v_car_detail_model.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/screens/car_details_screen.dart';
import 'package:wheels_kart/module/Dealer/features/screens/my%20auction%20and%20ocb/data/models/my_ocb_model.dart';
import 'package:wheels_kart/module/Dealer/features/screens/my%20auction%20and%20ocb/screens/v_mybid_screen.dart';

class EnhancedOcbCard extends StatefulWidget {
  final MyOcbModel ocb;
  final VCarDetailModel? ownedDetails;
  final bool isLoading;

  const EnhancedOcbCard({
    super.key,
    required this.ocb,
    this.ownedDetails,
    this.isLoading = false,
  });

  @override
  State<EnhancedOcbCard> createState() => _EnhancedOcbCardState();
}

class _EnhancedOcbCardState extends State<EnhancedOcbCard>
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

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

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
          paymentStatus: "Yes",
          isLiked: false,
          auctionType: "OCB",
          frontImage: widget.ocb.frontImage,
          hideBidPrice: true,
          inspectionId: widget.ocb.inspectionId,
          isShowingInHistoryScreen: true,
          isOwnedCar: true,
        ),
      ),
    );
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
              elevation: 8,
              shadowColor: VColors.GREENHARD.withOpacity(0.25),
              borderRadius: BorderRadius.circular(18),
              child: InkWell(
                onTap: _onTileTap,
                borderRadius: BorderRadius.circular(18),
                splashColor: VColors.GREENHARD.withOpacity(0.1),
                highlightColor: VColors.GREENHARD.withOpacity(0.05),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 2,
                      color: VColors.GREENHARD.withAlpha(100),
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    children: [
                      _buildMainContent(),
                      _buildFooterSection(), // footer includes price, date, paid, balance
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

  Widget _buildMainContent() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image section
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
              child: VMyBidTab.buildImageSection(
                widget.ocb.frontImage,
                widget.ocb.evaluationId,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Car info
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

  /// Footer with purchase price + date/time on left, and paid/balance on right
  Widget _buildFooterSection() {
    final payment = widget.ownedDetails?.paymentDetails.isNotEmpty == true
        ? widget.ownedDetails!.paymentDetails.first
        : null;

    return Container(
      width: w(context),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: VColors.GREENHARD.withOpacity(0.05),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(18),
          bottomRight: Radius.circular(18),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Left side: Price + Date/Time
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.account_balance_wallet,
                    color: VColors.GREENHARD,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
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
                  size: 18,
                  fontWeight: FontWeight.bold,
                  color: VColors.GREENHARD,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.calendar_today, color: VColors.DARK_GREY, size: 14),
                  const SizedBox(width: 6),
                  Text(
                    widget.ocb.bidTime,
                    style: VStyle.style(
                      context: context,
                      size: 12,
                      color: VColors.DARK_GREY,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Right side: Paid + Balance
          if (payment != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "Paid: ₹${payment.paidAmount ?? 'N/A'}",
                  style: VStyle.style(
                    context: context,
                    size: 15,
                    color: VColors.GREENHARD,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Balance: ₹${payment.balanceAmount ?? 'N/A'}",
                  style: VStyle.style(
                    context: context,
                    size: 15,
                    color: Colors.orange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
