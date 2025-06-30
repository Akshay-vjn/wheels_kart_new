import 'package:flutter/material.dart';
import 'package:wheels_kart/common/dimensions.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_colors.dart';
import 'package:wheels_kart/module/Dealer/core/v_style.dart';

class VCustomTexfield extends StatelessWidget {
  final String? title;
  final TextEditingController controller;
  final TextStyle? titleStyle;
  final String? hintText;
  final TextStyle? hintStyle;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const VCustomTexfield({
    super.key,
    this.title,
    required this.controller,
    this.titleStyle,
    this.hintText,
    this.hintStyle,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Text(
            title!,
            style:
                titleStyle ??
                VStyle.style(
                  context: context,
                  fontWeight: FontWeight.w600,
                  size: AppDimensions.fontSize15(context),
                ),
          ),
        TextFormField(
        textInputAction: TextInputAction.next,
          keyboardType: keyboardType,
          validator: validator,
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: hintStyle ?? VStyle.style(context: context),
            errorBorder: border(TextFieldState.ERROR),
            focusedErrorBorder: border(TextFieldState.ERROR),
            enabledBorder: border(TextFieldState.OUTOFFOCUS),
            focusedBorder: border(TextFieldState.FOCUSED),
            disabledBorder: border(TextFieldState.OUTOFFOCUS),
          ),
        ),
      ],
    );
  }

  UnderlineInputBorder border(TextFieldState state) {
    Color color;
    switch (state) {
      case TextFieldState.ERROR:
        {
          color = VColors.REDHARD;
        }
      case TextFieldState.FOCUSED:
        {
          color = VColors.SECONDARY;
        }
      case TextFieldState.OUTOFFOCUS:
        {
          color = VColors.DARK_GREY;
        }
    }
    return UnderlineInputBorder(borderSide: BorderSide(color: color));
  }
}

enum TextFieldState { ERROR, FOCUSED, OUTOFFOCUS }
