import 'package:flutter/material.dart';
import 'package:wheels_kart/core/constant/colors.dart';
import 'package:wheels_kart/core/constant/dimensions.dart';
import 'package:wheels_kart/core/constant/style.dart';

class BuildCheckBox extends StatelessWidget {
  final String title;
  final bool isSelected;
  final void Function(bool?)? onChanged;

  const BuildCheckBox({
    super.key,
    required this.title,
    required this.isSelected,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile( 
    
      side: BorderSide(color: AppColors.grey),
      shape: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.grey.withOpacity(.4)),
        borderRadius: BorderRadius.circular(AppDimensions.radiusSize10),
      ),
      fillColor: isSelected ? WidgetStatePropertyAll(AppColors.black) : null,
      checkColor: AppColors.white,
    
      overlayColor: WidgetStatePropertyAll(AppColors.kAppSecondaryColor),
    
      tileColor: isSelected ? AppColors.kSelectionColor : null,
      checkboxShape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusSize5),
      ),
      enableFeedback: true,
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingSize10,
      ),
      value: isSelected,
      onChanged: onChanged,
      title: Text(
        title,
        style: AppStyle.style(
          size: AppDimensions.fontSize15(context),
          context: context,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
