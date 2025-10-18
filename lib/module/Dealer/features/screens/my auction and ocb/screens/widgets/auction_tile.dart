// import 'dart:async';
// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:wheels_kart/common/components/app_spacer.dart';
// import 'package:wheels_kart/common/utils/intl_helper.dart';
// import 'package:wheels_kart/common/utils/routes.dart';
// import 'package:wheels_kart/module/Dealer/core/const/v_colors.dart';
// import 'package:wheels_kart/module/Dealer/core/v_style.dart';
// import 'package:wheels_kart/module/Dealer/features/screens/home/data/controller/auctionu%20update%20controller/v_auction_update_controller_cubit.dart';
// import 'package:wheels_kart/module/Dealer/features/screens/home/data/controller/v%20details%20controller/v_details_controller_bloc.dart';
// import 'package:wheels_kart/module/Dealer/features/screens/home/screens/car_details_screen.dart';
// import 'package:wheels_kart/module/Dealer/features/screens/my%20auction%20and%20ocb/data/models/v_my_auction_model.dart';
// import 'package:wheels_kart/module/Dealer/features/screens/my%20auction%20and%20ocb/screens/v_mybid_screen.dart';

// class AuctionTile extends StatefulWidget {
//   final VMyAuctionModel auction;
//   final String myId;
//   final int index;

//   const AuctionTile({
//     super.key,
//     required this.auction,
//     required this.index,
//     required this.myId,
//   });

//   @override
//   State<AuctionTile> createState() => _AuctionTileState();
// }

// class _AuctionTileState extends State<AuctionTile>
//     with TickerProviderStateMixin {
//   late AnimationController _pulseController;
//   late AnimationController _slideController;
//   late Animation<double> _pulseAnimation;
//   late Animation<Offset> _slideAnimation;
//   late Animation<double> _scaleAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _endTime = "00:00:00";

//     // Initialize animation controllers
//     _pulseController = AnimationController(
//       duration: const Duration(seconds: 2),
//       vsync: this,
//     );
//     _slideController = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );

//     _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
//       CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
//     );

//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(0, 0.1),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

//     _scaleAnimation = Tween<double>(
//       begin: 0.95,
//       end: 1.0,
//     ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

//     // Start animations
//     _slideController.forward();
//     if (!_timeOut && !isSold) {
//       _pulseController.repeat(reverse: true);
//     }

//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       getMinutesToStop();
//     });
//   }

//   Timer? _timer;

//   @override
//   void dispose() {
//     _timer?.cancel();
//     _pulseController.dispose();
//     _slideController.dispose();
//     super.dispose();
//   }

//   late String _endTime;

//   void getMinutesToStop() {
//     DateTime? bidTime = widget.auction.bidClosingTime;
//     // final state = context.read<VMyAuctionControllerBloc>().state;
//     // if (state is VMyAuctionControllerSuccessState) {
//     //   log("message");
//     //   bidTime = state.listOfMyAuctions[widget.index].bidClosingTime;
//     // }
//     if (bidTime != null) {
//       if (widget.auction.evaluationId == "WK20023") {
//         log("----------->$bidTime<-------------");
//       }

//       final now = DateTime.now();
//       final difference = bidTime.difference(now);

//       if (difference.isNegative) {
//         _endTime = "00:00:00";
//         _pulseController.stop();
//       } else {
//         final hour = difference.inHours % 60;
//         final min = difference.inMinutes % 60;
//         final sec = difference.inSeconds % 60;

//         final hourStr = hour.toString().padLeft(2, '0');
//         final minStr = min.toString().padLeft(2, '0');
//         final secStr = sec.toString().padLeft(2, '0');

//         _endTime = "$hourStr:$minStr:$secStr";

//         // Start pulsing if time is running out (less than 5 minutes)
//         if (difference.inMinutes < 5 &&
//             !isSold &&
//             !_pulseController.isAnimating) {
//           _pulseController.repeat(reverse: true);
//         }
//       }

//       if (mounted) setState(() {});
//     } else {
//       _endTime = "00:00:00";
//     }
//   }

