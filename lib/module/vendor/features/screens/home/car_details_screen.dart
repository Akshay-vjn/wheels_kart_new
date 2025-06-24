import 'package:flutter/material.dart';
import 'package:wheels_kart/common/dimensions.dart';
import 'package:wheels_kart/module/VENDOR/core/const/v_colors.dart';
import 'package:wheels_kart/module/VENDOR/core/v_style.dart';
import 'package:wheels_kart/module/VENDOR/features/widgets/v_custom_backbutton.dart';

class VCarDetailsScreen extends StatelessWidget {
  const VCarDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VColors.WHITEBGCOLOR,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: VColors.WHITE,
            leading: VCustomBackbutton(blendColor: VColors.BLACK.withAlpha(50),),
            centerTitle: false,
            title: Text(
              "Hundai",
              style: VStyle.style(
                context: context,
                size: AppDimensions.fontSize18(context),
                color: VColors.BLACK,
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            sliver: SliverList(
              delegate: SliverChildListDelegate.fixed([Text("data")]),
            ),
          ),
        ],
      ),
    );
  }
}
