import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wheels_kart/common/components/app_empty_text.dart';
import 'package:wheels_kart/common/components/app_spacer.dart';
import 'package:wheels_kart/module/Dealer/core/components/v_loading.dart';

import 'package:wheels_kart/module/Dealer/features/screens/my%20auction%20and%20ocb/data/controller/my%20auction%20controller/v_my_auction_controller_bloc.dart';
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
              return list.isEmpty
                  ? AppEmptyText(text: "No Auctions found!")
                  : ListView.separated(
                    itemCount: list.length,
                    separatorBuilder:
                        (context, index) => AppSpacer(heightPortion: .01),
                    padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                    itemBuilder: (context, index) {
                      final auction = list[index];

                      return AuctionTile(auction: auction);
                    },
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
}
