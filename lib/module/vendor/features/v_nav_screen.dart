import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wheels_kart/common/utils/responsive_helper.dart';
import 'package:wheels_kart/module/VENDOR/core/const/v_colors.dart';
import 'package:wheels_kart/module/VENDOR/core/v_style.dart';
import 'package:wheels_kart/module/VENDOR/helper/blocs/v%20nav%20controller/v_nav_controller_cubit.dart';
import 'package:wheels_kart/module/VENDOR/features/screens/account/v_account_tab.dart';
import 'package:wheels_kart/module/VENDOR/features/screens/favorates/v_fav_tab.dart';

import 'screens/home/screens/home_tab.dart';

class VNavScreen extends StatelessWidget {
  const VNavScreen({super.key});
  static List<Widget> tabs = [VHomeTab(), VFavTab(), VAccountTab()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VColors.WHITEBGCOLOR,
      body: BlocBuilder<VNavControllerCubit, VNavControllerState>(
        builder: (context, state) => tabs[state.currentIndex],
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
                unselectedLabelStyle: VStyle.style(context: context),
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
    );
  }
}
