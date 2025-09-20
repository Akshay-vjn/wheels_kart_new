// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:wheels_kart/common/components/app_spacer.dart';
// import 'package:wheels_kart/common/controllers/auth%20cubit/auth_cubit.dart';
// import 'package:wheels_kart/module/Dealer/core/components/v_loading.dart';
// import 'package:wheels_kart/module/Dealer/core/const/v_colors.dart';
// import 'package:wheels_kart/module/Dealer/core/v_style.dart';
// import 'package:wheels_kart/module/Dealer/features/screens/home/data/controller/v%20auction%20controller/v_dashboard_controlller_bloc.dart';
// import 'package:wheels_kart/module/Dealer/features/screens/my%20auction%20and%20ocb/data/controller/my%20auction%20controller/v_my_auction_controller_bloc.dart';
// import 'package:wheels_kart/module/Dealer/features/screens/my%20auction%20and%20ocb/screens/my_tabs/auctionhistoy_tab.dart';
// import 'package:wheels_kart/module/Dealer/features/screens/my%20auction%20and%20ocb/screens/my_tabs/bought_ocb_history_tab.dart';
// import 'package:wheels_kart/module/Dealer/features/v_nav_screen.dart';
// import 'package:wheels_kart/module/Dealer/features/widgets/v_custom_backbutton.dart';

// class VMyBidTab extends StatefulWidget {
//   const VMyBidTab({super.key});

//   @override
//   State<VMyBidTab> createState() => _VMyBidTabState();

//   static Widget buildImageSection(String image, String id) {
//     return ClipRRect(
//       borderRadius: const BorderRadius.only(
//         topLeft: Radius.circular(15),
//         bottomRight: Radius.circular(15),
//       ),
//       child: Container(
//         height: 100,
//         width: double.infinity,
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [VColors.LIGHT_GREY.withOpacity(0.3), VColors.LIGHT_GREY],
//           ),
//         ),
//         child: Stack(
//           fit: StackFit.expand,
//           children: [
//             image.isNotEmpty
//                 ? Hero(
//                   tag: id,
//                   child: CachedNetworkImage(
//                     imageUrl: image,
//                     fit: BoxFit.cover,
//                     placeholder:
//                         (context, url) => Container(
//                           color: VColors.LIGHT_GREY,
//                           child: const Center(child: VLoadingIndicator()),
//                         ),
//                     errorWidget:
//                         (context, url, error) => _buildPlaceholderIcon(),
//                   ),
//                 )
//                 : _buildPlaceholderIcon(),

