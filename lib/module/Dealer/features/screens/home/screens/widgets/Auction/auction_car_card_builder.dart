import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:wheels_kart/common/components/app_empty_text.dart';
import 'package:wheels_kart/common/controllers/auth%20cubit/auth_cubit.dart';
import 'package:wheels_kart/common/utils/responsive_helper.dart';
import 'package:wheels_kart/module/Dealer/core/components/v_loading.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_colors.dart';
import 'package:wheels_kart/module/Dealer/core/v_style.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/controller/v%20auction%20controller/v_dashboard_controlller_bloc.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/screens/widgets/Auction/auction_vehicle_card.dart';
import 'package:wheels_kart/module/Dealer/features/v_nav_screen.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/widgets/ev_app_loading_indicator.dart';

class VAuctionCarBuilder extends StatefulWidget {
  VAuctionCarBuilder({super.key});

  @override
  State<VAuctionCarBuilder> createState() => _VAuctionCarBuilderState();
}

// List<bool> myLikes = [];

class _VAuctionCarBuilderState extends State<VAuctionCarBuilder> {
  late final VAuctionControlllerBloc _auctionControllerBloc;
  @override
  void initState() {
    // _getMyId();
    // WEB SOCKET COONECTION
    initScreen();
    super.initState();
  }

  @override
  void dispose() {
    _auctionControllerBloc.close();
    super.dispose();
  }

  bool loadingId = true;
  // String myId = "";
  // Future<void> _getMyId() async {
  //   final userData = await context.read<AppAuthController>().getUserData;
  //   myId = userData.userId ?? '';
  //   setState(() {
  //     loadingId = false;
  //   });
  //   log("My Id :$myId");
  // }

  initScreen() async {
    _auctionControllerBloc = context.read<VAuctionControlllerBloc>();
    _auctionControllerBloc.add(ConnectWebSocket(context: context));
    // FETCHING DATA
    _auctionControllerBloc.add(OnFetchVendorAuctionApi(context: context));
    // await _getMyId();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VAuctionControlllerBloc, VAuctionControlllerState>(
      builder: (context, state) {
        switch (state) {
          case VVAuctionControllerErrorState():
            {
              return Center(child: AppEmptyText(text: state.errorMesage));
            }

          case VAuctionControllerSuccessState():
            {
              final carList = state.listOfCars;

              return RefreshIndicator.adaptive(
                onRefresh: () async {
                  return context.read<VAuctionControlllerBloc>().add(
                    OnFetchVendorAuctionApi(context: context),
                  );
                },
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.only(top: 10),
                      child:
                          carList.isEmpty
                              ? AppEmptyText(text: "No auctions found!")
                              : AnimationLimiter(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children:
                                      AnimationConfiguration.toStaggeredList(
                                        duration: const Duration(
                                          milliseconds: 375,
                                        ),
                                        childAnimationBuilder:
                                            (p0) => SlideAnimation(
                                              horizontalOffset: 50.0,
                                              child: FadeInAnimation(child: p0),
                                            ),
                                        children:
                                            carList
                                                .map(
                                                  (e) => VAuctionVehicleCard(
                                                    myId: CURRENT_DEALER_ID,
                                                    vehicle: e,
                                                  ),
                                                )
                                                .toList(),
                                      ),
                                ),
                              ),
                    ),
                    state.enableRefreshButton
                        ? ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: VColors.SECONDARY,
                          ),
                          label: Text(
                            'New Live Auctions',
                            style: VStyle.style(
                              context: context,
                              fontWeight: FontWeight.bold,
                              size: 15,
                            ),
                          ),
                          icon: Icon(Icons.keyboard_double_arrow_up_rounded),
                          onPressed: () {
                            return context.read<VAuctionControlllerBloc>().add(
                              OnFetchVendorAuctionApi(context: context),
                            );
                          },
                        )
                        : SizedBox.shrink(),
                  ],
                ),
              );
            }
          default:
            {
              return SizedBox(
                height: h(context) * .7,
                child: Center(child: VLoadingIndicator()),
              );
            }
        }
      },
    );
  }
}
