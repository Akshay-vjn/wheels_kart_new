import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:wheels_kart/common/components/app_empty_text.dart';
import 'package:wheels_kart/common/components/app_margin.dart';
import 'package:wheels_kart/common/components/app_spacer.dart';
import 'package:wheels_kart/common/dimensions.dart';
import 'package:wheels_kart/common/utils/responsive_helper.dart';
import 'package:wheels_kart/common/utils/routes.dart';
import 'package:wheels_kart/module/Dealer/core/components/v_loading.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_colors.dart';
import 'package:wheels_kart/module/Dealer/core/v_style.dart';
import 'package:wheels_kart/module/Dealer/features/screens/favorates/data/controller/wishlist%20controller/v_wishlist_controller_cubit.dart';
import 'package:wheels_kart/module/Dealer/features/screens/favorates/data/repo/v_add_remove_fav_repo.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/controller/v%20details%20controller/v_details_controller_bloc.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/model/v_car_detail_model.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/screens/car_photo_screen.dart';
import 'package:wheels_kart/module/Dealer/features/widgets/v_custom_backbutton.dart';

class VCarDetailsScreen extends StatefulWidget {
  final bool isLiked;
  final String inspectionId;
  VCarDetailsScreen({
    super.key,
    required this.inspectionId,
    required this.isLiked,
  });

  @override
  State<VCarDetailsScreen> createState() => _VCarDetailsScreenState();
}

class _VCarDetailsScreenState extends State<VCarDetailsScreen> {
  @override
  void initState() {
    context.read<VDetailsControllerBloc>().add(
      OnFetchDetails(context: context, inspectionId: widget.inspectionId),
    );
    _isLiked = widget.isLiked;
    setState(() {});
    super.initState();
  }

  bool _isLiked = false;

