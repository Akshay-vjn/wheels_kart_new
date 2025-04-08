import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:wheels_kart/core/constant/colors.dart';
import 'package:wheels_kart/module/vendor/UI/screen/account/account_screen.dart';
import 'package:wheels_kart/module/vendor/UI/screen/feed/feed_screen.dart';
import 'package:wheels_kart/module/vendor/UI/screen/liked/liked_feed_sceen.dart';
import 'package:wheels_kart/module/vendor/UI/screen/my%20order/my_orders_screen.dart';
import 'package:wheels_kart/module/vendor/data/cubit/bottom_nav_controller/v_bottom_nav_controller_cubit.dart';

class VNavigationScreen extends StatelessWidget {
  VNavigationScreen({super.key});
  final _pages = [
    FeedScreen(),
    LikedFeedSceen(),
    MyOrdersScreen(),
    AccountScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VBottomNavControllerCubit, VBottomNavControllerState>(
      builder: (context, state) {
        return Scaffold(
          body: _pages[state.cuurentIndex],
          extendBody: true, //<------like this
          bottomNavigationBar: CrystalNavigationBar(
            currentIndex: state.cuurentIndex,
            onTap: context.read<VBottomNavControllerCubit>().onChanageNav,
            unselectedItemColor: Colors.white70,
            backgroundColor: AppColors.DARK_PRIMARY,
            // outlineBorderColor: Colors.black.withOpacity(0.1),
            borderWidth: 2,
            outlineBorderColor: Colors.white,
            items: [
              CrystalNavigationBarItem(
                icon: SolarIconsBold.feed,
                unselectedIcon: SolarIconsOutline.feed,
                selectedColor: Colors.white,
                // badge: Badge(
                //   label: Text("9+", style: TextStyle(color: Colors.white)),
                // ),
              ),

              /// Favourite
              CrystalNavigationBarItem(
                icon: SolarIconsBold.heart,
                unselectedIcon: SolarIconsOutline.heart,
                selectedColor: Colors.red,
              ),

              /// Add
              CrystalNavigationBarItem(
                icon: SolarIconsBold.postsCarouselHorizontal,
                unselectedIcon: SolarIconsOutline.postsCarouselHorizontal,
                selectedColor: Colors.white,
              ),

              /// Profile
              CrystalNavigationBarItem(
                icon: SolarIconsBold.user,
                unselectedIcon: SolarIconsOutline.user,
                selectedColor: Colors.white,
              ),
            ],
          ),
        );
      },
    );
  }
}
