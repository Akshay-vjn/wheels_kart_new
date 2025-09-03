import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_colors.dart';
import 'package:wheels_kart/module/Dealer/core/v_style.dart';
import 'package:wheels_kart/module/Dealer/features/widgets/v_custom_backbutton.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_colors.dart';

class VTransactionScreen extends StatelessWidget {
  const VTransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: VColors.WHITE,
        leading: VCustomBackbutton(blendColor: VColors.DARK_GREY.withAlpha(50)),
        centerTitle: false,
        title: Text(
          "Transactions",
          style: VStyle.style(
            context: context,
            color: VColors.BLACK,
            fontWeight: FontWeight.w700,
            size: 20,
          ),
        ),
      ),
      body: ListView.builder(
        // separatorBuilder:
        //     (context, index) => Divider(color: EvAppColors.grey.withAlpha(100)),
        itemCount: 2,
        itemBuilder:
            (context, index) => ExpansionTile(
              shape: Border.all(color: EvAppColors.grey),
              collapsedShape: Border(),
              leading: CircleAvatar(
                backgroundColor: VColors.SUCCESS.withAlpha(50),
                child: Icon(
                  CupertinoIcons.money_dollar_circle,
                  color: EvAppColors.white,
                ),
              ),
              title: Text(
                "5246175",
                style: VStyle.style(
                  context: context,
                  size: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  "12/02/2003",
                  style: VStyle.style(
                    context: context,
                    size: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              childrenPadding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              expandedAlignment: Alignment.centerLeft,
              children: [
                Text(
                  "Maruthi Suzuki ,Swift",
                  style: VStyle.style(
                    context: context,
                    fontWeight: FontWeight.bold,
                    size: 18,
                    color: VColors.BLACK,
                  ),
                ),
                Text(
                  "KL10Ab1234",
                  style: VStyle.style(
                    context: context,
                    fontWeight: FontWeight.bold,
                    size: 15,
                    color: VColors.DARK_GREY,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "₹1000",
                      style: VStyle.style(
                        context: context,
                        fontWeight: FontWeight.bold,
                        size: 20,
                        color: VColors.GREENHARD,
                      ),
                    ),
                  ],
                ),
              ],
            ),
      ),
    );
  }
}
