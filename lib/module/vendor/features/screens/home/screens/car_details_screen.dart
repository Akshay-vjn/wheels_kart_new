import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:wheels_kart/common/components/app_empty_text.dart';
import 'package:wheels_kart/common/components/app_margin.dart';
import 'package:wheels_kart/common/components/app_spacer.dart';
import 'package:wheels_kart/common/dimensions.dart';
import 'package:wheels_kart/common/utils/responsive_helper.dart';
import 'package:wheels_kart/module/VENDOR/core/components/v_loading.dart';
import 'package:wheels_kart/module/VENDOR/core/const/v_colors.dart';
import 'package:wheels_kart/module/VENDOR/core/v_style.dart';
import 'package:wheels_kart/module/VENDOR/features/screens/home/data/controller/v%20details%20controller/v_details_controller_bloc.dart';
import 'package:wheels_kart/module/VENDOR/features/screens/home/data/model/v_car_detail_model.dart';
import 'package:wheels_kart/module/VENDOR/features/widgets/v_custom_backbutton.dart';

class VCarDetailsScreen extends StatefulWidget {
  final String inspectionId;
  const VCarDetailsScreen({super.key, required this.inspectionId});

  @override
  State<VCarDetailsScreen> createState() => _VCarDetailsScreenState();
}

