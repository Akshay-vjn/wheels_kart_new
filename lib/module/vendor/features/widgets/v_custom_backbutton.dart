import 'package:flutter/material.dart';
import 'package:wheels_kart/module/vendor/core/const/v_colors.dart';

class VCustomBackbutton extends StatelessWidget {
  final Color? blendColor;
  const VCustomBackbutton({super.key, this.blendColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: InkWell(
        overlayColor: WidgetStatePropertyAll(Colors.transparent),
        onTap: () {
          Navigator.of(context).pop();
        },
        child: CircleAvatar(
          backgroundColor: blendColor ?? VColors.WHITE.withAlpha(50),
          child: Icon(
            size: 19,
            Icons.arrow_back_ios_new_outlined,
            color: VColors.WHITE,
          ),
        ),
      ),
    );
  }
}