//             // Gradient overlay for better text visibility
//             Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [Colors.transparent, Colors.black.withOpacity(0.1)],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   static Widget buildHeader(
//     BuildContext context,
//     String manufacturingYear,
//     String brandName,
//     String modelName,
//     String city,
//     String evaluationId,
//   ) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       mainAxisAlignment: MainAxisAlignment.end,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           "$manufacturingYear $brandName",
//           style: VStyle.style(context: context, color: VColors.BLACK, size: 17),
//         ),
//         Text(
//           modelName,
//           style: VStyle.style(context: context, color: VColors.BLACK, size: 14),
//         ),
//         AppSpacer(heightPortion: .01),
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Flexible(
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Icon(
//                     Icons.location_on_rounded,
//                     color: VColors.DARK_GREY,
//                     size: 15,
//                   ),
//                   SizedBox(width: 1),
//                   Flexible(
//                     child: Text(
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       city,
//                       style: VStyle.style(
//                         context: context,
//                         color: VColors.DARK_GREY,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Flexible(
//               child: Text(
//                 "ID: $evaluationId",
//                 style: VStyle.style(context: context, color: VColors.DARK_GREY),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   static Widget _buildPlaceholderIcon() {
//     return Container(
//       color: VColors.LIGHT_GREY,
//       child: const Center(
//         child: Icon(
//           Icons.directions_car_rounded,
//           size: 60,
//           color: VColors.DARK_GREY,
//         ),
//       ),
//     );
//   }
// }

// class _VMyBidTabState extends State<VMyBidTab> with TickerProviderStateMixin {
//   late TabController _tabController;
//   // late String myId;
//   @override
//   void initState() {
//     _tabController = TabController(length: 2, vsync: this);
//     // final state = context.read<AppAuthController>().state;
//     // if (state is AuthCubitAuthenticateState) {
//     //   myId = state.userModel.userId ?? "";
//     // } else {
//     //   myId = '';
//     // }

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         bottom: false,
//         child: DefaultTabController(
//           length: 2,
//           child: Column(
//             children: [
//               AppSpacer(heightPortion: .01),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   // VCustomBackbutton(blendColor: VColors.GREY),
//                   AppSpacer(widthPortion: .02),
//                   Flexible(
//                     child: TabBar(
//                       controller: _tabController,
//                       tabAlignment: TabAlignment.center,
//                       // indicatorSize: TabBarIndicatorSize.tab,
//                       indicatorColor: VColors.SECONDARY,
//                       labelStyle: VStyle.style(
//                         color: VColors.SECONDARY,
//                         context: context,
//                         fontWeight: FontWeight.w900,
//                         size: 10,
//                       ),
//                       unselectedLabelStyle: VStyle.style(
//                         size: 10,
//                         context: context,
//                         fontWeight: FontWeight.w300,
//                       ),
//                       dividerHeight: 0,
//                       tabs: [
//                         Padding(
//                           padding: EdgeInsetsGeometry.only(bottom: 10, top: 10),
//                           child: Text("Auction"),
//                         ),
//                         Padding(
//                           padding: EdgeInsetsGeometry.only(bottom: 10, top: 10),
//                           child: Text('Bought (OCB)'),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               AppSpacer(heightPortion: .01),

//               Expanded(
//                 child: Container(
//                   color: VColors.GREYHARD.withAlpha(50),
//                   child: TabBarView(
//                     controller: _tabController,
//                     children: [
//                       BlocProvider(
//                         create: (context) => VMyAuctionControllerBloc(),
//                         child: AuctionHistoryTab(myId: CURRENT_DEALER_ID),
//                       ),
//                       BoughtOcbHistoryTab(),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wheels_kart/common/components/app_margin.dart';
import 'package:wheels_kart/common/components/app_spacer.dart';
import 'package:wheels_kart/module/Dealer/core/components/v_loading.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_colors.dart';
import 'package:wheels_kart/module/Dealer/core/v_style.dart';
import 'package:wheels_kart/module/Dealer/features/screens/my%20auction%20and%20ocb/data/controller/my%20auction%20controller/v_my_auction_controller_bloc.dart';
import 'package:wheels_kart/module/Dealer/features/screens/my%20auction%20and%20ocb/screens/my_tabs/auctionhistoy_tab.dart';
import 'package:wheels_kart/module/Dealer/features/screens/my%20auction%20and%20ocb/screens/my_tabs/bought_ocb_history_tab.dart';
import 'package:wheels_kart/module/Dealer/features/v_nav_screen.dart';

class VMyBidTab extends StatefulWidget {
  const VMyBidTab({super.key});

  @override
  State<VMyBidTab> createState() => _VMyBidTabState();

  /// Enhanced image section with better visual appeal and animations
  static Widget buildImageSection(
    String image,
    String id, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 120,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background gradient
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      VColors.LIGHT_GREY.withOpacity(0.2),
                      VColors.LIGHT_GREY.withOpacity(0.8),
                    ],
                  ),
                ),
              ),

              // Image content
              image.isNotEmpty
                  ? Hero(
                    tag: id,
                    child: CachedNetworkImage(
                      imageUrl: image,
                      fit: BoxFit.cover,
                      placeholder:
                          (context, url) => Container(
                            decoration: BoxDecoration(
                              color: VColors.LIGHT_GREY.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Center(child: VLoadingIndicator()),
                          ),
                      errorWidget:
                          (context, url, error) => _buildPlaceholderIcon(),
                    ),
                  )
                  : _buildPlaceholderIcon(),

              // Enhanced gradient overlay
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.2),
                      Colors.black.withOpacity(0.4),
                    ],
                    stops: const [0.0, 0.6, 1.0],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Enhanced header with better typography and layout
  static Widget buildHeader(
    BuildContext context,
    String manufacturingYear,
    String brandName,
    String modelName,
    String city,
    String evaluationId,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main title with better hierarchy
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "$manufacturingYear $brandName",
                      style: VStyle.style(
                        context: context,
                        color: VColors.BLACK,
                        size: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      modelName,
                      style: VStyle.style(
                        context: context,
                        color: VColors.DARK_GREY,
                        size: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          // Enhanced info row
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Location info
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: VColors.SECONDARY.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      Icons.location_on_rounded,
                      color: VColors.SECONDARY,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      city,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: VStyle.style(
                        context: context,
                        color: VColors.DARK_GREY,
                        size: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              // ID info
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: VColors.LIGHT_GREY.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "ID: $evaluationId",
                  style: VStyle.style(
                    context: context,
                    color: VColors.DARK_GREY,
                    size: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _buildPlaceholderIcon() {
    return Container(
      decoration: BoxDecoration(
        color: VColors.LIGHT_GREY.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.directions_car_rounded,
              size: 48,
              color: VColors.DARK_GREY.withOpacity(0.6),
            ),
            const SizedBox(height: 8),
            Text(
              'No Image',
              style: TextStyle(
                fontSize: 12,
                color: VColors.DARK_GREY.withOpacity(0.6),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VMyBidTabState extends State<VMyBidTab>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      // backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        bottom: false,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              // Enhanced header section
              _buildHeaderSection(),

              // Enhanced tab content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    BlocProvider(
                      create: (context) => VMyAuctionControllerBloc(),
                      child: AuctionHistoryTab(myId: CURRENT_DEALER_ID),
                    ),
                    const BoughtOcbHistoryTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // VCustomBackbutton(blendColor: VColors.GREY),
        AppSpacer(widthPortion: .02),
        Flexible(
          child: TabBar(
            controller: _tabController,
            tabAlignment: TabAlignment.center,
            // indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor: VColors.BLACK,
            labelStyle: VStyle.poppins(
              color: VColors.BLACK,
              context: context,
              fontWeight: FontWeight.bold,
              size: 15,
            ),
            unselectedLabelStyle: VStyle.poppins(
              size: 15,
              context: context,
              color: VColors.GREY,
              fontWeight: FontWeight.w300,
            ),
            dividerHeight: 0,

            tabs: [
              Padding(
                padding: EdgeInsetsGeometry.only(bottom: 10, top: 10),
                child: Text("Auction"),
              ),
              Padding(
                padding: EdgeInsetsGeometry.only(bottom: 10, top: 10),
                child: Text('Bought (OCB)'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
