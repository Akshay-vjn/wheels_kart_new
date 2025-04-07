import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:wheels_kart/core/constant/colors.dart';
import 'package:wheels_kart/core/constant/dimensions.dart';
import 'package:wheels_kart/core/constant/style.dart';
import 'package:wheels_kart/core/components/app_spacer.dart';

class EvAppSearchField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final TextInputType? keyboardType;

  const EvAppSearchField({
    super.key,
    this.controller,
    required this.hintText,
    required this.onChanged,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Iconsax.search_normal, color: AppColors.white),
        const AppSpacer(widthPortion: .05),
        Expanded(
          child: TextFormField(
            keyboardType: keyboardType,
            controller: controller,
            onChanged: onChanged,
            textCapitalization: TextCapitalization.words,
            cursorColor: AppColors.white,
            style: AppStyle.style(
              context: context,
              color: AppColors.white,
              fontWeight: FontWeight.w500,
              size: AppDimensions.fontSize15(context),
            ),
            decoration: InputDecoration(
              hintText: '  $hintText',
              hintStyle: AppStyle.style(
                color: AppColors.white,
                context: context,
                fontWeight: FontWeight.w500,
                size: AppDimensions.fontSize15(context),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: AppColors.white),
                borderRadius: BorderRadius.all(
                  Radius.circular(AppDimensions.radiusSize10),
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(width: 1.5, color: AppColors.white),
                borderRadius: BorderRadius.all(
                  Radius.circular(AppDimensions.radiusSize10),
                ),
              ),
            ),
          ),
        ),
        // const AppSpacer(
        //   widthPortion: .02,
        // ),
        // const Icon(
        //   Iconsax.search_normal,
        //   color: AppColors.kWhite,
        // ),
      ],
    );
  }
}
