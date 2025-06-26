import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:wheels_kart/common/components/app_margin.dart';
import 'package:wheels_kart/common/components/app_spacer.dart';
import 'package:wheels_kart/common/dimensions.dart';
import 'package:wheels_kart/common/utils/responsive_helper.dart';
import 'package:wheels_kart/module/VENDOR/core/const/v_colors.dart';
import 'package:wheels_kart/module/VENDOR/core/v_style.dart';
import 'package:wheels_kart/module/VENDOR/features/screens/home/data/model/v_car_model.dart';
import 'package:wheels_kart/module/VENDOR/features/widgets/v_custom_backbutton.dart';

class VCarDetailsScreen extends StatefulWidget {
  final VCarModel car;
  const VCarDetailsScreen({super.key, required this.car});

  @override
  State<VCarDetailsScreen> createState() => _VCarDetailsScreenState();
}

class _VCarDetailsScreenState extends State<VCarDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VColors.WHITEBGCOLOR,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: VColors.WHITE,
            leading: VCustomBackbutton(blendColor: VColors.BLACK.withAlpha(50)),
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
                _buildImageListButton(),

                _buildCarHead(),

                _buildCarLegals(),

                _buildCard(
                  icon: CupertinoIcons.doc_fill,
                  cardTitle: "Documents",
                  childres: [
                    _buildQuestionAndAnswerTile("RC availabity", "No"),
                    _buildQuestionAndAnswerTile("Insurence", "Comprehancive"),
                    _buildQuestionAndAnswerTile("Road tax Paid", "2002"),
                  ],
                ),

                // _buildCard(cardTitle, childres)
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageListButton() {
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
              imageUrl: widget.car.frontImage,
              errorListener: (value) {},
            ),
          ),
        ),
        AppSpacer(heightPortion: .01),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              5,
              (index) => Container(
                margin: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: .5, color: VColors.GREENHARD),
                ),
                height: 50,
                width: w(context) / 4,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCarHead() {
    return AppMargin(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSpacer(heightPortion: .01),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.car.manufacturingYear + "  " + widget.car.modelName,
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
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Icon(
                          Icons.favorite_rounded,
                          // : Icons.favorite_border_rounded,
                          // key: ValueKey(widget.isFavorite),
                          color: VColors.ACCENT,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.car.city,
                style: VStyle.style(
                  context: context,
                  color: VColors.BLACK,
                  fontWeight: FontWeight.w500,
                  size: 15,
                ),
              ),
              Text(
                "ID 635263",
                style: VStyle.style(context: context, color: VColors.DARK_GREY),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCarLegals() {
    return SizedBox();
  }

  Widget _buildCard({
    required IconData icon,
    required String cardTitle,
    required List<Widget> childres,
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
                  Icon(icon, color: VColors.GREENHARD),
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
              IconButton(
                color: VColors.GREENHARD,
                onPressed: () {},
                icon: Icon(Icons.arrow_drop_down_circle_outlined),
              ),
            ],
          ),
          AppSpacer(heightPortion: .01),
          Column(children: childres),
        ],
      ),
    );
  }

  Widget _buildQuestionAndAnswerTile(String qestion, String answer) {
    return Padding(
      padding: EdgeInsets.only(bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            qestion,
            style: VStyle.style(
              context: context,
              fontWeight: FontWeight.bold,
              size: 16,
            ),
          ),
          Text(
            answer,
            style: VStyle.style(
              context: context,
              fontWeight: FontWeight.bold,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }
}