//   bool get isSold => widget.auction.bidStatus == "Sold";
//   bool get isSoldToMe => isSold && widget.auction.soldTo == widget.myId;
//   bool get isMeHighBidder =>
//       !isSold
//           ? widget.auction.bidAmount ==
//               widget.auction.yourBids.first.amount.toString()
//           : false;
//   bool get _timeOut => _endTime == "00:00:00";
//   bool get _urgentTime =>
//       _endTime != "00:00:00" &&
//       widget.auction.bidClosingTime != null &&
//       widget.auction.bidClosingTime!.difference(DateTime.now()).inMinutes < 5;

//   Color get _borderColor {
//     if (isSold) return VColors.GREENHARD;
//     if (isMeHighBidder) return VColors.SECONDARY;
//     if (_urgentTime) return Colors.orange;
//     // if (isSold) return VColors.DARK_GREY;
//     return VColors.ERROR;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SlideTransition(
//       position: _slideAnimation,
//       child: ScaleTransition(
//         scale: _scaleAnimation,
//         child: AnimatedBuilder(
//           animation: _pulseAnimation,
//           builder: (context, child) {
//             return Transform.scale(
//               scale: _urgentTime && !_timeOut ? _pulseAnimation.value : 1.0,
//               child: Container(
//                 margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
//                 child: Material(
//                   elevation: isSold ? 8 : 4,
//                   shadowColor: _borderColor.withOpacity(0.3),
//                   borderRadius: BorderRadius.circular(16),
//                   child: InkWell(
//                     onTap: _onTileTap,
//                     borderRadius: BorderRadius.circular(16),
//                     splashColor: _borderColor.withOpacity(0.1),
//                     highlightColor: _borderColor.withOpacity(0.05),
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: VColors.WHITE,
//                         border: Border.all(width: .5, color: _borderColor),
//                         borderRadius: BorderRadius.circular(16),
//                         gradient:
//                             isSoldToMe
//                                 ? LinearGradient(
//                                   begin: Alignment.topLeft,
//                                   end: Alignment.bottomRight,
//                                   colors: [
//                                     VColors.WHITE,
//                                     VColors.GREENHARD.withOpacity(0.05),
//                                   ],
//                                 )
//                                 : null,
//                       ),
//                       child: Column(
//                         children: [
//                           // Text(widget.myId),
//                           // Text(widget.auction.soldTo.toString()),
//                           _buildMainContent(),
//                           _buildStatusSection(),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   void _onTileTap() {
//     // Add haptic feedback
//     HapticFeedback.lightImpact();

//     Navigator.of(context).push(
//       AppRoutes.createRoute(
//         VCarDetailsScreen(
//           isLiked: false,
//           auctionType: "AUCTION",
//           frontImage: widget.auction.frontImage,
//           hideBidPrice: true,
//           inspectionId: widget.auction.inspectionId,
//           isShowingInHistoryScreen: true,
//         ),
//       ),
//     );
//   }

