import 'package:flutter/material.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_colors.dart';
import 'package:wheels_kart/module/Dealer/core/v_style.dart';
import 'package:wheels_kart/module/Dealer/features/widgets/v_custom_backbutton.dart';

class VDocumentsScreen extends StatelessWidget {
  const VDocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: VColors.WHITE,
        leading: VCustomBackbutton(blendColor: VColors.DARK_GREY.withAlpha(50)),
        centerTitle: false,
        title: Text(
          "Documents",
          style: VStyle.style(
            context: context,
            color: VColors.BLACK,
            fontWeight: FontWeight.w700,
            size: 20,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) => Container(),
      ),
    );
  }
}
