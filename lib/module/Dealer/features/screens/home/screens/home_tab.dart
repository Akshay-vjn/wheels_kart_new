import 'dart:developer';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wheels_kart/common/components/app_spacer.dart';
import 'package:wheels_kart/common/controllers/auth%20cubit/auth_cubit.dart';
import 'package:wheels_kart/common/dimensions.dart';
import 'package:wheels_kart/common/utils/responsive_helper.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_colors.dart';
import 'package:wheels_kart/module/Dealer/core/v_style.dart';
import 'package:wheels_kart/module/Dealer/features/screens/account/data/controller/profile%20controller/v_profile_controller_cubit.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/controller/v%20dashboard%20controller/v_dashboard_controlller_bloc.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/screens/widgets/car_card_builder.dart';

class VHomeTab extends StatefulWidget {
  const VHomeTab({super.key});

  @override
  State<VHomeTab> createState() => _VHomeTabState();
}

class _VHomeTabState extends State<VHomeTab> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Sample vehicle data

  Set<String> favoriteVehicles = {};
  bool isScrolled = false;
  @override
  void initState() {
    super.initState();
    // WEB SOCKET COONECTION
    context.read<VDashboardControlllerBloc>().add(ConnectWebSocket());

    //
    context.read<VProfileControllerCubit>().onFetchProfile(context);
    context.read<VDashboardControlllerBloc>().add(
      OnFetchVendorDashboardApi(context: context),
    );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _scrollController.addListener(() {
        if (_scrollController.offset > 0) {
          isScrolled = true;
        } else {
          isScrolled = false;
        }
        setState(() {});
      });
    });
    getSoldUserData();
  }

  getSoldUserData() async {
    final user = await AppAuthController().getUserData;
    myId = user.userId ?? '';
    log("Your id is $myId");
  }

  String myId = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VColors.WHITEBGCOLOR,
      body: RefreshIndicator.adaptive(
        onRefresh: () async {
          return context.read<VDashboardControlllerBloc>().add(
            OnFetchVendorDashboardApi(context: context),
          );
        },
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              surfaceTintColor: VColors.WHITE,
              automaticallyImplyLeading: false,
              // expandedHeight: h(context) * .15,
              toolbarHeight: h(context) * .08,
              floating: false,
              pinned: true,
              elevation: 5,
              backgroundColor: VColors.WHITE,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
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
                      BlocBuilder<
                        VProfileControllerCubit,
                        VProfileControllerState
                      >(
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

                  // isScrolled
                  //     ? Padding(
                  //       padding: const EdgeInsets.symmetric(horizontal: 5),
                  //       child: FadeIn(child: _buildNotificationButton()),
                  //     )
                  //     : SizedBox(),
                ],
              ),
              // flexibleSpace: FlexibleSpaceBar(
              //   // collapseMode: CollapseMode.parallax,
              //   centerTitle: false,
              //   titlePadding: EdgeInsets.all(20),

              //   background: SafeArea(
              //     child: Padding(
              //       padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              //       child: Row(
              //         crossAxisAlignment: CrossAxisAlignment.end,
              //         children: [
              //           Expanded(
              //             child: Container(
              //               height: 50,
              //               decoration: BoxDecoration(
              //                 color: VColors.WHITE,
              //                 borderRadius: BorderRadius.circular(25),
              //                 boxShadow: [
              //                   BoxShadow(
              //                     color: VColors.GREENHARD.withAlpha(50),
              //                     blurRadius: 8,
              //                     offset: const Offset(0, 2),
              //                   ),
              //                 ],
              //               ),
              //               child: TextField(
              //                 controller: _searchController,
              //                 decoration: const InputDecoration(
              //                   hintText: 'Search vehicles...',
              //                   prefixIcon: Icon(
              //                     Icons.search,
              //                     color: VColors.DARK_GREY,
              //                   ),
              //                   border: InputBorder.none,
              //                   contentPadding: EdgeInsets.symmetric(
              //                     horizontal: 20,
              //                     vertical: 15,
              //                   ),
              //                 ),
              //               ),
              //             ),
              //           ),
              //           const SizedBox(width: 12),
              //           _buildNotificationButton(),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
            ),

            // Vehicle List
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),

              sliver: VCarCardBuilder(myId: myId,),
            ),

            // Bottom padding
            // const SliverToBoxAdapter(child: SizedBox(height: 10)),
          ],
        ),
      ),
    );
  }
}

Widget _buildNotificationButton() => Container(
  height: 50,
  width: 50,
  decoration: BoxDecoration(
    color: VColors.WHITE,
    borderRadius: BorderRadius.circular(25),
    boxShadow: [
      BoxShadow(
        color: VColors.SECONDARY.withAlpha(50),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  ),
  child: IconButton(
    onPressed: () {
      // Handle notification tap
    },
    icon: const Icon(Icons.notifications_outlined, color: VColors.SECONDARY),
  ),
);
