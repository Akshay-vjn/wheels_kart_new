import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wheels_kart/module/VENDOR/core/const/v_colors.dart';
import 'package:wheels_kart/module/VENDOR/core/v_style.dart';
import 'package:wheels_kart/module/VENDOR/data/blocs/v%20nav%20controller/v_nav_controller_cubit.dart';
import 'package:wheels_kart/module/VENDOR/features/account/v_account_tab.dart';
import 'package:wheels_kart/module/VENDOR/features/favorates/v_fav_tab.dart';
import 'package:wheels_kart/module/VENDOR/features/home/home_tab.dart';
import 'package:wheels_kart/module/VENDOR/features/my%20orders/v_my_order_tab.dart';

class VNavScreen extends StatelessWidget {
  const VNavScreen({super.key});
  static List<Widget> tabs = [
    VHomeTab(),
    VFavTab(),
    VMyOrderTab(),
    VAccountTab(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: VColors.WHITEBGCOLOR,
      body: BlocBuilder<VNavControllerCubit, VNavControllerState>(
        builder: (context, state) => tabs[state.currentIndex],
      ),
      bottomNavigationBar:
          BlocBuilder<VNavControllerCubit, VNavControllerState>(
            builder:
                (context, state) => BottomNavigationBar(
                  backgroundColor: VColors.WHITE,
                  selectedItemColor: VColors.GREENHARD,
                  unselectedItemColor: VColors.GREYHARD,
                  unselectedLabelStyle: VStyle.style(context: context),
                  selectedLabelStyle: VStyle.style(
                    context: context,
                    color: VColors.GREENHARD,
                    fontWeight: FontWeight.bold,
                  ),
                  currentIndex: state.currentIndex,
                  onTap: (value) {
                    context.read<VNavControllerCubit>().onChangeNav(value);
                  },
                  items: [
                    BottomNavigationBarItem(
                      label: "Live",
                      activeIcon: Icon(CupertinoIcons.wand_stars),
                      icon: Icon(CupertinoIcons.wand_stars_inverse),
                    ),
                    BottomNavigationBarItem(
                      label: "Wishlist",

                      activeIcon: Icon(CupertinoIcons.heart_fill),
                      icon: Icon(CupertinoIcons.heart),
                    ),
                    BottomNavigationBarItem(
                      label: "My Order",
                      activeIcon: Icon(CupertinoIcons.list_dash),
                      icon: Icon(CupertinoIcons.list_bullet),
                    ),
                    BottomNavigationBarItem(
                      label: "Account",
                      activeIcon: Icon(CupertinoIcons.person_fill),
                      icon: Icon(CupertinoIcons.person),
                    ),
                  ],
                ),
          ),
    );
  }
}
