import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wheels_kart/common/components/app_spacer.dart';
import 'package:wheels_kart/common/controllers/auth%20cubit/auth_cubit.dart';
import 'package:wheels_kart/module/Dealer/core/components/v_loading.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_colors.dart';
import 'package:wheels_kart/module/Dealer/core/v_style.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/controller/v%20auction%20controller/v_dashboard_controlller_bloc.dart';
import 'package:wheels_kart/module/Dealer/features/screens/my%20auction%20and%20ocb/data/controller/my%20auction%20controller/v_my_auction_controller_bloc.dart';
import 'package:wheels_kart/module/Dealer/features/screens/my%20auction%20and%20ocb/screens/my_tabs/auctionhistoy_tab.dart';
import 'package:wheels_kart/module/Dealer/features/screens/my%20auction%20and%20ocb/screens/my_tabs/bought_ocb_history_tab.dart';
import 'package:wheels_kart/module/Dealer/features/v_nav_screen.dart';
import 'package:wheels_kart/module/Dealer/features/widgets/v_custom_backbutton.dart';

class VMyBidTab extends StatefulWidget {
  const VMyBidTab({super.key});

  @override
  State<VMyBidTab> createState() => _VMyBidTabState();

  static Widget buildImageSection(String image, String id) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(15),
        bottomRight: Radius.circular(15),
      ),
      child: Container(
        height: 100,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [VColors.LIGHT_GREY.withOpacity(0.3), VColors.LIGHT_GREY],
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            image.isNotEmpty
                ? Hero(
                  tag: id,
                  child: CachedNetworkImage(
                    imageUrl: image,
                    fit: BoxFit.cover,
                    placeholder:
                        (context, url) => Container(
                          color: VColors.LIGHT_GREY,
                          child: const Center(child: VLoadingIndicator()),
                        ),
                    errorWidget:
                        (context, url, error) => _buildPlaceholderIcon(),
                  ),
                )
                : _buildPlaceholderIcon(),

            // Gradient overlay for better text visibility
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.1)],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildHeader(
    BuildContext context,
    String manufacturingYear,
    String brandName,
    String modelName,
    String city,
    String evaluationId,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$manufacturingYear $brandName",
          style: VStyle.style(context: context, color: VColors.BLACK, size: 17),
        ),
        Text(
          modelName,
          style: VStyle.style(context: context, color: VColors.BLACK, size: 14),
        ),
        AppSpacer(heightPortion: .01),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.location_on_rounded,
                    color: VColors.DARK_GREY,
                    size: 15,
                  ),
                  SizedBox(width: 1),
                  Flexible(
                    child: Text(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      city,
                      style: VStyle.style(
                        context: context,
                        color: VColors.DARK_GREY,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: Text(
                "ID: $evaluationId",
                style: VStyle.style(context: context, color: VColors.DARK_GREY),
              ),
            ),
          ],
        ),
      ],
    );
  }

  static Widget _buildPlaceholderIcon() {
    return Container(
      color: VColors.LIGHT_GREY,
      child: const Center(
        child: Icon(
          Icons.directions_car_rounded,
          size: 60,
          color: VColors.DARK_GREY,
        ),
      ),
    );
  }
}

class _VMyBidTabState extends State<VMyBidTab> with TickerProviderStateMixin {
  late TabController _tabController;
  // late String myId;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    // final state = context.read<AppAuthController>().state;
    // if (state is AuthCubitAuthenticateState) {
    //   myId = state.userModel.userId ?? "";
    // } else {
    //   myId = '';
    // }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              AppSpacer(heightPortion: .01),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // VCustomBackbutton(blendColor: VColors.GREY),
                  AppSpacer(widthPortion: .02),
                  Flexible(
                    child: TabBar(
                      controller: _tabController,
                      tabAlignment: TabAlignment.center,
                      // indicatorSize: TabBarIndicatorSize.tab,
                      indicatorColor: VColors.SECONDARY,
                      labelStyle: VStyle.style(
                        color: VColors.SECONDARY,
                        context: context,
                        fontWeight: FontWeight.w900,
                        size: 10,
                      ),
                      unselectedLabelStyle: VStyle.style(
                        size: 10,
                        context: context,
                        fontWeight: FontWeight.w300,
                      ),
                      dividerHeight: 0,
                      tabs: [
                        Padding(
                          padding: EdgeInsetsGeometry.only(bottom: 10, top: 10),
                          child: Text("Auction"),
                        ),
                        Padding(
                          padding: EdgeInsetsGeometry.only(bottom: 10, top: 10),
                          child: Text('Bought (OCB)'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              AppSpacer(heightPortion: .01),

              Expanded(
                child: Container(
                  color: VColors.GREYHARD.withAlpha(50),
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      BlocProvider(
                        create: (context) => VMyAuctionControllerBloc(),
                        child: AuctionHistoryTab(myId: CURRENT_DEALER_ID),
                      ),
                      BoughtOcbHistoryTab(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
