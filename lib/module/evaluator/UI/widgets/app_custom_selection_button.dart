import 'package:flutter/material.dart';
import 'package:wheels_kart/core/constant/colors.dart';
import 'package:wheels_kart/core/constant/dimensions.dart';

class EvAppCustomeSelctionButton extends StatelessWidget {
  final void Function()? onTap;
  final int? selectedButtonIndex;
  final int currentIndex;
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
          gradient:
              isButtonBorderView == true
                  ? null
                  : selectedButtonIndex != null &&
                      selectedButtonIndex == currentIndex
                  ? const LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.DEFAULT_BLUE_GREY,
                      AppColors.DEFAULT_BLUE_DARK,
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
                        ? AppColors.DEFAULT_BLUE_GREY
                        : AppColors.kBlack
                    : AppColors.DEFAULT_BLUE_GREY,
          ),
        ),
        child: child,
      ),
    );
  }
}
