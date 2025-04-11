import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:wheels_kart/core/components/app_margin.dart';
import 'package:wheels_kart/core/components/app_spacer.dart';
import 'package:wheels_kart/core/constant/colors.dart';
import 'package:wheels_kart/core/constant/dimensions.dart';
import 'package:wheels_kart/core/constant/style.dart';
import 'package:wheels_kart/core/utils/responsive_helper.dart';

class LikedFeedSceen extends StatefulWidget {
  const LikedFeedSceen({super.key});

  @override
  State<LikedFeedSceen> createState() => _LikedFeedSceenState();
}

class _LikedFeedSceenState extends State<LikedFeedSceen> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          surfaceTintColor: AppColors.DARK_PRIMARY,
          backgroundColor: AppColors.DARK_PRIMARY,
          floating: true,
          elevation: 0,
          pinned: false,
          expandedHeight: h(context) * .08,
          collapsedHeight: h(context) * .085,
          automaticallyImplyLeading: false,
          flexibleSpace: FlexibleSpaceBar(
            background: Center(
              child: AppMargin(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Whishlist",
                      style: AppStyle.poppins(
                        context: context,
                        fontWeight: FontWeight.w600,
                        size: AppDimensions.fontSize25(context),
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => Padding(
              padding: EdgeInsets.only(
                top: index == 0 ? 10 : 0,
                bottom: h(context) * .015,
              ),
              child: _buildItem(),
            ),
            childCount: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildItem() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppDimensions.paddingSize20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSize10),
        border: Border.all(color: AppColors.BORDER_COLOR, width: 0.1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Placeholder
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 150,
                width: w(context) * .5,
                decoration: BoxDecoration(
                  color: AppColors.black2,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppDimensions.radiusSize10),
                    bottomRight: Radius.circular(AppDimensions.radiusSize10),
                  ),
                ),
              ),

              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(AppDimensions.paddingSize5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            color: AppColors.DEFAULT_ORANGE,
                            SolarIconsBold.heart,
                          ),
                        ],
                      ),
                      Text(
                        "2010 Tata",
                        style: AppStyle.poppins(
                          context: context,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "Nano LX",
                        style: AppStyle.poppins(
                          context: context,
                          fontWeight: FontWeight.w500,
                          size: AppDimensions.fontSize18(context),
                        ),
                      ),
                      AppSpacer(heightPortion: .009),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                SolarIconsOutline.mapPointRotate,
                                size: 15,

                                color: AppColors.grey,
                              ),
                              AppSpacer(widthPortion: .009),
                              Text(
                                "Banglore",
                                style: AppStyle.poppins(
                                  context: context,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.grey,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "ID: 23456",
                            style: AppStyle.poppins(
                              context: context,
                              fontWeight: FontWeight.w500,

                              color: AppColors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Content section
          Padding(
            padding: EdgeInsets.all(AppDimensions.paddingSize10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSpacer(heightPortion: .005),
                Text(
                  "Feed Item Title",
                  style: AppStyle.poppins(
                    context: context,
                    fontWeight: FontWeight.w500,
                    size: AppDimensions.fontSize16(context),
                    color: AppColors.black,
                  ),
                ),
                AppSpacer(heightPortion: .005),
                Text(
                  "This is a short description or subtitle for the feed item.",
                  style: AppStyle.poppins(
                    context: context,
                    fontWeight: FontWeight.w300,
                    size: AppDimensions.fontSize12(context),
                    color: AppColors.black2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
