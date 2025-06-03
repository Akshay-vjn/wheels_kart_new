import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_colors.dart';
import 'package:wheels_kart/common/dimensions.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_style.dart';
import 'package:wheels_kart/common/components/app_spacer.dart';

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
        const Icon(Iconsax.search_normal, color: EvAppColors.white),
        const AppSpacer(widthPortion: .05),
        Expanded(
          child: TextFormField(
            keyboardType: keyboardType,
            controller: controller,
            onChanged: onChanged,
            textCapitalization: TextCapitalization.words,
            cursorColor: EvAppColors.white,
            style: EvAppStyle.style(
              context: context,
              color: EvAppColors.white,
              fontWeight: FontWeight.w500,
              size: AppDimensions.fontSize15(context),
            ),
            decoration: InputDecoration(
              hintText: '  $hintText',
              hintStyle: EvAppStyle.style(
                color: EvAppColors.white,
                context: context,
                fontWeight: FontWeight.w500,
                size: AppDimensions.fontSize15(context),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: EvAppColors.white),
                borderRadius: BorderRadius.all(
                  Radius.circular(AppDimensions.radiusSize10),
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(width: 1.5, color: EvAppColors.white),
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
