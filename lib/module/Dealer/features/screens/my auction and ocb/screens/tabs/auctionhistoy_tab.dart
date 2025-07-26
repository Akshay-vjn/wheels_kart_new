import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wheels_kart/common/components/app_empty_text.dart';
import 'package:wheels_kart/common/components/app_margin.dart';
import 'package:wheels_kart/common/components/app_spacer.dart';
import 'package:wheels_kart/module/Dealer/core/components/v_loading.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_colors.dart';
import 'package:wheels_kart/module/Dealer/core/v_style.dart';

import 'package:wheels_kart/module/Dealer/features/screens/my%20auction%20and%20ocb/data/controller/my%20auction%20controller/v_my_auction_controller_bloc.dart';
import 'package:wheels_kart/module/Dealer/features/screens/my%20auction%20and%20ocb/data/models/v_my_auction_model.dart';
import 'package:wheels_kart/module/Dealer/features/widgets/auction_tile.dart';

class AuctionHistoryTab extends StatefulWidget {
  const AuctionHistoryTab({super.key});

  @override
  State<AuctionHistoryTab> createState() => _AuctionHistoryTabState();
}

class _AuctionHistoryTabState extends State<AuctionHistoryTab> {
  @override
  void initState() {
    final controller = context.read<VMyAuctionControllerBloc>();
    controller.add(ConnectWebSocket());
    controller.add(OnGetMyAuctions(context: context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VMyAuctionControllerBloc, VMyAuctionControllerState>(
      builder: (context, state) {
        switch (state) {
          case VMyAuctionControllerSuccessState():
            {
              final list = state.listOfMyAuctions;

              return DefaultTabController(
                length: 3,
                child: AppMargin(
                  child: Column(
                    children: [
                      AppSpacer(heightPortion: .01),
                      TabBar(
                        labelStyle: VStyle.style(
                          context: context,
                          fontWeight: FontWeight.bold,
                          size: 12,
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        dividerHeight: 0,
                        indicator: BoxDecoration(
                          color: VColors.WHITE,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        tabs: [
                          Tab(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Winning",
                                  style: VStyle.style(
                                    context: context,
                                    color: VColors.SECONDARY,
                                  ),
                                ),
                                AppSpacer(widthPortion: .02),
                                Icon(
                                  Icons.trending_up,
                                  size: 20,
                                  color: VColors.SECONDARY,
                                ),
                              ],
                            ),
                          ),
                          Tab(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Losing",
                                  style: VStyle.style(
                                    context: context,
                                    color: VColors.ERROR,
                                  ),
                                ),
                                AppSpacer(widthPortion: .02),
                                Icon(
                                  Icons.trending_down,
                                  size: 20,
                                  color: VColors.ERROR,
                                ),
                              ],
                            ),
                          ),
                          Tab(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Owned",
                                  style: VStyle.style(
                                    context: context,
                                    color: VColors.GREENHARD,
                                  ),
                                ),
                                AppSpacer(widthPortion: .02),
                                Icon(
                                  Icons.emoji_events,
                                  size: 20,
                                  color: VColors.GREENHARD,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      AppSpacer(heightPortion: .01),
                      Expanded(
                        child: TabBarView(
                          children: [
                            _buildLiveWinningAuction(
                              list
                                  .where(
                                    (element) =>
                                        element.bidStatus == "Open" &&
                                        element.bidAmount ==
                                            element.yourBids.first.amount
                                                .toString(),
                                  )
                                  .toList(),
                            ),
                            _buildLiveLosingAuction(
                              list
                                  .where(
                                    (element) =>
                                        element.bidStatus == "Open" &&
                                        element.bidAmount !=
                                            element.yourBids.first.amount
                                                .toString(),
                                  )
                                  .toList(),
                            ),
                            _buildSoldAuction(
                              list
                                  .where(
                                    (element) => element.bidStatus == "Sold",
                                  )
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          case VMyAuctionControllerErrorState():
            {
              return AppEmptyText(text: state.error);
            }
          default:
            {
              return VLoadingIndicator();
            }
        }
      },
    );
  }

  Widget _buildLiveWinningAuction(List<VMyAuctionModel> list) {
    return list.isEmpty
        ? AppEmptyText(text: "No Auctions found!")
        : SingleChildScrollView(
          child: Column(
            children:
                list.map((auction) => AuctionTile(auction: auction)).toList(),
          ),
        );
  }

  Widget _buildLiveLosingAuction(List<VMyAuctionModel> list) {
    return list.isEmpty
        ? AppEmptyText(text: "No Auctions found!")
        : SingleChildScrollView(
          child: Column(
            children:
                list.map((auction) => AuctionTile(auction: auction)).toList(),
          ),
        );
  }

  Widget _buildSoldAuction(List<VMyAuctionModel> list) {
    return list.isEmpty
        ? AppEmptyText(text: "No Auctions found!")
        : SingleChildScrollView(
          child: Column(
            children:
                list.map((auction) => AuctionTile(auction: auction)).toList(),
          ),
        );
  }
}
