import 'package:flutter/material.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_colors.dart';
import 'package:wheels_kart/common/dimensions.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_style.dart';

class BuildAnswerSelectionButton extends StatelessWidget {
  final bool isSelected;
  final String title;
  final Color activeColor;
  final Color inActiveColor;
  final bool? isOutlined;
  final void Function()? onTap;

  const BuildAnswerSelectionButton({
    super.key,
    required this.isSelected,
    required this.title,
    this.isOutlined,
    required this.activeColor,
    required this.inActiveColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      overlayColor: WidgetStatePropertyAll(Colors.transparent),
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: AppDimensions.paddingSize10),
        padding: EdgeInsets.symmetric(
          vertical: AppDimensions.paddingSize10,
          horizontal: AppDimensions.paddingSize20,
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border:
              isOutlined == true
                  ? Border.all(
                    color: isSelected ? activeColor : inActiveColor,
                    width: 3,
                  )
                  : Border.all(
                    color: EvAppColors.black.withOpacity(.8),
                    width: 2,
                  ),
          borderRadius: BorderRadius.circular(AppDimensions.radiusSize50),
          color:
              isOutlined == true
                  ? EvAppColors.white
                  : isSelected
                  ? activeColor
                  : inActiveColor,
        ),
        child: Text(
          title,
          style: EvAppStyle.style(
            context: context,
            fontWeight: FontWeight.w600,
            size: AppDimensions.fontSize18(context),
            color:
                isOutlined == true
                    ? isSelected
                        ? activeColor
                        : inActiveColor
                    : isSelected
                    ? EvAppColors.white
                    : EvAppColors.black.withOpacity(.8),
          ),
        ),
      ),
    );
  }
}
