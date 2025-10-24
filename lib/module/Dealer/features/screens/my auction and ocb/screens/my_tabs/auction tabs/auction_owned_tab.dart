import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wheels_kart/common/components/app_empty_text.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_colors.dart';
import 'package:wheels_kart/module/Dealer/core/v_style.dart';
import 'package:wheels_kart/module/Dealer/features/screens/my%20auction%20and%20ocb/data/controller/my%20auction%20controller/v_my_auction_controller_bloc.dart';
import 'package:wheels_kart/module/Dealer/features/screens/my%20auction%20and%20ocb/screens/widgets/auction_tile.dart';

class AuctionOwnedTab extends StatefulWidget {
  final String myId;

  const AuctionOwnedTab({super.key, required this.myId});

  @override
  State<AuctionOwnedTab> createState() => _AuctionOwnedTabState();
}

class _AuctionOwnedTabState extends State<AuctionOwnedTab> {
  @override
  void initState() {
    super.initState();
    // Fetch owned auctions when tab is initialized
    context.read<VMyAuctionControllerBloc>().add(
      OnGetMyOwnedAuctions(context: context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VMyAuctionControllerBloc, VMyAuctionControllerState>(
      builder: (context, state) {
        if (state is VMyAuctionControllerOwnedSuccessState) {
          final list = state.listOfOwnedAuctions;

          return list.isEmpty
              ? Center(child: AppEmptyText(text: "No Owned Auctions found!"))
              : SingleChildScrollView(
                child: Column(
                  children:
                      list
                          .asMap()
                          .entries
                          .map(
                            (auction) => AuctionTile(
                              myId: widget.myId,
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