  // ?text=Hello%20there
  Future<void> openWhatsApp() async {
    final Uri url = Uri.parse('https://wa.me/919964955575');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch https://wa.me/919964955575';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VColors.WHITEBGCOLOR,
      body: BlocBuilder<VDetailsControllerBloc, VDetailsControllerState>(
        builder: (context, state) {
          switch (state) {
            case VDetailsControllerErrorState():
              {
                return Center(child: AppEmptyText(text: state.error));
              }
            case VDetailsControllerSuccessState():
              {
                final detail = state.detail;
                return CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      backgroundColor: VColors.WHITE,
                      surfaceTintColor: VColors.WHITE,
                      leading: VCustomBackbutton(
                        onTap: () {
                          Navigator.pop(context, _isLiked);
                        },
                        blendColor: VColors.BLACK.withAlpha(50),
                      ),
                      centerTitle: false,
                      // floating: true,
                      pinned: true,
                      title: Text(
                        "Back",
                        style: VStyle.style(
                          context: context,
                          size: AppDimensions.fontSize18(context),
                          color: VColors.BLACK,
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.all(0),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate.fixed([
                          _buildImageListButton(detail.images),

                          _buildCarHead(
                            "${detail.carDetails.brand} ${detail.carDetails.model}",
                            detail.carDetails.city,
                            detail.carDetails.evaluationId,
                            detail.carDetails.variant,
                          ),
                          AppSpacer(heightPortion: .01),
                          _buildCarSpecification(detail.carDetails),
                          AppSpacer(heightPortion: .01),

                          _buildCard(
                            index: 0,
                            icon: CupertinoIcons.doc_fill,
                            cardTitle: "Documents",
                            childres: [
                              _buildQuestionAndAnswerTile(
                                "RC availability",
                                "YES",
                              ),
                              _buildQuestionAndAnswerTile(
                                "Insurance",
                                detail.carDetails.insuranceType,
                                otherInfo: detail.carDetails.insuranceValidity,
                                subtitle: "Expire on",
                              ),

                              _buildQuestionAndAnswerTile(
                                "Road Tax",
                                detail.carDetails.roadTaxPaid,
                                otherInfo: detail.carDetails.roadTaxValidity,
                                subtitle: "Expire on",
                              ),

                              _buildDevider(),

                              Text(
                                "Other informations",
                                style: VStyle.style(
                                  context: context,
                                  fontWeight: FontWeight.bold,
                                  color: VColors.GREENHARD,
                                  size: AppDimensions.fontSize18(context),
                                ),
                              ),

                              AppSpacer(heightPortion: .01),

                              _buildQuestionAndAnswerTile(
                                "Engine Type",
                                detail.carDetails.engineType,
                              ),
                              _buildQuestionAndAnswerTile(
                                "Car Length",
                                detail.carDetails.carLength,
                              ),
                              _buildQuestionAndAnswerTile(
                                "Cubic Capacity",
                                detail.carDetails.cubicCapacity,
                              ),

                              _buildQuestionAndAnswerTile(
                                "No. of Keys",
                                detail.carDetails.noOfKeys,
                              ),

                              _buildDevider(),

                              Text(
                                "Registration and fitness",
                                style: VStyle.style(
                                  context: context,
                                  fontWeight: FontWeight.bold,
                                  color: VColors.GREENHARD,
                                  size: AppDimensions.fontSize18(context),
                                ),
                              ),
                              AppSpacer(heightPortion: .01),

                              _buildQuestionAndAnswerTile(
                                "Manufacture Date",
                                detail.carDetails.manufactureDate,
                              ),
                              _buildQuestionAndAnswerTile(
                                "Registration Date",
                                detail.carDetails.registrationDate,
                              ),
                              _buildQuestionAndAnswerTile(
                                "RTO",
                                detail.carDetails.currentRto,
                              ),
                            ],
                          ),
                          Column(
                            children:
                                detail.sections.asMap().entries.map((map) {
                                  final index = map.key;
                                  final section = map.value;
                                  return _buildCard(
                                    index: index + 1,
                                    hideIcon: true,
                                    icon: Icons.abc,
                                    cardTitle: section.portionName,
                                    childres:
                                        section.entries.map((entry) {
                                          return _buildQuestionAndAnswerTile(
                                            entry.question,
                                            entry.answer.toUpperCase(),
                                            showIcon: true,
                                            subtitle: entry.options,
                                            child:
                                                entry.responseImages.isNotEmpty
                                                    ? InkWell(
                                                      onTap: () async {
                                                        context
                                                            .read<
                                                              VDetailsControllerBloc
                                                            >()
                                                            .add(
                                                              OnChangeImageTab(
                                                                imageTabIndex:
                                                                    index + 1,
                                                              ),
                                                            );
                                                        Navigator.of(
                                                          context,
                                                        ).push(
                                                          AppRoutes.createRoute(
                                                            VCarPhotoScreen(
                                                              carDetail: detail,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          border: Border.all(
                                                            width: .5,
                                                            color:
                                                                VColors
                                                                    .SECONDARY,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                5,
                                                              ),
                                                        ),

                                                        width: 50,
                                                        height: 50,
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                5,
                                                              ),
                                                          child: CachedNetworkImage(
                                                            fit: BoxFit.cover,
                                                            imageUrl:
                                                                entry
                                                                    .responseImages
                                                                    .first,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                    : SizedBox.shrink(),
                                          );
                                        }).toList(),
                                  );
                                }).toList(),
                          ),
                        ]),
                      ),
                    ),
                  ],
                );
              }
            default:
              {
                return Center(child: VLoadingIndicator());
              }
          }
        },
      ),
      bottomNavigationBar:
          BlocBuilder<VDetailsControllerBloc, VDetailsControllerState>(
            builder: (context, state) {
              if (state is VDetailsControllerSuccessState) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  height: Platform.isIOS ? h(context) * .13 : h(context) * .1,
                  decoration: BoxDecoration(
                    color: VColors.WHITE,
                    boxShadow: [
                      BoxShadow(
                        color: VColors.DARK_GREY.withAlpha(50),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Current Bid",
                            style: VStyle.style(
                              context: context,
                              color: VColors.GREY,
                              fontWeight: FontWeight.w600,
                              size: 15,
                            ),
                          ),
                          Text(
                            "₹${state.detail.carDetails.currentBid}",
                            style: VStyle.style(
                              context: context,
                              color: VColors.GREENHARD,
                              fontWeight: FontWeight.w900,
                              size: 27,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: VColors.GREENHARD,
                        ),
                        onPressed: () async => await openWhatsApp(),

                        child: Icon(
                          SolarIconsBold.chatRound,
                          color: VColors.WHITE,
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return SizedBox.shrink();
              }
            },
          ),
    );
  }

  Widget _buildImageListButton(List<CarImage> images) {
    return BlocBuilder<VDetailsControllerBloc, VDetailsControllerState>(
      builder: (context, state) {
        if (state is VDetailsControllerSuccessState) {
          return Column(
            children: [
              state.detail.images.isEmpty
                  ? SizedBox.shrink()
                  : InkWell(
                    onTap: () {
                      context.read<VDetailsControllerBloc>().add(
                        OnChangeImageTab(imageTabIndex: 0),
                      );
                      Navigator.of(context).push(
                        AppRoutes.createRoute(
                          VCarPhotoScreen(carDetail: state.detail),
                        ),
                      );
                    },
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Container(
                        // width: w(context),
                        // height: h(context) * .,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              VColors.LIGHT_GREY.withOpacity(0.3),
                              VColors.LIGHT_GREY,
                            ],
                          ),
                        ),
                        child: FadeIn(
                          key: GlobalObjectKey(
                            images[state.currentImageIndex].toString(),
                          ),
                          child: CachedNetworkImage(
                            errorWidget:
                                (context, url, error) => Center(
                                  child: Text(
                                    "Image not found",
                                    style: VStyle.style(
                                      context: context,
                                      color: VColors.DARK_GREY,
                                    ),
                                  ),
                                ),
                            imageUrl: images[state.currentImageIndex].url,
                            errorListener: (value) {},
                          ),
                        ),
                      ),
                    ),
                  ),
              AppSpacer(heightPortion: .01),
              state.detail.images.isEmpty
                  ? SizedBox.shrink()
                  : SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        images.length,
                        (index) => GestureDetector(
                          onTap: () {
                            context.read<VDetailsControllerBloc>().add(
                              OnChangeImageIndex(newIndex: index),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(2),

                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            margin: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                width:
                                    state.currentImageIndex == index ? 1 : .5,
                                color:
                                    state.currentImageIndex == index
                                        ? VColors.GREENHARD
                                        : VColors.DARK_GREY,
                              ),
                            ),
                            // height: 60,
                            width: w(context) / 4,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: images[index].url,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
            ],
          );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }

  Widget _buildCarHead(
    String brandName,
    String location,
    String evaId,
    String varient,
  ) {
    return AppMargin(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSpacer(heightPortion: .02),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                brandName,
                style: VStyle.style(
                  context: context,
                  fontWeight: FontWeight.bold,
                  size: 20,
                ),
              ),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      _isLiked = !_isLiked;
                      setState(() {});
                      context.read<VWishlistControllerCubit>().onChangeFavState(
                        context,
                        widget.inspectionId,
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Icon(
                          _isLiked
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          // key: ValueKey(widget.isFavorite),
                          color: _isLiked ? VColors.ACCENT : VColors.DARK_GREY,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          AppSpacer(heightPortion: .01),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.location_on_rounded,
                    size: 16,
                    color: VColors.DARK_GREY,
                  ),
                  Text(
                    location,
                    style: VStyle.style(
                      context: context,
                      color: VColors.DARK_GREY,
                    ),
                  ),
                ],
              ),
              AppSpacer(widthPortion: .03),
              Text(
                "ID $evaId",
                style: VStyle.style(context: context, color: VColors.DARK_GREY),
              ),
            ],
          ),
          AppSpacer(heightPortion: .01),

          Text(
            varient,
            style: VStyle.style(
              context: context,
              color: VColors.BLACK,
              fontWeight: FontWeight.w400,
              size: 15,
            ),
          ),
          AppSpacer(heightPortion: .005),
        ],
      ),
    );
  }

  Widget _buildCarSpecification(CarDetails carDetails) {
    final style = VStyle.style(context: context, fontWeight: FontWeight.bold);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(color: VColors.SECONDARY.withAlpha(20)),
      width: w(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          carDetails.transmission.isEmpty
              ? SizedBox.shrink()
              : Text(carDetails.transmission.toUpperCase(), style: style),
          carDetails.transmission.isEmpty
              ? SizedBox.shrink()
              : AppSpacer(widthPortion: .01),

          carDetails.kmsDriven.isEmpty
              ? SizedBox.shrink()
              : Text("${carDetails.kmsDriven} Km", style: style),
          carDetails.kmsDriven.isEmpty
              ? SizedBox.shrink()
              : AppSpacer(widthPortion: .01),

          carDetails.noOfOwners.isEmpty
              ? SizedBox.shrink()
              : Text("No. of owners ${carDetails.noOfOwners}", style: style),
          carDetails.noOfOwners.isEmpty
              ? SizedBox.shrink()
              : AppSpacer(widthPortion: .01),

          carDetails.fuelType.isEmpty
              ? SizedBox.shrink()
              : Text(carDetails.fuelType, style: style),
          carDetails.fuelType.isEmpty
              ? SizedBox.shrink()
              : AppSpacer(widthPortion: .01),

          carDetails.registrationNumber.isEmpty
              ? SizedBox.shrink()
              : Text(
                carDetails.registrationNumber.substring(0, 6),
                style: style,
              ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String cardTitle,
    required List<Widget> childres,
    bool hideIcon = false,
    required int index,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      padding: EdgeInsets.all(10),
      width: w(context),
      decoration: BoxDecoration(
        color: VColors.WHITE,
        boxShadow: [
          BoxShadow(
            color: VColors.DARK_GREY.withAlpha(50),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        borderRadius: BorderRadius.circular(AppDimensions.radiusSize10),
      ),

      child: BlocBuilder<VDetailsControllerBloc, VDetailsControllerState>(
        builder: (context, state) {
          if (state is VDetailsControllerSuccessState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        hideIcon
                            ? SizedBox.shrink()
                            : Icon(icon, color: VColors.GREENHARD),
                        AppSpacer(widthPortion: .02),
                        Text(
                          cardTitle,
                          style: VStyle.style(
                            context: context,
                            fontWeight: FontWeight.bold,
                            color: VColors.GREENHARD,
                            size: AppDimensions.fontSize18(context),
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        context.read<VDetailsControllerBloc>().add(
                          OnCollapesCard(index: index),
                        );
                      },
                      child: Icon(
                        state.enables[index]
                            ? SolarIconsOutline.roundAltArrowUp
                            : SolarIconsOutline.roundAltArrowDown,
                        color: VColors.GREENHARD,
                      ),
                    ),
                  ],
                ),
                state.enables[index]
                    ? AppSpacer(heightPortion: .015)
                    : SizedBox.shrink(),
                state.enables[index]
                    ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: childres,
                    )
                    : SizedBox.shrink(),
              ],
            );
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget _buildQuestionAndAnswerTile(
    String qestion,
    String answer, {
    String? otherInfo,
    bool showIcon = false,
    Widget? child,
    String? subtitle,
  }) {
    Widget icon;

    if (answer == "OK" || answer == "YES") {
      icon = Icon(SolarIconsBold.checkCircle, color: VColors.PRIMARY);
    } else if (answer == "NOT OK" || answer == "NO") {
      icon = Icon(SolarIconsBold.closeCircle, color: VColors.ERROR);
    } else {
      icon = Icon(SolarIconsOutline.infoCircle, color: VColors.ACCENT);
      subtitle = answer;
    }
    return Padding(
      padding: EdgeInsets.only(bottom: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (showIcon) icon,
          AppSpacer(widthPortion: .02),
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Flexible(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        qestion,
                        style: VStyle.style(
                          context: context,
                          fontWeight: FontWeight.bold,
                          size: 16,
                        ),
                      ),
                      subtitle != null
                          ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:
                                subtitle
                                    .split(",")
                                    .map(
                                      (e) => Row(

                                        children: [
                                          Flexible(
                                            child: Text(
                                              "* ",
                                              style: VStyle.style(
                                                context: context,
                                                color: VColors.GREENHARD,
                                                fontWeight: FontWeight.w500,
                                                size: 12,
                                              ),
                                            ),
                                          ),
                                          Text(
                                             e,
                                            style: VStyle.style(
                                              context: context,
                                              color: VColors.DARK_GREY,
                                              fontWeight: FontWeight.w500,
                                              size: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                    .toList(),
                          )
                          : SizedBox.shrink(),
                    ],
                  ),
                ),
                Flexible(
                  flex: 2,
                  child:
                      child ??
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            answer,
                            style: VStyle.style(
                              context: context,
                              fontWeight: FontWeight.w500,
                              color: VColors.GREENHARD,
                              size: 14,
                            ),
                          ),

                          otherInfo != null
                              ? Text(
                                otherInfo,
                                style: VStyle.style(
                                  context: context,
                                  color: VColors.SECONDARY,
                                  fontWeight: FontWeight.w400,
                                  size: 12,
                                ),
                              )
                              : SizedBox.shrink(),
                        ],
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDevider() {
    return Divider(thickness: .3, color: VColors.GREY);
  }
}