class _VCarDetailsScreenState extends State<VCarDetailsScreen> {
  @override
  void initState() {
    context.read<VDetailsControllerBloc>().add(
      OnFetchDetails(context: context, inspectionId: widget.inspectionId),
    );

    super.initState();
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
                      leading: VCustomBackbutton(
                        blendColor: VColors.BLACK.withAlpha(50),
                      ),
                      centerTitle: false,

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

                          _buildCard(
                            icon: CupertinoIcons.doc_fill,
                            cardTitle: "Documents",
                            childres: [
                              _buildQuestionAndAnswerTile(
                                "RC availabity",
                                "YES",
                              ),
                              _buildQuestionAndAnswerTile(
                                "Insurance",
                                detail.carDetails.insuranceType,
                                otherInfo: detail.carDetails.insuranceValidity,
                              ),

                              _buildQuestionAndAnswerTile(
                                "Road Tax",
                                detail.carDetails.roadTaxPaid,
                                otherInfo: detail.carDetails.roadTaxValidity,
                              ),

                              _buildDevider(),

                              Text(
                                "Other infromation",
                                style: VStyle.style(
                                  context: context,
                                  fontWeight: FontWeight.bold,
                                  color: VColors.GREENHARD,
                                  size: AppDimensions.fontSize18(context),
                                ),
                              ),

                              AppSpacer(heightPortion: .01),

                              _buildQuestionAndAnswerTile(
                                "Registration Date",
                                detail.carDetails.registrationDate,
                              ),
                              _buildQuestionAndAnswerTile(
                                "Manufacture Date",
                                detail.carDetails.manufactureDate,
                              ),

                              _buildQuestionAndAnswerTile(
                                "No. of Keys",
                                detail.carDetails.noOfKeys,
                              ),
                            ],
                          ),

                          Column(
                            children:
                                detail.sections
                                    .map(
                                      (section) => _buildCard(
                                        hideIcon: true,
                                        icon: Icons.abc,
                                        cardTitle: section.portionName,
                                        childres:
                                            section.entries.map((entry) {
                                              return _buildQuestionAndAnswerTile(
                                                entry.question,
                                                entry.answer.toUpperCase(),
                                                // otherInfo: entry.comment.name,
                                                showIcon: true,
                                              );
                                            }).toList(),
                                      ),
                                    )
                                    .toList(),
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
                  height: h(context) * .1,
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
                        onPressed: () {},
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

  Widget _buildImageListButton(List<String> images) {
    return BlocBuilder<VDetailsControllerBloc, VDetailsControllerState>(
      builder: (context, state) {
        if (state is VDetailsControllerSuccessState) {
          return Column(
            children: [
              AspectRatio(
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
                      imageUrl: images[state.currentImageIndex],
                      errorListener: (value) {},
                    ),
                  ),
                ),
              ),
              AppSpacer(heightPortion: .01),
              SingleChildScrollView(
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
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        margin: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            width: state.currentImageIndex == index ? 2 : 1,
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
                            imageUrl: images[index],
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
          AppSpacer(heightPortion: .01),

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

              Text(
                location,
                style: VStyle.style(
                  context: context,
                  color: VColors.ACCENT,
                  fontWeight: FontWeight.bold,
                  size: 20,
                ),
              ),

              // Container(
              //   decoration: BoxDecoration(
              //     color: Colors.white.withOpacity(0.9),
              //     borderRadius: BorderRadius.circular(12),
              //     boxShadow: [
              //       BoxShadow(
              //         color: Colors.black.withOpacity(0.1),
              //         blurRadius: 8,
              //         offset: const Offset(0, 2),
              //       ),
              //     ],
              //   ),
              //   child: Material(
              //     color: Colors.transparent,
              //     child: InkWell(
              //       borderRadius: BorderRadius.circular(12),
              //       onTap: () {},
              //       child: Padding(
              //         padding: const EdgeInsets.all(8),
              //         child: AnimatedSwitcher(
              //           duration: const Duration(milliseconds: 300),
              //           child: Icon(
              //             Icons.favorite_rounded,
              //             // : Icons.favorite_border_rounded,
              //             // key: ValueKey(widget.isFavorite),
              //             color: VColors.ACCENT,
              //             size: 20,
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
          AppSpacer(heightPortion: .01),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  varient,
                  style: VStyle.style(
                    context: context,
                    color: VColors.BLACK,
                    fontWeight: FontWeight.w400,
                    size: 15,
                  ),
                ),
              ),
              AppSpacer(widthPortion: .03),
              Text(
                "ID ${evaId}",
                style: VStyle.style(context: context, color: VColors.DARK_GREY),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCarSpecification(CarDetails carDetails) {
    final style = VStyle.style(context: context, fontWeight: FontWeight.bold);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(color: VColors.SECONDARY.withAlpha(20)),
      width: w(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(carDetails.transmission.toUpperCase(), style: style),
          AppSpacer(widthPortion: .01),
          Text("${carDetails.kmsDriven} Km", style: style),
          AppSpacer(widthPortion: .01),

          Text("No. of owners ${carDetails.noOfOwners}", style: style),
          AppSpacer(widthPortion: .01),

          Text(carDetails.fuelType, style: style),
          AppSpacer(widthPortion: .01),

          Text(carDetails.registrationNumber.substring(0, 6), style: style),
        ],
      ),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String cardTitle,
    required List<Widget> childres,
    bool hideIcon = false,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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
        borderRadius: BorderRadius.circular(AppDimensions.radiusSize15),
      ),

      child: Column(
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
                onTap: () {},
                child: Icon(
                  Icons.arrow_drop_down_circle_outlined,
                  color: VColors.GREENHARD,
                ),
              ),
            ],
          ),
          AppSpacer(heightPortion: .015),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: childres,
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionAndAnswerTile(
    String qestion,
    String answer, {
    String? otherInfo,
    bool showIcon = false,
  }) {
    Widget icon;

    if (answer == "OK" || answer == "YES") {
      icon = Icon(Icons.check_circle_outline_rounded, color: VColors.PRIMARY);
    } else {
      icon = Icon(Icons.error_outline_sharp, color: VColors.ACCENT);
    }
    return Padding(
      padding: EdgeInsets.only(bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (showIcon) icon,
          AppSpacer(widthPortion: .01),
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Flexible(
                  child: Text(
                    qestion,
                    style: VStyle.style(
                      context: context,
                      fontWeight: FontWeight.bold,
                      size: 16,
                    ),
                  ),
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        answer,
                        style: VStyle.style(
                          context: context,
                          fontWeight: FontWeight.bold,
                          size: 16,
                        ),
                      ),

                      otherInfo != null
                          ? Text(
                            otherInfo,
                            style: VStyle.style(
                              context: context,
                              color: VColors.GREENHARD,
                              fontWeight: FontWeight.w700,
                              size: 13,
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
