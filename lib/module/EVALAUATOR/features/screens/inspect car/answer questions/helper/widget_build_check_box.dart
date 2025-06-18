import 'package:flutter/material.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_colors.dart';
import 'package:wheels_kart/common/dimensions.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_style.dart';

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
      
      side: BorderSide(color: EvAppColors.grey),
      shape: OutlineInputBorder(
        borderSide: BorderSide(color: EvAppColors.grey.withOpacity(.4)),
        borderRadius: BorderRadius.circular(AppDimensions.radiusSize10),
      ),
      fillColor: isSelected ? WidgetStatePropertyAll(EvAppColors.black) : null,
      checkColor: EvAppColors.white,

      overlayColor: WidgetStatePropertyAll(EvAppColors.kAppSecondaryColor),

      tileColor: isSelected ? EvAppColors.kSelectionColor : null,
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
        style: EvAppStyle.style(
          size: AppDimensions.fontSize15(context),
          context: context,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
