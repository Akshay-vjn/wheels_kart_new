// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:wheels_kart/common/components/app_empty_text.dart';
// import 'package:wheels_kart/common/components/app_margin.dart';
// import 'package:wheels_kart/common/components/app_spacer.dart';
// import 'package:wheels_kart/module/Dealer/core/components/v_loading.dart';
// import 'package:wheels_kart/module/Dealer/core/const/v_colors.dart';
// import 'package:wheels_kart/module/Dealer/core/v_style.dart';

// import 'package:wheels_kart/module/Dealer/features/screens/my%20auction%20and%20ocb/data/controller/my%20auction%20controller/v_my_auction_controller_bloc.dart';
// import 'package:wheels_kart/module/Dealer/features/screens/my%20auction%20and%20ocb/screens/my_tabs/auction%20tabs/auction_losing_tab.dart';
// import 'package:wheels_kart/module/Dealer/features/screens/my%20auction%20and%20ocb/screens/my_tabs/auction%20tabs/auction_owned_tab.dart';
// import 'package:wheels_kart/module/Dealer/features/screens/my%20auction%20and%20ocb/screens/my_tabs/auction%20tabs/auction_winning_tab.dart';

// class AuctionHistoryTab extends StatefulWidget {
//   final String myId;
//   const AuctionHistoryTab({super.key, required this.myId});

//   @override
//   State<AuctionHistoryTab> createState() => _AuctionHistoryTabState();
// }

// class _AuctionHistoryTabState extends State<AuctionHistoryTab>
//     with TickerProviderStateMixin {
//   late TabController auctionTaContoller;
//   late final VMyAuctionControllerBloc _auctionControllerBloc;
//   @override
//   void initState() {
//     auctionTaContoller = TabController(length: 3, vsync: this);

//     _auctionControllerBloc = context.read<VMyAuctionControllerBloc>();

//     _auctionControllerBloc.add(ConnectWebSocket(myId: widget.myId));
//     _auctionControllerBloc.add(OnGetMyAuctions(context: context));
//     super.initState();
//     auctionTaContoller.addListener(() {
//       setState(() {
//         currentIndex = auctionTaContoller.index;
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _auctionControllerBloc.close();
//     // TODO: implement dispose
//     super.dispose();
//   }

