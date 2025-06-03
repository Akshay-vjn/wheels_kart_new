import 'package:flutter/material.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_colors.dart';
import 'package:wheels_kart/common/dimensions.dart';

class EvAppCustomeSelctionButton extends StatelessWidget {
  final void Function()? onTap;
  final int? selectedButtonIndex;
  final int currentIndex;
  // final bool? isFilled;
  final Color? fillColor;
  // final List data;

  final Widget child;
  bool? isButtonBorderView = false;

  EvAppCustomeSelctionButton({
    super.key,
    required this.currentIndex,
    required this.onTap,
    // required this.data,
    required this.selectedButtonIndex,
    this.isButtonBorderView,
    required this.child,
    // this.isFilled,
    this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: AppDimensions.paddingSize10,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: AppDimensions.paddingSize15,
        ),
        decoration: BoxDecoration(
          color: fillColor,

          gradient:
              isButtonBorderView == true
                  ? null
                  : selectedButtonIndex != null &&
                      selectedButtonIndex == currentIndex
                  ? const LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomRight,
                    colors: [
                      EvAppColors.DEFAULT_BLUE_GREY,
                      EvAppColors.DEFAULT_BLUE_DARK,
                    ],
                  )
                  : null,
          borderRadius: BorderRadius.circular(AppDimensions.radiusSize5),
          border: Border.all(
            width:
                isButtonBorderView == true
                    ? (selectedButtonIndex != null &&
                            selectedButtonIndex == currentIndex)
                        ? 2
                        : 0
                    : 0,
            color:
                isButtonBorderView == true
                    ? (selectedButtonIndex != null &&
                            selectedButtonIndex == currentIndex)
                        ? EvAppColors.DEFAULT_BLUE_GREY
                        : EvAppColors.black
                    : EvAppColors.DEFAULT_BLUE_GREY,
          ),
        ),
        child: child,
      ),
    );
  }
}
