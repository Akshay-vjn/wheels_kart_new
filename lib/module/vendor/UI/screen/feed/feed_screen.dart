import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:wheels_kart/core/components/app_spacer.dart';
import 'package:wheels_kart/core/constant/colors.dart';
import 'package:wheels_kart/core/constant/dimensions.dart';
import 'package:wheels_kart/core/constant/style.dart';
import 'package:wheels_kart/core/utils/responsive_helper.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Pinned search bar
          SliverAppBar(
            surfaceTintColor: AppColors.DARK_PRIMARY_LIGHT,
            expandedHeight: h(context) * .17,
            collapsedHeight: 60,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.DARK_PRIMARY,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingSize10,
                ),
                child: Row(
                  children: [
                    AppSpacer(widthPortion: .01),

                    Flexible(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppDimensions.paddingSize5,
                          vertical: AppDimensions.paddingSize15,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          border: Border.all(color: AppColors.BORDER_COLOR),
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusSize10,
                          ),
                        ),
                        child: Row(
                          children: [
                            AppSpacer(widthPortion: .02),
                            Icon(SolarIconsOutline.magnifier),
                            AppSpacer(widthPortion: .02),
                            Text(
                              "Seach cars",
                              style: AppStyle.poppins(
                                context: context,
                                color: AppColors.grey,
                                fontWeight: FontWeight.w400,
                                size: AppDimensions.fontSize18(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    AppSpacer(widthPortion: .05),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingSize15,
                        vertical: AppDimensions.paddingSize15,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        border: Border.all(color: AppColors.BORDER_COLOR),
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusSize10,
                        ),
                      ),
                      child: Icon(CupertinoIcons.bell, color: AppColors.black),
                    ),
                    AppSpacer(widthPortion: .01),
                  ],
                ),
              ),
            ),
            automaticallyImplyLeading: false,
          ),

          SliverList.separated(
            itemCount: 15,
            itemBuilder:
                (context, index) => Padding(
                  padding: EdgeInsets.only(
                    top: index == 0 ? 10 : 0,
                    bottom: 15 == index - 1 ? 100 : 0,
                  ),
                  child: _buildItem(),
                ),
            separatorBuilder: (context, index) => AppSpacer(heightPortion: .01),
          ),
        ],
      ),
    );
  }

  Widget _buildItem() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.FILL_COLOR,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSize10),
        border: Border.all(color: AppColors.BORDER_COLOR, width: .1),
      ),
      margin: EdgeInsets.symmetric(horizontal: AppDimensions.paddingSize10),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 150,
                width: w(context) * .5,
                color: AppColors.black2,
              ),
            ],
          ),
          Container(height: 20, color: AppColors.white),
          Text("data"),
        ],
      ),
    );
  }
}
