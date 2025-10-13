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
import 'package:wheels_kart/module/Dealer/features/screens/home/data/controller/filter_auction_and_ocb/filter_acution_and_ocb_cubit.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/controller/v%20auction%20controller/v_dashboard_controlller_bloc.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/screens/Auction/auction_vehicle_card.dart';
import 'package:wheels_kart/module/Dealer/features/v_nav_screen.dart';

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

  // @override
  // void dispose() {
  //   _auctionControllerBloc.close();
  //   super.dispose();
  // }

  initScreen() async {
    _auctionControllerBloc = context.read<VAuctionControlllerBloc>();
    _auctionControllerBloc.add(ConnectWebSocket(context: context));
    _auctionControllerBloc.add(
      OnFetchVendorAuctionApi(context: context, tab: 'Auction'),
    );
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
              // final list = state.filterdAutionList;

              final liveAuctions = state.filterdAutionList;

              return RefreshIndicator.adaptive(
                onRefresh: () async {
                  context.read<FilterAcutionAndOcbCubit>().clearFilter();
                  return context.read<VAuctionControlllerBloc>().add(
                    OnFetchVendorAuctionApi(context: context, tab: "Auction"),
                  );
                },
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.only(top: 10),
                      child:
                          liveAuctions.isEmpty
                              ? SizedBox(
                                height: h(context) * .5,
                                child: AppEmptyText(
                                  text: "No  live auctions found!",
                                ),
                              )
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
                                            liveAuctions
                                                .map(
                                                  (e) => VAuctionVehicleCard(
                                                    myId: CURRENT_DEALER_ID,
                                                    vehicle: e,
                                                    onTimerExpired: () {
                                                      // Remove the expired auction from the list
                                                      context.read<VAuctionControlllerBloc>().add(
                                                        RemoveExpiredAuction(
                                                          inspectionId: e.inspectionId,
                                                        ),
                                                      );
                                                    },
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
                              OnFetchVendorAuctionApi(
                                context: context,
                                tab: "Auction",
                              ),
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
