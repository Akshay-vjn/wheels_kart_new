import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wheels_kart/common/components/app_spacer.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_colors.dart';
import 'package:wheels_kart/module/Dealer/core/v_style.dart';
import 'package:wheels_kart/module/Dealer/features/screens/account/screens/my%20bid/v_mybid_screen.dart';

class HighlistTab extends StatelessWidget {
  const HighlistTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 10,
      separatorBuilder: (context, index) => AppSpacer(heightPortion: .01),
      padding: EdgeInsets.only(top: 10, left: 10, right: 10),
      itemBuilder: (context, index) {
        return Container(
          // padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: VColors.WHITE,
            border: Border.all(width: .5, color: VColors.GREENHARD),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(child: VMybidScreen.buildImageSection('', "1")),
                  AppSpacer(widthPortion: .02),
                  Flexible(
                    child: VMybidScreen.buildHeader(
                      context,
                      "2012",
                      "Maruthi",
                      "Swift",
                      "Kerala",
                      '1',
                    ),
                  ),
                  AppSpacer(widthPortion: .02),
                ],
              ),
              Padding(
                padding: EdgeInsetsGeometry.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Your Bid",
                          style: VStyle.style(
                            context: context,
                            color: VColors.GREENHARD.withAlpha(200),
                          ),
                        ),
                        Text(
                          "₹10000",
                          style: VStyle.style(
                            context: context,
                            size: 20,
                            color: VColors.GREENHARD,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: VColors.SECONDARY,
                        foregroundColor: VColors.WHITE,
                      ),
                      onPressed: () {},
                      child: Text("View Details"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
