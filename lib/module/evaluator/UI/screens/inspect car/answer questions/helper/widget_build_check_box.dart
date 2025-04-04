import 'package:flutter/material.dart';
import 'package:wheels_kart/core/constant/colors.dart';
import 'package:wheels_kart/core/constant/dimensions.dart';
import 'package:wheels_kart/core/constant/style.dart';

class BuildCheckBox extends StatelessWidget {
  final String title;
  final bool isSelected;
  final void Function(bool?)? onChanged;

  const BuildCheckBox(
      {super.key,
      required this.title,
      required this.isSelected,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: CheckboxListTile(
        // hoverColor: AppColors.kGreen,
        side: BorderSide(
          color: AppColors.kGrey,
        ),
        shape: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.kGrey.withOpacity(.4)),
          borderRadius: BorderRadius.circular(
            AppDimensions.radiusSize10,
          ),
        ),
        fillColor: isSelected ? WidgetStatePropertyAll(AppColors.kBlack) : null,
        checkColor: AppColors.kWhite,

        overlayColor: WidgetStatePropertyAll(AppColors.kAppSecondaryColor),

        tileColor: isSelected ? AppColors.kSelectionColor : null,
        checkboxShape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusSize5)),
        enableFeedback: true,
        contentPadding:
            EdgeInsets.symmetric(horizontal: AppDimensions.paddingSize10),
        value: isSelected,
        onChanged: onChanged,
        title: Text(
          title,
          style: AppStyle.style(
              size: AppDimensions.fontSize15(context),
              context: context,
              fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