//   int currentIndex = 0;
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<VMyAuctionControllerBloc, VMyAuctionControllerState>(
//       builder: (context, state) {
//         switch (state) {
//           case VMyAuctionControllerSuccessState():
//             {
//               return DefaultTabController(
//                 length: 3,
//                 child: AppMargin(
//                   child: Column(
//                     children: [
//                       AppSpacer(heightPortion: .01),
//                       TabBar(
//                         controller: auctionTaContoller,
//                         labelStyle: VStyle.style(
//                           context: context,
//                           fontWeight: FontWeight.w900,
//                           size: 12,
//                         ),
//                         unselectedLabelStyle: VStyle.style(
//                           context: context,
//                           fontWeight: FontWeight.bold,
//                           size: 12,
//                         ),
//                         indicatorSize: TabBarIndicatorSize.tab,
//                         dividerHeight: 0,
//                         indicatorWeight: 0,
//                         indicatorPadding: EdgeInsetsGeometry.all(4),
//                         indicator: BoxDecoration(
//                           boxShadow: [
//                             BoxShadow(
//                               color: _getTabShadoColor().withAlpha(50),
//                               blurRadius: 10,
//                               spreadRadius: 2,
//                               offset: Offset(1, 1),
//                             ),
//                           ],
//                           border: Border.all(
//                             width: .5,
//                             color: _getTabShadoColor(),
//                           ),
//                           color: VColors.WHITE,
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         tabs: [
//                           Tab(
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   "WINNING",
//                                   style: VStyle.style(
//                                     context: context,
//                                     color: VColors.SECONDARY,
//                                   ),
//                                 ),
//                                 AppSpacer(widthPortion: .02),
//                                 Icon(
//                                   Icons.trending_up,
//                                   size: 20,
//                                   color: VColors.SECONDARY,
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Tab(
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   "LOSING",
//                                   style: VStyle.style(
//                                     context: context,
//                                     color: VColors.ERROR,
//                                   ),
//                                 ),
//                                 AppSpacer(widthPortion: .02),
//                                 Icon(
//                                   Icons.trending_down,
//                                   size: 20,
//                                   color: VColors.ERROR,
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Tab(
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   "OWNED",
//                                   style: VStyle.style(
//                                     context: context,
//                                     color: VColors.GREENHARD,
//                                   ),
//                                 ),
//                                 AppSpacer(widthPortion: .02),
//                                 Icon(
//                                   Icons.emoji_events,
//                                   size: 20,
//                                   color: VColors.GREENHARD,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                       AppSpacer(heightPortion: .01),
//                       Expanded(
//                         child: TabBarView(
//                           controller: auctionTaContoller,
//                           children: [
//                             AuctionWinningTab(myId: widget.myId),
//                             AuctionLosingTab(myId: widget.myId),
//                             AuctionOwnedTab(myId: widget.myId),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             }
//           case VMyAuctionControllerErrorState():
//             {
//               return Center(child: AppEmptyText(text: state.error));
//             }
//           default:
//             {
//               return Center(child: VLoadingIndicator());
//             }
//         }
//       },
//     );
//   }

//   Color _getTabShadoColor() {
//     switch (currentIndex) {
//       case 0:
//         return VColors.SECONDARY;
//       case 1:
//         return VColors.ERROR;
//       case 2:
//         return VColors.GREENHARD;
//       default:
//         {
//           return VColors.SECONDARY;
//         }
//     }
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wheels_kart/common/components/app_spacer.dart';
import 'package:wheels_kart/module/Dealer/core/components/v_loading.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_colors.dart';
import 'package:wheels_kart/module/Dealer/core/v_style.dart';

import 'package:wheels_kart/module/Dealer/features/screens/my%20auction%20and%20ocb/data/controller/my%20auction%20controller/v_my_auction_controller_bloc.dart';
import 'package:wheels_kart/module/Dealer/features/screens/my%20auction%20and%20ocb/screens/my_tabs/auction%20tabs/auction_losing_tab.dart';
import 'package:wheels_kart/module/Dealer/features/screens/my%20auction%20and%20ocb/screens/my_tabs/auction%20tabs/auction_winning_tab.dart';

class AuctionHistoryTab extends StatefulWidget {
  final String myId;
  const AuctionHistoryTab({super.key, required this.myId});

  @override
  State<AuctionHistoryTab> createState() => _AuctionHistoryTabState();
}

class _AuctionHistoryTabState extends State<AuctionHistoryTab>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController auctionTabController;
  late AnimationController _animationController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;
  late final VMyAuctionControllerBloc _auctionControllerBloc;

  int currentIndex = 0;
  bool _isConnected = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    // Initialize controllers
    auctionTabController = TabController(length: 2, vsync: this);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Initialize animations
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Initialize bloc and websocket
    _auctionControllerBloc = context.read<VMyAuctionControllerBloc>();
    _connectToWebSocket();
    _loadAuctions();

    // Add tab listener
    auctionTabController.addListener(_onTabChanged);

    // Start animations
    _animationController.forward();
    _pulseController.repeat(reverse: true);
  }

  void _connectToWebSocket() {
    _auctionControllerBloc.add(ConnectWebSocket(myId: widget.myId));
    setState(() => _isConnected = true);

    // Simulate connection feedback
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() => _isConnected = true);
      }
    });
  }

  void _loadAuctions() {
    _auctionControllerBloc.add(OnGetMyAuctions(context: context));
  }

  void _onTabChanged() {
    if (mounted) {
      setState(() {
        currentIndex = auctionTabController.index;
      });

      // Add haptic feedback
      // HapticFeedback.selectionClick();
    }
  }

  @override
  void dispose() {
    auctionTabController.removeListener(_onTabChanged);
    auctionTabController.dispose();
    _animationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocBuilder<VMyAuctionControllerBloc, VMyAuctionControllerState>(
      builder: (context, state) {
        return AnimatedBuilder(
          animation: _fadeAnimation,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: _buildContent(state),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildContent(VMyAuctionControllerState state) {
    switch (state) {
      case VMyAuctionControllerSuccessState():
        return _buildSuccessContent();
      case VMyAuctionControllerErrorState():
        return _buildErrorContent(state.error);
      default:
        return _buildLoadingContent();
    }
  }

  Widget _buildSuccessContent() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Colors.grey.shade50],
        ),
      ),
      child: Column(
        children: [
          AppSpacer(heightPortion: .01),
          _buildTabBar(),
          AppSpacer(heightPortion: .01),
          Expanded(child: _buildTabBarView()),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.05),
        //     blurRadius: 8,
        //     offset: const Offset(0, 2),
        //   ),
        // ],
      ),
      child: TabBar(
        controller: auctionTabController,
        indicator: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: _getTabColor().withOpacity(0.2),
              blurRadius: 8,
              spreadRadius: 0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: EdgeInsets.zero,
        labelPadding: EdgeInsets.zero,
        dividerColor: Colors.transparent,
        tabs: [
          _buildTab("WINNING", Icons.trending_up_rounded, VColors.SECONDARY, 0),
          _buildTab("LOSING", Icons.trending_down_rounded, VColors.ERROR, 1),
        ],
      ),
    );
  }

  Widget _buildTab(String text, IconData icon, Color color, int index) {
    final isSelected = currentIndex == index;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 48,
      child: Tab(
        child: AnimatedScale(
          scale: isSelected ? 1.0 : 0.95,
          duration: const Duration(milliseconds: 200),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.all(isSelected ? 4 : 2),
                  decoration: BoxDecoration(
                    color:
                        isSelected
                            ? color.withOpacity(0.1)
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    size: isSelected ? 18 : 16,
                    color: isSelected ? color : color.withOpacity(0.6),
                  ),
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    text,
                    style: VStyle.style(
                      context: context,
                      color: isSelected ? color : color.withOpacity(0.6),
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w600,
                      size: isSelected ? 12 : 11,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabBarView() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TabBarView(
        controller: auctionTabController,
        children: [
          _buildTabContent(AuctionWinningTab(myId: widget.myId)),
          _buildTabContent(AuctionLosingTab(myId: widget.myId)),
        ],
      ),
    );
  }

  Widget _buildTabContent(Widget child) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: child,
    );
  }

  Widget _buildLoadingContent() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Custom loading animation
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: VColors.SECONDARY.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(child: VLoadingIndicator()),
                ),
              );
            },
          ),

          const SizedBox(height: 24),

          Text(
            'Loading Your Auctions',
            style: VStyle.style(
              context: context,
              color: VColors.DARK_GREY,
              size: 16,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Connecting to live auction data...',
            style: VStyle.style(
              context: context,
              color: VColors.DARK_GREY.withOpacity(0.7),
              size: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorContent(String error) {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Error icon with animation
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.scale(
                scale: _fadeAnimation.value,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: VColors.ERROR.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.error_outline_rounded,
                    size: 40,
                    color: VColors.ERROR,
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 24),

          Text(
            'Oops! Something went wrong',
            style: VStyle.style(
              context: context,
              color: VColors.BLACK,
              size: 18,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            error,
            style: VStyle.style(
              context: context,
              color: VColors.DARK_GREY,
              size: 14,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 24),

          // Retry button
          ElevatedButton.icon(
            onPressed: () {
              _connectToWebSocket();
              _loadAuctions();
            },
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: const Text('Try Again'),
            style: ElevatedButton.styleFrom(
              backgroundColor: VColors.SECONDARY,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
          ),
        ],
      ),
    );
  }

  Color _getTabColor() {
    switch (currentIndex) {
      case 0:
        return VColors.SECONDARY;
      case 1:
        return VColors.ERROR;
      default:
        return VColors.SECONDARY;
    }
  }
}
