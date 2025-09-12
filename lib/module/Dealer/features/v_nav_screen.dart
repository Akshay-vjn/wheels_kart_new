import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wheels_kart/common/utils/responsive_helper.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_colors.dart';
import 'package:wheels_kart/module/Dealer/core/v_style.dart';
import 'package:wheels_kart/module/Dealer/features/screens/account/data/controller/profile%20controller/v_profile_controller_cubit.dart';
import 'package:wheels_kart/module/Dealer/features/screens/account/screens/v_account_tab.dart';
import 'package:wheels_kart/module/Dealer/features/screens/favorates/data/controller/wishlist%20controller/v_wishlist_controller_cubit.dart';
import 'package:wheels_kart/module/Dealer/features/screens/favorates/screens/v_fav_tab.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/screens/home_tab.dart';
import 'package:wheels_kart/module/Dealer/core/blocs/v%20nav%20controller/v_nav_controller_cubit.dart';
import 'package:wheels_kart/module/Dealer/features/screens/my%20auction%20and%20ocb/screens/v_mybid_screen.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/widgets/ev_app_loading_indicator.dart';

String CURRENT_DEALER_ID = "";

class VNavScreen extends StatefulWidget {
  const VNavScreen({super.key});
  static List<Widget> tabs = [
    VHomeTab(),
    BlocProvider<VWishlistControllerCubit>(
      create: (context) => VWishlistControllerCubit(),
      child: VFavTab(),
    ),
    VMyBidTab(),
    VAccountTab(),
  ];

  @override
  State<VNavScreen> createState() => _VNavScreenState();
}

class _VNavScreenState extends State<VNavScreen> {
  @override
  void initState() {
    context.read<VProfileControllerCubit>().onFetchProfile(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: Platform.isAndroid,
      child: Scaffold(
        backgroundColor: VColors.WHITEBGCOLOR,
        body: BlocConsumer<VProfileControllerCubit, VProfileControllerState>(
          listener: (context, state) {
            if (state is VProfileControllerSuccessState) {
              CURRENT_DEALER_ID = state.profileModel.vendorId;
            }
          },
          builder: (context, state) {
            if (state is VProfileControllerSuccessState) {
              return BlocBuilder<VNavControllerCubit, VNavControllerState>(
                builder:
                    (context, state) => VNavScreen.tabs[state.currentIndex],
              );
            }

            return Center(child: EVAppLoadingIndicator());
          },
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: VColors.WHITE,
            boxShadow: [
              BoxShadow(
                color: VColors.BLACK.withAlpha(50),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          height: Platform.isAndroid ? h(context) * .09 : null,
          width: w(context),
          child: BlocBuilder<VNavControllerCubit, VNavControllerState>(
            builder:
                (context, state) => BottomNavigationBar(
                  backgroundColor: VColors.WHITE,
                  selectedItemColor: VColors.SECONDARY,
                  unselectedItemColor: VColors.GREYHARD,
                  showSelectedLabels: true,
                  showUnselectedLabels: true,
                  unselectedLabelStyle: VStyle.style(
                    context: context,
                    color: VColors.SECONDARY,
                    fontWeight: FontWeight.bold,
                  ),
                  selectedLabelStyle: VStyle.style(
                    context: context,
                    color: VColors.SECONDARY,
                    fontWeight: FontWeight.bold,
                  ),
                  currentIndex: state.currentIndex,
                  onTap: (value) {
                    context.read<VNavControllerCubit>().onChangeNav(value);
                  },
                  items: [
                    BottomNavigationBarItem(
                      label: "Cars",
                      activeIcon: Icon(CupertinoIcons.wand_stars),
                      icon: Icon(CupertinoIcons.wand_stars_inverse),
                    ),
                    BottomNavigationBarItem(
                      label: "For You",

                      activeIcon: Icon(CupertinoIcons.heart_fill),
                      icon: Icon(CupertinoIcons.heart),
                    ),
                    BottomNavigationBarItem(
                      label: "History",

                      activeIcon: Icon(CupertinoIcons.square_list_fill),
                      icon: Icon(CupertinoIcons.list_bullet),
                    ),
                    // BottomNavigationBarItem(
                    //   label: "My Order",
                    //   activeIcon: Icon(CupertinoIcons.list_dash),
                    //   icon: Icon(CupertinoIcons.list_bullet),
                    // ),
                    BottomNavigationBarItem(
                      label: "Account",
                      activeIcon: Icon(CupertinoIcons.person_fill),
                      icon: Icon(CupertinoIcons.person),
                    ),
                  ],
                ),
          ),
        ),
      ),
    );
  }
}
