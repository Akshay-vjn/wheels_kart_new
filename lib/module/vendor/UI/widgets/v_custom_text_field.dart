import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wheels_kart/core/constant/colors.dart';
import 'package:wheels_kart/core/constant/dimensions.dart';
import 'package:wheels_kart/core/constant/style.dart';
import 'package:wheels_kart/core/components/app_spacer.dart';

class VAppCustomTextfield extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labeltext;
  final bool? isObsecure;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextInputType? keyBoardType;
  final String? Function(String?)? validator;
  final int? maxLenght;
  final int? maxLine;
  final FontWeight? fontWeght;
  bool? isTextCapital;
  final Color? focusColor;
  final void Function(String)? onChanged;
  final double? borderRudius;
  final Color? fillColor;

  VAppCustomTextfield({
    super.key,
    this.onChanged,
    this.prefixIcon,
    this.fontWeght,
    this.focusColor,
    this.controller,
    this.maxLenght,
    this.hintText,
    this.labeltext,
    this.isObsecure,
    this.keyBoardType,
    this.suffixIcon,
    this.validator,
    this.isTextCapital,
    this.maxLine,
    this.borderRudius,
    this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labeltext ?? '',
          style: AppStyle.style(
            context: context,
            size: AppDimensions.fontSize15(context),
            color: AppColors.DEFAULT_BLUE_DARK,
            fontWeight: FontWeight.w600,
          ),
        ),
        const AppSpacer(heightPortion: .01),
        TextFormField(
          onChanged: onChanged,
          maxLines: maxLine ?? 1,
          textCapitalization:
              isTextCapital == null
                  ? TextCapitalization.words
                  : isTextCapital == true
                  ? TextCapitalization.characters
                  : TextCapitalization.sentences,
          inputFormatters:
              maxLenght == null
                  ? []
                  : [LengthLimitingTextInputFormatter(maxLenght)],
          validator: validator,
          keyboardType: keyBoardType,
          obscureText: isObsecure ?? false,
          controller: controller,
          style: AppStyle.style(
            context: context,
            color: AppColors.DEFAULT_BLUE_GREY,
            fontWeight: fontWeght ?? FontWeight.bold,
            size: AppDimensions.fontSize18(context),
          ),
          cursorColor: focusColor ?? AppColors.DEFAULT_BLUE_GREY,
          decoration: InputDecoration(
            filled: fillColor != null,
            fillColor: fillColor,
            errorStyle: AppStyle.style(context: context, color: AppColors.kRed),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 10,
            ),
            // prefixIconConstraints: BoxConstraints(minWidth: 60),

            // suffixIconConstraints: BoxConstraints(minWidth: 60),
            suffixIcon: suffixIcon,

            suffixIconColor: AppColors.grey,
            prefixIcon: prefixIcon,
            prefixIconColor: AppColors.DEFAULT_BLUE_GREY,
            enabledBorder: OutlineInputBorder(
              borderRadius:
                  borderRudius != null
                      ? BorderRadius.all(Radius.circular(borderRudius!))
                      : BorderRadius.all(Radius.circular(4.0)),
              borderSide: BorderSide(width: 1, color: AppColors.grey),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius:
                  borderRudius != null
                      ? BorderRadius.all(Radius.circular(borderRudius!))
                      : BorderRadius.all(Radius.circular(4.0)),
              borderSide: BorderSide(width: 1.5, color: AppColors.kRed),
            ),
            focusedErrorBorder: OutlineInputBorder(
              // borderRadius: BorderRadius.all(
              //   Radius.circular(AppDimensions.radiusSize10),
              // ),
              borderRadius:
                  borderRudius != null
                      ? BorderRadius.all(Radius.circular(borderRudius!))
                      : BorderRadius.all(Radius.circular(4.0)),
              borderSide: BorderSide(width: 1.5, color: AppColors.kRed),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius:
                  borderRudius != null
                      ? BorderRadius.all(Radius.circular(borderRudius!))
                      : BorderRadius.all(Radius.circular(4.0)),
              borderSide: BorderSide(
                width: 2,
                color: focusColor ?? AppColors.DEFAULT_BLUE_GREY,
              ),
            ),
            hintText: hintText,
            hintStyle: AppStyle.style(
              fontWeight: FontWeight.w400,
              size: AppDimensions.fontSize16(context),
              context: context,
              color: AppColors.grey,
            ),
          ),
        ),
        const AppSpacer(heightPortion: .015),
      ],
    );
  }
}
