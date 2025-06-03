import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_colors.dart';
import 'package:wheels_kart/common/dimensions.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_style.dart';
import 'package:wheels_kart/common/components/app_spacer.dart';

class EvAppCustomTextfield extends StatelessWidget {
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
  final TextStyle ?lebelStyle;

  EvAppCustomTextfield({
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
    this.fillColor, this.lebelStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labeltext ?? '',
          style:lebelStyle?? EvAppStyle.style(
            context: context,
            size: AppDimensions.fontSize15(context),
            color: EvAppColors.DEFAULT_BLUE_DARK,
            fontWeight: FontWeight.w600,
          ),
        ),
        // const AppSpacer(heightPortion: ),
        TextFormField(
          
          onChanged: onChanged,
          maxLines: maxLine ?? 1,
          textCapitalization:
              isTextCapital == null
                  ? TextCapitalization.none
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
          style: EvAppStyle.style(
            context: context,
            color: EvAppColors.black,
            fontWeight: fontWeght ?? FontWeight.w500,
            size: AppDimensions.fontSize18(context),
          ),
          cursorColor: focusColor ?? EvAppColors.DEFAULT_BLUE_GREY,
          decoration: InputDecoration(
            filled: fillColor != null,
            fillColor: fillColor,
            errorStyle: EvAppStyle.style(context: context, color: EvAppColors.kRed),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 10,
            ),
            // prefixIconConstraints: BoxConstraints(minWidth: 60),

            // suffixIconConstraints: BoxConstraints(minWidth: 60),
            suffixIcon: suffixIcon,

            suffixIconColor: EvAppColors.grey,
            prefixIcon: prefixIcon,
            prefixIconColor: EvAppColors.DEFAULT_BLUE_GREY,
            enabledBorder: OutlineInputBorder(
              borderRadius:
                  borderRudius != null
                      ? BorderRadius.all(Radius.circular(borderRudius!))
                      : BorderRadius.all(Radius.circular(4.0)),
              borderSide: BorderSide(width: 1, color: EvAppColors.grey),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius:
                  borderRudius != null
                      ? BorderRadius.all(Radius.circular(borderRudius!))
                      : BorderRadius.all(Radius.circular(4.0)),
              borderSide: BorderSide(width: 1.5, color: EvAppColors.kRed),
            ),
            focusedErrorBorder: OutlineInputBorder(
              // borderRadius: BorderRadius.all(
              //   Radius.circular(AppDimensions.radiusSize10),
              // ),
              borderRadius:
                  borderRudius != null
                      ? BorderRadius.all(Radius.circular(borderRudius!))
                      : BorderRadius.all(Radius.circular(4.0)),
              borderSide: BorderSide(width: 1.5, color: EvAppColors.kRed),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius:
                  borderRudius != null
                      ? BorderRadius.all(Radius.circular(borderRudius!))
                      : BorderRadius.all(Radius.circular(4.0)),
              borderSide: BorderSide(
                width: 2,
                color: focusColor ?? EvAppColors.DEFAULT_BLUE_GREY,
              ),
            ),
            hintText: hintText,
            hintStyle: EvAppStyle.style(
              fontWeight: FontWeight.w400,
              size: AppDimensions.fontSize16(context),
              context: context,
              color: EvAppColors.grey,
            ),
          ),
        ),
        const AppSpacer(heightPortion: .015),
      ],
    );
  }
}
