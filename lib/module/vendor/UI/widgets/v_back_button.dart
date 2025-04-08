import 'package:flutter/material.dart';
import 'package:wheels_kart/core/constant/colors.dart';

class VBackButton extends StatelessWidget {
  final void Function()? onTap;
  const VBackButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? () => Navigator.pop(context),
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.BORDER_COLOR),
        ),
        child: Icon(
          Icons.arrow_back_ios_new,
          color: AppColors.DARK_PRIMARY,
          size: 20,
        ),
      ),
    );
  }
}
