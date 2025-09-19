import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wheels_kart/common/components/app_spacer.dart';
import 'package:wheels_kart/common/dimensions.dart';
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
  int tabIndex = 0;

  // Sample vehicle data

  Set<String> favoriteVehicles = {};
  bool isScrolled = false;
  // create bloc fields so they live across rebuilds
  late final VAuctionControlllerBloc _auctionBloc;
  late final VOcbControllerBloc _ocbBloc;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _auctionBloc = VAuctionControlllerBloc();
    _ocbBloc = VOcbControllerBloc();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
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
        // _auctionBloc = VAuctionControlllerBloc();
        // _ocbBloc = VOcbControllerBloc();
        setState(() {});
        log("CurrentPage Tab - $tabIndex");
      });
    });
    context.read<FilterAcutionAndOcbCubit>().initWithFilterData(context);
  }

  @override
  void dispose() {
    _auctionBloc.close();
    _ocbBloc.close();
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
        backgroundColor: VColors.WHITEBGCOLOR,
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: VColors.WHITE,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome back,",
                style: VStyle.style(
                  context: context,
                  color: VColors.GREY,
                  fontWeight: FontWeight.w300,
                  size: AppDimensions.fontSize15(context),
                ),
              ),
              AppSpacer(heightPortion: .005),
              BlocBuilder<VProfileControllerCubit, VProfileControllerState>(
                builder: (context, state) {
                  return Text(
                    state is VProfileControllerSuccessState
                        ? state.profileModel.vendorName
                        : "",
                    style: VStyle.style(
                      context: context,
                      color: VColors.REDHARD,
                      fontWeight: FontWeight.bold,
                      size: AppDimensions.fontSize24(context),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            FilterAndSortWidget(
              onFiltersAndSortApplied: (filter, sort) {
                if (tabIndex == 0) {
                  _auctionBloc.add(
                    OnApplyFilterAndSort(sortBy: sort, filterBy: filter),
                  );
                } else {
                  
                }
                log(sort);
                log(filter.toString());
              },
            ),

            Expanded(
              child: DefaultTabController(
                initialIndex: tabIndex,
                length: 2,
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(color: VColors.WHITE),
                      child: TabBar(
                        controller: _tabController,
                        labelStyle: VStyle.style(
                          context: context,
                          fontWeight: FontWeight.bold,
                          size: 15,
                          color: VColors.SECONDARY,
                        ),
                        unselectedLabelStyle: VStyle.style(
                          context: context,
                          size: 15,
                        ),
                        dividerHeight: 2,
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicatorWeight: 3,

                        indicatorColor: VColors.SECONDARY,
                        overlayColor: WidgetStatePropertyAll(VColors.WHITE),
                        tabs: [Tab(text: "Auctions"), Tab(text: "OCB")],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          // BlocProvider(
                          //   create: (context) => VAuctionControlllerBloc(),
                          //   child:
                          VAuctionCarBuilder(),
                          // ),
                          // BlocProvider(
                          //   create: (context) => VOcbControllerBloc(),
                          //   child:
                          VOCBCarBuilder(),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
