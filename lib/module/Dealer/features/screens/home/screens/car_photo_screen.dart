import 'dart:developer';

import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:wheels_kart/common/components/app_margin.dart';
import 'package:wheels_kart/common/components/app_spacer.dart';
import 'package:wheels_kart/common/dimensions.dart';
import 'package:wheels_kart/common/utils/responsive_helper.dart';
import 'package:wheels_kart/common/utils/routes.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_colors.dart';
import 'package:wheels_kart/module/Dealer/core/v_style.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/controller/v%20details%20controller/v_details_controller_bloc.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/model/v_car_detail_model.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/screens/photo_gallary_view.dart';
import 'package:wheels_kart/module/Dealer/features/widgets/v_custom_backbutton.dart';

class VCarPhotoScreen extends StatefulWidget {
  final VCarDetailModel carDetail;
  const VCarPhotoScreen({super.key, required this.carDetail});

  @override
  State<VCarPhotoScreen> createState() => _VCarPhotoScreenState();
}

class _VCarPhotoScreenState extends State<VCarPhotoScreen> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VColors.WHITEBGCOLOR,

      appBar: AppBar(
        backgroundColor: VColors.WHITE,
        surfaceTintColor: VColors.WHITE,
        centerTitle: false,
        leading: VCustomBackbutton(blendColor: VColors.BLACK.withAlpha(50)),
        title: Text(
          "${widget.carDetail.carDetails.yearOfManufacture} ${widget.carDetail.carDetails.brand} ${widget.carDetail.carDetails.model}",
          style: VStyle.style(
            context: context,
            size: AppDimensions.fontSize18(context),
            color: VColors.BLACK,
          ),
        ),
      ),
      body: BlocBuilder<VDetailsControllerBloc, VDetailsControllerState>(
        builder: (context, state) {
          if (state is VDetailsControllerSuccessState) {
            return Column(
              children: [
                _tabSection(state),

                Container(
                  height: 1,
                  width: w(context),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [VColors.WHITE, VColors.DARK_GREY, VColors.WHITE],
                    ),
                  ),
                ),
                _imageViewSection(state),
              ],
            );
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget _tabSection(VDetailsControllerSuccessState state) => Container(
    color: VColors.WHITE,
    child: SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              context.read<VDetailsControllerBloc>().add(
                OnChangeImageTab(imageTabIndex: 0),
              );
            },
            child: FadeInRight(
              key: GlobalObjectKey(0),

              child: Container(
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color:
                      0 == state.currentImageTabIndex
                          ? VColors.GREENHARD
                          : null,
                ),
                child: Text(
                  "Car Photos",
                  style: VStyle.style(
                    fontWeight: FontWeight.bold,
                    context: context,
                    color:
                        0 == state.currentImageTabIndex
                            ? VColors.WHITE
                            : VColors.BLACK,
                  ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children:
                widget.carDetail.sections.asMap().entries.map((map) {
                  int index = map.key + 1;
                  final section = map.value;
                  int length = 0;
                  for (var entry in section.entries) {
                    length = length + entry.responseImages.length;
                  }

                  return GestureDetector(
                    onTap: () {
                      context.read<VDetailsControllerBloc>().add(
                        OnChangeImageTab(imageTabIndex: index),
                      );
                    },
                    child: FadeInRight(
                      key: GlobalObjectKey(index),

                      child: Container(
                        margin: EdgeInsets.all(5),
                        padding: EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color:
                              index == state.currentImageTabIndex
                                  ? VColors.GREENHARD
                                  : null,
                        ),
                        child: Text(
                          "${section.portionName} ($length) ",
                          style: VStyle.style(
                            fontWeight: FontWeight.bold,
                            context: context,
                            color:
                                index == state.currentImageTabIndex
                                    ? VColors.WHITE
                                    : VColors.BLACK,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    ),
  );
  Widget _imageViewSection(VDetailsControllerSuccessState state) => Expanded(
    child: AnimationLimiter(
      child:
          state.currentTabImages.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.car_crash, color: VColors.DARK_GREY),
                    Text(
                      'No Photos',
                      style: VStyle.style(
                        context: context,
                        color: VColors.DARK_GREY,
                      ),
                    ),
                  ],
                ),
              )
              : ListView.separated(
                itemBuilder:
                    (context, index) => AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      child: SlideAnimation(
                        verticalOffset: 50.0,

                        child: FadeInAnimation(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  final carPhotos =
                                      state.detail.images
                                          .map((e) => e.url)
                                          .toList();

                                  final images =
                                      state.detail.sections
                                          .expand(
                                            (section) => section.entries.expand(
                                              (entry) => entry.responseImages,
                                            ),
                                          )
                                          .toList();
                                  final allImages = [...carPhotos, ...images];
                                  final findIndex = allImages.indexOf(
                                    state.currentTabImages[index]['image'],
                                  );
                                  // entries.map((e) =>e. ,).toList();
                                  Navigator.of(context).push(
                                    AppRoutes.createRoute(
                                      PhotoGallaryView(
                                        currentImageIndex: findIndex,
                                        images: allImages,
                                      ),
                                    ),
                                  );
                                },
                                child: Hero(
                                  tag: state.currentTabImages[index]['image'],
                                  child: AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: Container(
                                      margin: EdgeInsets.all(10),
                                      width: w(context),
                                      child: CachedNetworkImage(
                                        errorWidget:
                                            (context, url, error) => Icon(
                                              Icons.safety_check_outlined,
                                            ),
                                        imageUrl:
                                            state
                                                .currentTabImages[index]['image'],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              if (state
                                  .currentTabImages[index]['comment']
                                  .isNotEmpty)
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  child: Text(
                                    state.currentTabImages[index]['comment'],

                                    style: VStyle.style(
                                      context: context,
                                      size: 13,
                                      color: VColors.GREENHARD,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                separatorBuilder:
                    (context, index) => AppSpacer(heightPortion: .01),
                itemCount: state.currentTabImages.length,
              ),
    ),
  );
}
