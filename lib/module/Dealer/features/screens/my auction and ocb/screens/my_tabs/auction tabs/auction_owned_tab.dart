import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wheels_kart/common/components/app_empty_text.dart';
import 'package:wheels_kart/module/Dealer/features/screens/my%20auction%20and%20ocb/data/controller/my%20auction%20controller/v_my_auction_controller_bloc.dart';
import 'package:wheels_kart/module/Dealer/features/screens/my%20auction%20and%20ocb/screens/widgets/auction_tile.dart';

class AuctionOwnedTab extends StatelessWidget {
  final String myId;

  const AuctionOwnedTab({super.key, required this.myId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VMyAuctionControllerBloc, VMyAuctionControllerState>(
      builder: (context, state) {
        if (state is VMyAuctionControllerSuccessState) {
          final data = state.listOfMyAuctions;
          final list =
              data
                  .where(
                    (element) =>
                        element.bidStatus == "Sold" && element.soldTo == myId,
                  )
                  .toList();

          return list.isEmpty
              ? Center(child: AppEmptyText(text: "No Auctions found!"))
              : SingleChildScrollView(
                child: Column(
                  children:
                      list
                          .asMap()
                          .entries
                          .map(
                            (auction) => AuctionTile(
                              myId: myId,
                              auction: auction.value,
                              index: auction.key,
                            ),
                          )
                          .toList(),
                ),
              );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}
