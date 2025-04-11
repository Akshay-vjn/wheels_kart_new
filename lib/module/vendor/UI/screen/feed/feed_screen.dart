import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:wheels_kart/core/components/app_margin.dart';
import 'package:wheels_kart/core/components/app_spacer.dart';
import 'package:wheels_kart/core/constant/colors.dart';
import 'package:wheels_kart/core/constant/dimensions.dart';
import 'package:wheels_kart/core/constant/style.dart';
import 'package:wheels_kart/core/utils/responsive_helper.dart';
import 'package:wheels_kart/module/vendor/UI/widgets/v_custom_button.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
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
                      "𝓦𝓱𝓮𝓮𝓵𝓼 𝓚𝓪𝓻𝓽",
                      style: AppStyle.poppins(
                        context: context,
                        fontWeight: FontWeight.w300,
                        size: AppDimensions.fontSize25(context),
                        color: AppColors.white,
                      ),
                    ),
                    Icon(
                      SolarIconsOutline.magnifier,
                      color: AppColors.BORDER_COLOR,
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
              padding: EdgeInsets.only(bottom: h(context) * .015),
              child: _buildItem(),
            ),
            childCount: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildItem() {
    return Container(
      // margin: EdgeInsets.symmetric(horizontal: AppDimensions.paddingSize10),
      // padding: EdgeInsets.all(1),
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(AppDimensions.radiusSize10),
      //   border: Border.all(color: AppColors.BORDER_COLOR, width: 0.1),
      //   gradient: LinearGradient(
      //     begin: Alignment.topCenter,
      //     end: Alignment.bottomCenter,
      //     colors: [AppColors.gradientBlack, AppColors.DARK_SECONDARY],
      //   ),
      // ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: AppDimensions.paddingSize10),
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
                              SolarIconsOutline.heart,
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
            AppSpacer(heightPortion: .01),
            // Content section
            Container(
              color: AppColors.DARK_PRIMARY,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Petrol",
                    style: AppStyle.poppins(
                      context: context,
                      fontWeight: FontWeight.w600,
                      color: AppColors.BORDER_COLOR,
                    ),
                  ),
                  Text(
                    "Manual",
                    style: AppStyle.poppins(
                      context: context,
                      fontWeight: FontWeight.w600,
                      color: AppColors.BORDER_COLOR,
                    ),
                  ),
                  Text(
                    "98.6 km",
                    style: AppStyle.poppins(
                      context: context,
                      fontWeight: FontWeight.w600,
                      color: AppColors.BORDER_COLOR,
                    ),
                  ),
                  Text(
                    "2nd Owner",
                    style: AppStyle.poppins(
                      context: context,
                      fontWeight: FontWeight.w600,
                      color: AppColors.BORDER_COLOR,
                    ),
                  ),
                ],
              ),
            ),
            AppSpacer(heightPortion: .005),
            AppMargin(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Exterior 4",
                              style: AppStyle.style(
                                context: context,
                                color: AppColors.kGreen,

                                size: AppDimensions.fontSize13(context),
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Icon(Icons.star, color: AppColors.kGreen),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Interior 4",
                              style: AppStyle.style(
                                context: context,
                                color: AppColors.kGreen,

                                size: AppDimensions.fontSize13(context),
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Icon(Icons.star, color: AppColors.kGreen),
                          ],
                        ),
                      ],
                    ),
                  ),
                  AppSpacer(widthPortion: .05),
                  Flexible(
                    child: Text(
                      "Fair value: ${'2,1,22'}",
                      style: AppStyle.poppins(
                        context: context,
                        fontWeight: FontWeight.w500,
                        color: AppColors.BORDER_COLOR,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            AppSpacer(heightPortion: .005),

            AppMargin(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(SolarIconsOutline.alarm, size: 15),
                        AppSpacer(widthPortion: .01),
                        Text(
                          "01:35:06",
                          style: AppStyle.style(
                            context: context,
                            size: AppDimensions.fontSize13(context),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AppSpacer(widthPortion: .05),
                  Flexible(
                    child: Text(
                      "Current bid 12345",
                      style: AppStyle.style(
                        context: context,
                        size: AppDimensions.fontSize13(context),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            AppSpacer(heightPortion: .005),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AppMargin(
                  child: SizedBox(
                    width: w(context) * .45,
                    child: VCustomButton(
                      radius: 10,
                      bgColor: AppColors.DARK_SECONDARY,
                      onPressed: () {},
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Bid",
                            style: AppStyle.poppins(
                              context: context,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            ),
                          ),
                          Text(
                            "Step up 3000",
                            style: AppStyle.poppins(
                              context: context,
                              fontWeight: FontWeight.w400,
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            AppSpacer(heightPortion: .005),
          ],
        ),
      ),
    );
  }
}
