import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:wheels_kart/core/constant/colors.dart';
import 'package:wheels_kart/core/constant/dimensions.dart';
import 'package:wheels_kart/core/constant/style.dart';

class AppAppbar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(50.0);
  final String title;
  const AppAppbar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: InkWell(
        child: Icon(color: AppColors.kWhite, SolarIconsOutline.altArrowLeft),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      title: Text(
        title,
        style: AppStyle.style(
          fontWeight: FontWeight.w600,
          size: AppDimensions.paddingSize15,
          context: context,
          color: AppColors.kWhite,
        ),
      ),
      backgroundColor: AppColors.DEFAULT_BLUE_DARK,
    );
  }
}