//   Widget _buildMainContent() {
//     return Padding(
//       padding: const EdgeInsets.all(12),
//       child: Row(
//         children: [
//           // Image section with enhanced styling
//           Expanded(
//             flex: 2,
//             child: Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(12),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.1),
//                     blurRadius: 8,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(12),
//                 child: VMyBidTab.buildImageSection(
//                   widget.auction.frontImage,
//                   widget.auction.evaluationId,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: 12),
//           // Details section
//           Expanded(
//             flex: 3,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 VMyBidTab.buildHeader(
//                   context,
//                   widget.auction.manufacturingYear,
//                   widget.auction.brandName,
//                   widget.auction.modelName,
//                   widget.auction.city,
//                   widget.auction.evaluationId,
//                 ),
//                 if (!isSold && !_timeOut) ...[
//                   const SizedBox(height: 8),
//                   _buildQuickStats(),
//                 ],
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildQuickStats() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: VColors.PRIMARY.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(
//             Icons.timer_outlined,
//             size: 14,
//             color: _urgentTime ? Colors.orange : VColors.PRIMARY,
//           ),
//           const SizedBox(width: 4),
//           Text(
//             _timeOut ? "Closed" : _endTime,
//             style: VStyle.style(
//               context: context,
//               size: 12,
//               color: _urgentTime ? Colors.orange : VColors.PRIMARY,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatusSection() {
//     if (isSold) {
//       return _buildPurchaseAuctionView();
//     } else {
//       return _buildLiveActiveAuctionView();
//     }
//   }

//   Widget _buildLiveActiveAuctionView() {
//     return Container(
//       decoration: BoxDecoration(
//         color:
//             isMeHighBidder
//                 ? VColors.SECONDARY.withOpacity(0.15)
//                 : VColors.ACCENT.withOpacity(0.15),
//         borderRadius: const BorderRadius.only(
//           bottomLeft: Radius.circular(16),
//           bottomRight: Radius.circular(16),
//         ),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Expanded(child: _buildBidInfo()),
//                 const SizedBox(width: 12),
//                 _buildActionButton(),
//               ],
//             ),

//             _showAllBids(),
//             if (isMeHighBidder && _timeOut) ...[
//               AppSpacer(heightPortion: .01),
//               Text(
//                 "Auction closed. You are the highest bidder. Our team will be in touch shortly.",
//                 style: VStyle.style(context: context, color: VColors.DARK_GREY),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildBidInfo() {
//     if (isMeHighBidder) {
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Row(
//             children: [
//               Icon(Icons.emoji_events, color: VColors.SECONDARY, size: 16),
//               const SizedBox(width: 4),
//               Text(
//                 "You're winning!",
//                 style: VStyle.style(
//                   context: context,
//                   size: 12,
//                   color: VColors.SECONDARY,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 4),
//           Text(
//             "₹${widget.auction.yourBids.first.amount}",
//             style: VStyle.style(
//               context: context,
//               size: 18,
//               color: VColors.SECONDARY,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       );
//     } else {
//       return Row(
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 "Current Bid",
//                 style: VStyle.style(
//                   context: context,
//                   size: 11,
//                   color: VColors.BLACK.withOpacity(0.7),
//                 ),
//               ),
//               Text(
//                 "₹${widget.auction.bidAmount}",
//                 style: VStyle.style(
//                   context: context,
//                   size: 16,
//                   color: VColors.BLACK,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(width: 12),
//           Container(
//             height: 40,
//             width: 1,
//             color: VColors.DARK_GREY.withOpacity(0.3),
//           ),
//           const SizedBox(width: 12),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 "Your Bid",
//                 style: VStyle.style(
//                   context: context,
//                   size: 11,
//                   color: VColors.ERROR.withOpacity(0.8),
//                 ),
//               ),
//               Text(
//                 "₹${widget.auction.yourBids.first.amount}",
//                 style: VStyle.style(
//                   context: context,
//                   size: 14,
//                   color: VColors.ERROR,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       );
//     }
//   }

//   Widget _buildActionButton() {
//     if (isMeHighBidder) {
//       return Container(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//         decoration: BoxDecoration(
//           color: VColors.SECONDARY,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: VColors.SECONDARY.withOpacity(0.3),
//               blurRadius: 8,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(Icons.timer, color: VColors.WHITE, size: 16),
//             const SizedBox(height: 2),
//             _buildTimer(),
//           ],
//         ),
//       );
//     } else {
//       return Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: _timeOut ? null : _onIncreaseBidTap,
//           borderRadius: BorderRadius.circular(12),
//           child: AnimatedContainer(
//             duration: const Duration(milliseconds: 200),
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(12),
//               color: _timeOut ? Colors.grey.withOpacity(0.5) : VColors.PRIMARY,
//               boxShadow:
//                   _timeOut
//                       ? null
//                       : [
//                         BoxShadow(
//                           color: VColors.PRIMARY.withOpacity(0.3),
//                           blurRadius: 8,
//                           offset: const Offset(0, 2),
//                         ),
//                       ],
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(
//                   _timeOut ? Icons.timer_off : Icons.gavel,
//                   color: VColors.WHITE,
//                   size: 16,
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   _timeOut ? "Closed" : "Bid Now",
//                   style: VStyle.style(
//                     context: context,
//                     size: 12,
//                     color: VColors.WHITE,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 if (!_timeOut) _buildTimer(),
//               ],
//             ),
//           ),
//         ),
//       );
//     }
//   }

//   void _onIncreaseBidTap() {
//     HapticFeedback.mediumImpact();
//     VAuctionUpdateControllerCubit.showDiologueForBidWhatsapp(
//        from: "HISTORY",
//       context: context,
//       inspectionId: widget.auction.inspectionId,
//     );
//   }

//   Widget _buildPurchaseAuctionView() {
//     Color color = isSoldToMe ? VColors.GREENHARD : VColors.DARK_GREY;
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.centerLeft,
//           end: Alignment.centerRight,
//           colors: [color, color.withOpacity(0.8)],
//         ),
//         borderRadius: const BorderRadius.only(
//           bottomLeft: Radius.circular(16),
//           bottomRight: Radius.circular(16),
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: color.withOpacity(0.3),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     Icon(
//                       isSoldToMe
//                           ? Icons.check_circle_outline
//                           : Icons.check_circle,
//                       color: VColors.WHITE,
//                       size: 20,
//                     ),
//                     const SizedBox(width: 8),
//                     Text(
//                       isSoldToMe
//                           ? "WINNER"
//                           : widget.auction.bidStatus ?? "SOLD",
//                       style: VStyle.style(
//                         context: context,
//                         size: 16,
//                         fontWeight: FontWeight.w600,
//                         color: VColors.WHITE,
//                       ),
//                     ),
//                   ],
//                 ),
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 12,
//                     vertical: 4,
//                   ),
//                   decoration: BoxDecoration(
//                     color: VColors.WHITE.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Text(
//                     "₹${widget.auction.bidAmount}",
//                     style: VStyle.style(
//                       context: context,
//                       size: 16,
//                       fontWeight: FontWeight.bold,
//                       color: VColors.WHITE,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             _showAllBids(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTimer() {
//     if (_timeOut) {
//       return Text(
//         "Closed",
//         style: VStyle.style(
//           context: context,
//           size: 10,
//           color: VColors.WHITE.withOpacity(0.8),
//         ),
//       );
//     }
//     return Text(
//       _endTime,
//       style: VStyle.style(
//         context: context,
//         size: 10,
//         color: VColors.WHITE,
//         fontWeight: FontWeight.w600,
//       ),
//     );
//   }

//   Widget _showAllBids() {
//     return Padding(
//       padding: EdgeInsetsGeometry.only(top: 10),
//       child: ExpansionTile(
//         collapsedShape: ContinuousRectangleBorder(
//           borderRadius: BorderRadiusGeometry.circular(20),
//         ),
//         shape: ContinuousRectangleBorder(
//           borderRadius: BorderRadiusGeometry.circular(20),
//         ),
//         backgroundColor: VColors.WHITE,
//         collapsedIconColor: VColors.BLACK,
//         iconColor: VColors.BLACK,
//         collapsedBackgroundColor: VColors.WHITE,

//         childrenPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
//         title: Text(
//           "See Your Bids",
//           style: VStyle.style(
//             context: context,
//             color: VColors.BLACK,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         children:
//             widget.auction.yourBids
//                 .map(
//                   (e) => Container(
//                     margin: EdgeInsets.only(bottom: 5),
//                     padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(5),
//                       color: VColors.LIGHT_GREY,
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           "₹${e.amount.toString()}",
//                           style: VStyle.style(
//                             context: context,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: [
//                             Text(
//                               IntlHelper.formteDate(e.time),
//                               style: VStyle.style(
//                                 context: context,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                             Text(
//                               IntlHelper.formteTime(e.time),
//                               style: VStyle.style(
//                                 context: context,
//                                 color: VColors.DARK_GREY,
//                                 fontWeight: FontWeight.w400,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 )
//                 .toList(),
//       ),
//     );
//   }
// }

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wheels_kart/common/utils/intl_helper.dart';
import 'package:wheels_kart/common/utils/routes.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_colors.dart';
import 'package:wheels_kart/module/Dealer/core/v_style.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/controller/auctionu%20update%20controller/v_auction_update_controller_cubit.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/screens/car_details_screen.dart';
import 'package:wheels_kart/module/Dealer/features/screens/my%20auction%20and%20ocb/data/models/v_my_auction_model.dart';
import 'package:wheels_kart/module/Dealer/features/screens/my%20auction%20and%20ocb/screens/v_mybid_screen.dart';

class AuctionTile extends StatefulWidget {
  final VMyAuctionModel auction;
  final String myId;
  final int index;

  const AuctionTile({
    super.key,
    required this.auction,
    required this.index,
    required this.myId,
  });

  @override
  State<AuctionTile> createState() => _AuctionTileState();
}

class _AuctionTileState extends State<AuctionTile>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _slideController;
  late AnimationController _urgentController;
  late AnimationController _celebrationController;
  late AnimationController _shimmerController;

  late Animation<double> _pulseAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _urgentAnimation;
  late Animation<Color?> _urgentColorAnimation;
  late Animation<double> _celebrationAnimation;
  late Animation<double> _shimmerAnimation;

  Timer? _timer;
  late String _endTime;

  @override
  void initState() {
    super.initState();
    _endTime = "00:00:00";

    _initializeAnimations();
    _startInitialAnimations();
    _startTimer();
  }

  void _initializeAnimations() {
    // Main animation controllers
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: Duration(milliseconds: 400 + (widget.index * 100)),
      vsync: this,
    );
    _urgentController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _celebrationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    // Animation definitions
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.03).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.3, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.elasticOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.elasticOut),
    );

    _urgentAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _urgentController, curve: Curves.easeInOut),
    );

    _urgentColorAnimation = ColorTween(
      begin: VColors.PRIMARY,
      end: Colors.red,
    ).animate(_urgentController);

    _celebrationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _celebrationController, curve: Curves.elasticOut),
    );

    _shimmerAnimation = Tween<double>(begin: -2.0, end: 2.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.linear),
    );
  }

  void _startInitialAnimations() {
    _slideController.forward();

    if (isSoldToMe) {
      _celebrationController.forward();
      _shimmerController.repeat();
    } else if (!_timeOut && !isSold) {
      _pulseController.repeat(reverse: true);
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTimer();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    _slideController.dispose();
    _urgentController.dispose();
    _celebrationController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  void _updateTimer() {
    DateTime? bidTime = widget.auction.bidClosingTime;

    if (bidTime != null) {
      final now = DateTime.now();
      final difference = bidTime.difference(now);

      if (difference.isNegative) {
        _endTime = "00:00:00";
        _pulseController.stop();
        _urgentController.stop();
      } else {
        final hour = difference.inHours % 60;
        final min = difference.inMinutes % 60;
        final sec = difference.inSeconds % 60;

        final hourStr = hour.toString().padLeft(2, '0');
        final minStr = min.toString().padLeft(2, '0');
        final secStr = sec.toString().padLeft(2, '0');

        _endTime = "$hourStr:$minStr:$secStr";

        // Handle urgent state (less than 5 minutes)
        if (difference.inMinutes < 5 && !isSold) {
          if (!_urgentController.isAnimating) {
            _urgentController.repeat(reverse: true);
          }
          if (!_pulseController.isAnimating) {
            _pulseController.repeat(reverse: true);
          }
        }
      }

      if (mounted) setState(() {});
    } else {
      _endTime = "00:00:00";
    }
  }

  // Computed properties
  bool get isSold => widget.auction.bidStatus == "Sold";
  bool get isSoldToMe => isSold && widget.auction.soldTo == widget.myId;
  bool get isMeHighBidder =>
      !isSold
          ? widget.auction.bidAmount ==
              widget.auction.yourBids.first.amount.toString()
          : false;
  bool get _timeOut => _endTime == "00:00:00";
  bool get _urgentTime =>
      _endTime != "00:00:00" &&
      widget.auction.bidClosingTime != null &&
      widget.auction.bidClosingTime!.difference(DateTime.now()).inMinutes < 2;

  Color get _primaryColor {
    if (isSoldToMe) return VColors.GREENHARD;
    if (isMeHighBidder) return VColors.SECONDARY;
    if (_urgentTime) return Colors.orange;
    if (isSold) return VColors.DARK_GREY;
    return VColors.PRIMARY;
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedBuilder(
          animation: Listenable.merge([
            _pulseAnimation,
            _urgentAnimation,
            _celebrationAnimation,
          ]),
          builder: (context, child) {
            return Transform.scale(
              scale: _urgentTime && !_timeOut ? _pulseAnimation.value : 1.0,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                child: _buildCard(),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCard() {
    return Material(
      elevation: isSoldToMe ? 12 : (_urgentTime ? 8 : 6),
      shadowColor: _primaryColor.withOpacity(0.3),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: _onTileTap,
        borderRadius: BorderRadius.circular(20),
        splashColor: _primaryColor.withOpacity(0.1),
        highlightColor: _primaryColor.withOpacity(0.05),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            // border: Border.all(
            //   width: isSoldToMe ? 1.5 : 1,
            //   color: _primaryColor.withOpacity(isSoldToMe ? 0.8 : 0.3),
            // ),
            // gradient: _buildCardGradient(),
          ),
          child: Column(children: [_buildMainContent(), _buildStatusSection()]),
        ),
      ),
    );
  }

  // LinearGradient? _buildCardGradient() {
  //   if (isSoldToMe) {
  //     return LinearGradient(
  //       begin: Alignment.topLeft,
  //       end: Alignment.bottomRight,
  //       colors: [
  //         VColors.WHITE,
  //         VColors.GREENHARD.withOpacity(0.08),
  //         VColors.GREENHARD.withOpacity(0.15),
  //       ],
  //     );
  //   } else if (isMeHighBidder) {
  //     return LinearGradient(
  //       begin: Alignment.topLeft,
  //       end: Alignment.bottomRight,
  //       colors: [VColors.WHITE, VColors.SECONDARY.withOpacity(0.05)],
  //     );
  //   }
  //   return null;
  // }

  void _onTileTap() {
    HapticFeedback.lightImpact();
    Navigator.of(context).push(
      AppRoutes.createRoute(
        VCarDetailsScreen(
          paymentStatus: widget.auction.paymentStatus ?? "N/A",
          isLiked: false,
          auctionType: "AUCTION",
          frontImage: widget.auction.frontImage,
          hideBidPrice: true,
          inspectionId: widget.auction.inspectionId,
          isShowingInHistoryScreen: true,
          isOwnedCar: true, // This will use the owned details API
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Enhanced image section
              Expanded(flex: 2, child: _buildImageSection()),
              const SizedBox(width: 16),
              // Enhanced details section
              Expanded(flex: 3, child: _buildDetailsSection()),
            ],
          ),
          if (isSoldToMe) ...[
            const SizedBox(height: 12), 
            _buildWinnerBadge(),
            if (widget.auction.paymentStatus != null && widget.auction.paymentStatus!.isNotEmpty) ...[
              const SizedBox(height: 8),
              _buildPaymentStatusBadge(),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _primaryColor.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: VMyBidTab.buildImageSection(
              widget.auction.frontImage,
              widget.auction.evaluationId,
            ),
          ),
          // Status overlay
          if (isSoldToMe)
            Positioned(
              top: 8,
              right: 8,
              child: AnimatedBuilder(
                animation: _celebrationAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _celebrationAnimation.value,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: VColors.GREENHARD,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: VColors.GREENHARD.withOpacity(0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.emoji_events,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailsSection() {
    return VMyBidTab.buildHeader(
      context,
      widget.auction.manufacturingYear,
      widget.auction.brandName,
      widget.auction.modelName,
      widget.auction.city,
      widget.auction.evaluationId,
    );
  }

  Widget _buildTimerChip() {
    return AnimatedBuilder(
      animation: _urgentController,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _timeOut ? "Auction Closed" : _endTime,
              style: VStyle.style(
                context: context,
                size: 11,
                color: _urgentTime ? VColors.ERROR : VColors.WHITE,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        );
      },
    );
  }

  // Widget _buildWinnerBadge() {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  //     decoration: BoxDecoration(
  //       color: VColors.SUCCESS.withAlpha(180),
  //       borderRadius: BorderRadius.circular(8),
  //       boxShadow: [
  //         BoxShadow(
  //           color: VColors.SUCCESS.withAlpha(40),
  //           blurRadius: 4,
  //           offset: const Offset(0, 2),
  //         ),
  //       ],
  //     ),
  //     child: Row(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         const Icon(Icons.circle, size: 6, color: Colors.white),
  //         const SizedBox(width: 4),
  //         Text(
  //           "WINNER",
  //           style: VStyle.style(
  //             context: context,
  //             size: 10,
  //             color: Colors.white,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  Widget _buildWinnerBadge() {
    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: VColors.GREENHARD.withAlpha(180), // solid base with alpha
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: VColors.GREENHARD.withAlpha(40),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.military_tech, size: 16, color: Colors.white),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  "Congratulations! You won this auction!",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: VStyle.poppins(
                    context: context,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    size: 12,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPaymentStatusBadge() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: _getPaymentStatusColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getPaymentStatusColor().withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _getPaymentStatusIcon(),
            size: 16,
            color: _getPaymentStatusColor(),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              _getPaymentStatusText(),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: VStyle.poppins(
                context: context,
                color: _getPaymentStatusColor(),
                fontWeight: FontWeight.w600,
                size: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getPaymentStatusColor() {
    switch (widget.auction.paymentStatus?.toLowerCase()) {
      case 'completed':
      case 'success':
      case 'paid':
        return VColors.GREENHARD;
      case 'pending':
        return Colors.orange;
      case 'failed':
      case 'cancelled':
        return VColors.ERROR;
      default:
        return VColors.DARK_GREY;
    }
  }

  IconData _getPaymentStatusIcon() {
    switch (widget.auction.paymentStatus?.toLowerCase()) {
      case 'completed':
      case 'success':
      case 'paid':
        return Icons.check_circle;
      case 'pending':
        return Icons.schedule;
      case 'failed':
      case 'cancelled':
        return Icons.error;
      default:
        return Icons.payment;
    }
  }

  String _getPaymentStatusText() {
    switch (widget.auction.paymentStatus?.toLowerCase()) {
      case 'completed':
      case 'success':
      case 'paid':
        return 'Payment Completed';
      case 'pending':
        return 'Payment Pending';
      case 'failed':
        return 'Payment Failed';
      case 'cancelled':
        return 'Payment Cancelled';
      default:
        return 'Payment Status: ${widget.auction.paymentStatus ?? 'N/A'}';
    }
  }

  Widget _buildStatusSection() {
    return Container(
      decoration: BoxDecoration(
        color: _primaryColor.withOpacity(0.1),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildBidInfoRow(),
            const SizedBox(height: 12),
            _buildActionRow(),
            _buildExpandableBids(),
          ],
        ),
      ),
    );
  }

  Widget _buildBidInfoRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(child: _buildBidInfo()),
        if (!isSold && !_timeOut) ...[
          const SizedBox(width: 16),
          _buildQuickActionButton(),
        ],
      ],
    );
  }

  Widget _buildBidInfo() {
    if (isMeHighBidder && !isSold) {
      return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: VColors.SECONDARY.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: VColors.SECONDARY.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(Icons.trending_up, color: VColors.SECONDARY, size: 20),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "You're Leading!",
                  style: VStyle.style(
                    context: context,
                    size: 12,
                    color: VColors.SECONDARY,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  "₹${widget.auction.yourBids.first.amount}",
                  style: VStyle.style(
                    context: context,
                    size: 17,
                    color: VColors.SECONDARY,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          child: _buildBidColumn(
            "Current Highest",
            "₹${widget.auction.bidAmount}",
            VColors.BLACK,
          ),
        ),
        Container(
          height: 40,
          width: 1,
          color: VColors.DARK_GREY.withOpacity(0.3),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildBidColumn(
            "Your Last Bid",
            "₹${widget.auction.yourBids.first.amount}",
            isMeHighBidder ? VColors.SECONDARY : VColors.ERROR,
          ),
        ),
      ],
    );
  }

  Widget _buildBidColumn(String label, String amount, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: VStyle.style(
            context: context,
            size: 11,
            color: VColors.DARK_GREY,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          amount,
          style: VStyle.style(
            context: context,
            size: 16,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionButton() {
    return AnimatedBuilder(
      animation: _urgentAnimation,
      builder: (context, child) {
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _timeOut ? null : _onIncreaseBidTap,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: VColors.SECONDARY,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _timeOut ? Icons.timer_off : Icons.gavel,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _timeOut ? "Closed" : "Bid Now",
                    style: VStyle.style(
                      context: context,
                      size: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (!isSold && !_timeOut) ...[
                    const SizedBox(height: 5),
                    _buildTimerChip(),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionRow() {
    if (!isSold && _timeOut && isMeHighBidder) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: VColors.SECONDARY.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: VColors.SECONDARY.withOpacity(0.3)),
        ),
        child: Text(
          "🎉 Auction ended! You have the winning bid. Our team will contact you soon.",
          style: VStyle.style(
            context: context,
            color: VColors.SECONDARY,
            fontWeight: FontWeight.w500,
            size: 12,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }
    return const SizedBox.shrink();
  }

  void _onIncreaseBidTap() {
    HapticFeedback.mediumImpact();
    VAuctionUpdateControllerCubit.showDiologueForBidWhatsapp(
      paymentStatus: "Yes",
      from: "HISTORY",
      context: context,
      inspectionId: widget.auction.inspectionId,
    );
  }

  Widget _buildExpandableBids() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.white,
          collapsedBackgroundColor: Colors.white,
          iconColor: VColors.BLACK,
          collapsedIconColor: VColors.BLACK,
          childrenPadding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
          title: Row(
            children: [
              Icon(Icons.history, size: 18, color: VColors.BLACK),
              const SizedBox(width: 8),
              Text(
                "Your Bid History (${widget.auction.yourBids.length})",
                style: VStyle.style(
                  context: context,
                  color: VColors.BLACK,
                  fontWeight: FontWeight.w600,
                  size: 14,
                ),
              ),
            ],
          ),
          children:
              widget.auction.yourBids.asMap().entries.map((entry) {
                final index = entry.key;
                final bid = entry.value;
                final isLatest = index == 0;

                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isLatest
                            ? VColors.SECONDARY.withOpacity(0.1)
                            : VColors.LIGHT_GREY.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                    border:
                        isLatest
                            ? Border.all(
                              color: VColors.SECONDARY.withOpacity(0.3),
                            )
                            : null,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          if (isLatest) ...[
                            Icon(
                              Icons.fiber_manual_record,
                              size: 8,
                              color: VColors.SECONDARY,
                            ),
                            const SizedBox(width: 8),
                          ],
                          Text(
                            "₹${bid.amount}",
                            style: VStyle.style(
                              context: context,
                              fontWeight:
                                  isLatest ? FontWeight.w700 : FontWeight.w600,
                              size: isLatest ? 16 : 15,
                              color:
                                  isLatest ? VColors.SECONDARY : VColors.BLACK,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            IntlHelper.formteDate(bid.time),
                            style: VStyle.style(
                              context: context,
                              fontWeight: FontWeight.w500,
                              size: 12,
                              color: VColors.DARK_GREY,
                            ),
                          ),
                          Text(
                            IntlHelper.formteTime(bid.time),
                            style: VStyle.style(
                              context: context,
                              color: VColors.DARK_GREY,
                              fontWeight: FontWeight.w400,
                              size: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }
}
