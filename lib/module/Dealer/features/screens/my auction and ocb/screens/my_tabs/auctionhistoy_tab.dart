import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wheels_kart/common/components/app_empty_text.dart';
import 'package:wheels_kart/common/components/app_margin.dart';
import 'package:wheels_kart/common/components/app_spacer.dart';
import 'package:wheels_kart/module/Dealer/core/components/v_loading.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_colors.dart';
import 'package:wheels_kart/module/Dealer/core/v_style.dart';

import 'package:wheels_kart/module/Dealer/features/screens/my%20auction%20and%20ocb/data/controller/my%20auction%20controller/v_my_auction_controller_bloc.dart';
import 'package:wheels_kart/module/Dealer/features/screens/my%20auction%20and%20ocb/screens/my_tabs/auction%20tabs/auction_losing_tab.dart';
import 'package:wheels_kart/module/Dealer/features/screens/my%20auction%20and%20ocb/screens/my_tabs/auction%20tabs/auction_owned_tab.dart';
import 'package:wheels_kart/module/Dealer/features/screens/my%20auction%20and%20ocb/screens/my_tabs/auction%20tabs/auction_winning_tab.dart';

class AuctionHistoryTab extends StatefulWidget {
  final String myId;
  const AuctionHistoryTab({super.key, required this.myId});

  @override
  State<AuctionHistoryTab> createState() => _AuctionHistoryTabState();
}

class _AuctionHistoryTabState extends State<AuctionHistoryTab>
    with TickerProviderStateMixin {
  late TabController auctionTaContoller;
  late final VMyAuctionControllerBloc _auctionControllerBloc;
  @override
  void initState() {
    auctionTaContoller = TabController(length: 3, vsync: this);

    _auctionControllerBloc = context.read<VMyAuctionControllerBloc>();

    _auctionControllerBloc.add(ConnectWebSocket(myId: widget.myId));
    _auctionControllerBloc.add(OnGetMyAuctions(context: context));
    super.initState();
    auctionTaContoller.addListener(() {
      setState(() {
        currentIndex = auctionTaContoller.index;
      });
    });
  }

  @override
  void dispose() {
    _auctionControllerBloc.close();
    // TODO: implement dispose
    super.dispose();
  }

  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VMyAuctionControllerBloc, VMyAuctionControllerState>(
      builder: (context, state) {
        switch (state) {
          case VMyAuctionControllerSuccessState():
            {
              return DefaultTabController(
                length: 3,
                child: AppMargin(
                  child: Column(
                    children: [
                      AppSpacer(heightPortion: .01),
                      TabBar(
                        controller: auctionTaContoller,
                        labelStyle: VStyle.style(
                          context: context,
                          fontWeight: FontWeight.w900,
                          size: 12,
                        ),
                        unselectedLabelStyle: VStyle.style(
                          context: context,
                          fontWeight: FontWeight.bold,
                          size: 12,
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        dividerHeight: 0,
                        indicatorWeight: 0,
                        indicatorPadding: EdgeInsetsGeometry.all(4),
                        indicator: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: _getTabShadoColor().withAlpha(50),
                              blurRadius: 10,
                              spreadRadius: 2,
                              offset: Offset(1, 1),
                            ),
                          ],
                          border: Border.all(
                            width: .5,
                            color: _getTabShadoColor(),
                          ),
                          color: VColors.WHITE,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        tabs: [
                          Tab(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "WINNING",
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
                                  "LOSING",
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
                                  "OWNED",
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
                          controller: auctionTaContoller,
                          children: [
                            AuctionWinningTab(),
                            AuctionLosingTab(),
                            AuctionOwnedTab(),
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
              return Center(child: AppEmptyText(text: state.error));
            }
          default:
            {
              return Center(child: VLoadingIndicator());
            }
        }
      },
    );
  }

  Color _getTabShadoColor() {
    switch (currentIndex) {
      case 0:
        return VColors.SECONDARY;
      case 1:
        return VColors.ERROR;
      case 2:
        return VColors.GREENHARD;
      default:
        {
          return VColors.SECONDARY;
        }
    }
  }
}
