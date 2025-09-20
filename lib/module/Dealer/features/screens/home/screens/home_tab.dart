// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:wheels_kart/common/components/app_margin.dart';
// import 'package:wheels_kart/common/components/app_spacer.dart';
// import 'package:wheels_kart/common/dimensions.dart';
// import 'package:wheels_kart/common/utils/responsive_helper.dart';
// import 'package:wheels_kart/module/Dealer/core/const/v_colors.dart';
// import 'package:wheels_kart/module/Dealer/core/v_style.dart';
// import 'package:wheels_kart/module/Dealer/features/screens/account/data/controller/profile%20controller/v_profile_controller_cubit.dart';
// import 'package:wheels_kart/module/Dealer/features/screens/home/data/controller/filter_auction_and_ocb/filter_acution_and_ocb_cubit.dart';
// import 'package:wheels_kart/module/Dealer/features/screens/home/data/controller/ocb%20controller/v_ocb_controller_bloc.dart';
// import 'package:wheels_kart/module/Dealer/features/screens/home/data/controller/v%20auction%20controller/v_dashboard_controlller_bloc.dart';
// import 'package:wheels_kart/module/Dealer/features/screens/home/screens/Auction/auction_car_card_builder.dart';
// import 'package:wheels_kart/module/Dealer/features/screens/home/screens/OCB/v_ocb_car_builder.dart';
// import 'package:wheels_kart/module/Dealer/features/screens/home/screens/widgets/filter/build_filter_and_sort_view.dart';

// class VHomeTab extends StatefulWidget {
//   const VHomeTab({super.key});

//   @override
//   State<VHomeTab> createState() => _VHomeTabState();
// }

// class _VHomeTabState extends State<VHomeTab> with TickerProviderStateMixin {
//   final ScrollController _scrollController = ScrollController();
//   late TabController _tabController;
//   int tabIndex = 0;

//   // Sample vehicle data

//   Set<String> favoriteVehicles = {};
//   bool isScrolled = false;
//   // create bloc fields so they live across rebuilds
//   late final VAuctionControlllerBloc _auctionBloc;
//   late final VOcbControllerBloc _ocbBloc;
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//     _auctionBloc = VAuctionControlllerBloc();
//     _ocbBloc = VOcbControllerBloc();
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       _scrollController.addListener(() {
//         if (_scrollController.offset > 0) {
//           isScrolled = true;
//         } else {
//           isScrolled = false;
//         }
//         setState(() {});
//       });

//       _tabController.addListener(() {
//         tabIndex = _tabController.index;
//         // _auctionBloc = VAuctionControlllerBloc();
//         // _ocbBloc = VOcbControllerBloc();
//         setState(() {});
//         context.read<FilterAcutionAndOcbCubit>().clearFilter();
//         log("CurrentPage Tab - $tabIndex");
//       });
//     });
//     context.read<FilterAcutionAndOcbCubit>().initWithFilterData(context);
//   }

//   @override
//   void dispose() {
//     _auctionBloc.close();
//     _ocbBloc.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider.value(value: _auctionBloc),
//         BlocProvider.value(value: _ocbBloc),
//       ],
//       child: Scaffold(
//         backgroundColor: VVColors.WHITEBGCOLOR,

//         body: DefaultTabController(
//           length: 2,
//           initialIndex: tabIndex,
//           child: Column(
//             children: [
//               Container(
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                     colors: [Colors.blue.shade400, Colors.blue.shade700],
//                   ),

//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.2),
//                       blurRadius: 15,
//                       offset: Offset(0, 8),
//                     ),
//                   ],
//                 ),
//                 child: Stack(
//                   children: [
//                     Positioned(
//                       top: -50,
//                       left: -50,
//                       child: Container(
//                         width: 200,
//                         height: 200,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: VColors.WHITE.withOpacity(0.1),
//                         ),
//                       ),
//                     ),
//                     Positioned(
//                       top: -100,
//                       right: -30,
//                       child: Container(
//                         width: 150,
//                         height: 150,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: VColors.WHITE.withOpacity(0.05),
//                         ),
//                       ),
//                     ),
//                     SafeArea(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           AppMargin(
//                             child: Row(
//                               children: [
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       "Welcome back,",
//                                       style: VStyle.style(
//                                         context: context,
//                                         color: VColors.GREY,
//                                         fontWeight: FontWeight.w300,
//                                         size: AppDimensions.fontSize15(context),
//                                       ),
//                                     ),
//                                     AppSpacer(heightPortion: .005),
//                                     BlocBuilder<
//                                       VProfileControllerCubit,
//                                       VProfileControllerState
//                                     >(
//                                       builder: (context, state) {
//                                         return Text(
//                                           state is VProfileControllerSuccessState
//                                               ? state.profileModel.vendorName
//                                               : "",
//                                           style: VStyle.style(
//                                             context: context,
//                                             color: VColors.BLACK,
//                                             fontWeight: FontWeight.bold,
//                                             size: AppDimensions.fontSize24(
//                                               context,
//                                             ),
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),

//                           FilterAndSortWidget(
//                             onFiltersAndSortApplied: (filter, sort) {
//                               context
//                                   .read<FilterAcutionAndOcbCubit>()
//                                   .onApplyFilterAndSort(filter, sort);
//                               if (tabIndex == 0) {
//                                 _auctionBloc.add(
//                                   OnApplyFilterAndSortInAuction(
//                                     sortBy: sort,
//                                     filterBy: filter,
//                                   ),
//                                 );
//                               } else {
//                                 _ocbBloc.add(
//                                   OnApplyFilterAndSortInOCB(
//                                     sortBy: sort,
//                                     filterBy: filter,
//                                   ),
//                                 );
//                               }

//                               log(sort);
//                               log(filter.toString());
//                             },
//                           ),

//                           TabBar(
//                             controller: _tabController,
//                             labelStyle: VStyle.style(
//                               context: context,
//                               fontWeight: FontWeight.bold,
//                               size: 15,
//                               color: VColors.SECONDARY,
//                             ),
//                             unselectedLabelStyle: VStyle.style(
//                               context: context,
//                               size: 15,
//                             ),
//                             dividerHeight: 2,
//                             indicatorSize: TabBarIndicatorSize.tab,
//                             indicatorWeight: 3,

//                             indicatorColor: VColors.SECONDARY,
//                             overlayColor: WidgetStatePropertyAll(VVColors.WHITE),
//                             tabs: [Tab(text: "Auctions"), Tab(text: "OCB")],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               Expanded(
//                 child: TabBarView(
//                   controller: _tabController,
//                   children: [
//                     // BlocProvider(
//                     //   create: (context) => VAuctionControlllerBloc(),
//                     //   child:
//                     VAuctionCarBuilder(),
//                     // ),
//                     // BlocProvider(
//                     //   create: (context) => VOcbControllerBloc(),
//                     //   child:
//                     VOCBCarBuilder(),
//                     // ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wheels_kart/common/components/app_margin.dart';
import 'package:wheels_kart/common/components/app_spacer.dart';
import 'package:wheels_kart/common/dimensions.dart';
import 'package:wheels_kart/common/utils/responsive_helper.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_colors.dart';
import 'package:wheels_kart/module/Dealer/core/v_style.dart';
import 'package:wheels_kart/module/Dealer/features/screens/account/data/controller/profile%20controller/v_profile_controller_cubit.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/controller/filter_auction_and_ocb/filter_acution_and_ocb_cubit.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/controller/ocb%20controller/v_ocb_controller_bloc.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/controller/v%20auction%20controller/v_dashboard_controlller_bloc.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/screens/Auction/auction_car_card_builder.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/screens/OCB/v_ocb_car_builder.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/screens/widgets/filter/build_filter_and_sort_view.dart';

class VHomeTab extends StatefulWidget {
  const VHomeTab({super.key});

  @override
  State<VHomeTab> createState() => _VHomeTabState();
}

class _VHomeTabState extends State<VHomeTab> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late TabController _tabController;
  late AnimationController _headerAnimationController;
  late Animation<double> _headerAnimation;
  int tabIndex = 0;

  Set<String> favoriteVehicles = {};
  bool isScrolled = false;

  late final VAuctionControlllerBloc _auctionBloc;
  late final VOcbControllerBloc _ocbBloc;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _headerAnimation = CurvedAnimation(
      parent: _headerAnimationController,
      curve: Curves.easeInOut,
    );

    _auctionBloc = VAuctionControlllerBloc();
    _ocbBloc = VOcbControllerBloc();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _headerAnimationController.forward();

      _scrollController.addListener(() {
        if (_scrollController.offset > 0) {
          isScrolled = true;
        } else {
          isScrolled = false;
        }
        setState(() {});
      });

      _tabController.addListener(() {
        tabIndex = _tabController.index;
        setState(() {});
        _searchController.clear();
        context.read<FilterAcutionAndOcbCubit>().clearFilter();
        log("CurrentPage Tab - $tabIndex");
      });
    });
    context.read<FilterAcutionAndOcbCubit>().initWithFilterData(context);
  }

  @override
  void dispose() {
    _headerAnimationController.dispose();
    if (_auctionBloc.state is VAuctionControllerSuccessState) {
      _auctionBloc.close();
    }

    if (_ocbBloc.state is VOcbControllerSuccessState) {
      _ocbBloc.close();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _auctionBloc),
        BlocProvider.value(value: _ocbBloc),
      ],
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: DefaultTabController(
          length: 2,
          initialIndex: tabIndex,
          child: Column(
            children: [
              _buildEnhancedHeader(),

              // Enhanced Tab Bar
              _buildEnhancedTabBar(),

              // Enhanced Content Area
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [VAuctionCarBuilder(), VOCBCarBuilder()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF667eea),
            const Color(0xFF764ba2),
            Colors.blue.shade800,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withAlpha(50),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Background decorative elements
          Positioned(
            top: -80,
            left: -60,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    VColors.WHITE.withOpacity(0.15),
                    VColors.WHITE.withOpacity(0.05),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: -120,
            right: -40,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    VColors.WHITE.withOpacity(0.1),
                    VColors.WHITE.withOpacity(0.02),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            right: 50,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: VColors.WHITE.withOpacity(0.08),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Enhanced Welcome Section
                AppMargin(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: VColors.WHITE.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "Welcome back,",
                                style: VStyle.style(
                                  context: context,
                                  color: VColors.WHITE.withOpacity(0.9),
                                  fontWeight: FontWeight.w400,
                                  size: AppDimensions.fontSize15(context),
                                ),
                              ),
                            ),
                            AppSpacer(heightPortion: .01),
                            BlocBuilder<
                              VProfileControllerCubit,
                              VProfileControllerState
                            >(
                              builder: (context, state) {
                                return AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  child: Text(
                                    state is VProfileControllerSuccessState
                                        ? state.profileModel.vendorName
                                        : "Loading...",
                                    key: ValueKey(state.runtimeType),
                                    style: VStyle.style(
                                      context: context,
                                      color: VColors.WHITE,
                                      fontWeight: FontWeight.bold,
                                      size: AppDimensions.fontSize24(context),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      // Enhanced notification/profile icon
                      Container(
                        width: 200,
                        height: 45,
                        decoration: BoxDecoration(
                          color: VColors.WHITE.withAlpha(15),

                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: VColors.WHITE.withAlpha(60),
                            width: 1,
                          ),
                        ),
                        child: TextFormField(
                          controller: _searchController,
                          style: TextStyle(color: VColors.WHITE, fontSize: 14),
                          cursorColor: VColors.WHITE.withAlpha(140),

                          decoration: InputDecoration(
                            hintText: "Search vehicles...",
                            hintStyle: TextStyle(
                              color: VColors.WHITE.withAlpha(140),
                              fontSize: 14,
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              color: VColors.WHITE.withAlpha(140),
                              size: 20,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          onChanged: (value) {
                            log(value);
                            if (tabIndex == 0) {
                              _auctionBloc.add(OnSearchAuction(query: value));
                            } else {
                              _ocbBloc.add(OnSearchOCB(query: value));
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Enhanced Filter Widget with better styling
                FilterAndSortWidget(
                  onFiltersAndSortApplied: (filter, sort) {
                    context
                        .read<FilterAcutionAndOcbCubit>()
                        .onApplyFilterAndSort(filter, sort);
                    if (tabIndex == 0) {
                      _auctionBloc.add(
                        OnApplyFilterAndSortInAuction(
                          sortBy: sort,
                          filterBy: filter,
                        ),
                      );
                    } else {
                      _ocbBloc.add(
                        OnApplyFilterAndSortInOCB(
                          sortBy: sort,
                          filterBy: filter,
                        ),
                      );
                    }
                    log(sort);
                    log(filter.toString());
                  },
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: VColors.WHITE,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade400, Colors.blue.shade600],
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        labelStyle: VStyle.style(
          context: context,
          fontWeight: FontWeight.bold,
          size: 16,
          color: VColors.WHITE,
        ),
        unselectedLabelStyle: VStyle.style(
          context: context,
          fontWeight: FontWeight.w500,
          size: 16,
          color: Colors.grey[600],
        ),
        labelColor: VColors.WHITE,
        unselectedLabelColor: Colors.grey[600],
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        splashFactory: NoSplash.splashFactory,
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        tabs: const [
          Tab(
            height: 50,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.gavel_outlined, size: 20),
                SizedBox(width: 8),
                Text("Auctions"),
              ],
            ),
          ),
          Tab(
            height: 50,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.shopping_cart_outlined, size: 20),
                SizedBox(width: 8),
                Text("OCB"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
