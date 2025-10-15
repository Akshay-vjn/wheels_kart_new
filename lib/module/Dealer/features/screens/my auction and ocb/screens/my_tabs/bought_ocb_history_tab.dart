import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wheels_kart/common/components/app_empty_text.dart';
import 'package:wheels_kart/common/components/app_spacer.dart';
import 'package:wheels_kart/module/Dealer/core/components/v_loading.dart';
import 'package:wheels_kart/module/Dealer/features/screens/my%20auction%20and%20ocb/data/controller/my%20auction%20controller/v_my_auction_controller_bloc.dart';
import 'package:wheels_kart/module/Dealer/features/screens/my%20auction%20and%20ocb/data/controller/ocb%20controller/my_ocb_controller_bloc.dart';
import 'package:wheels_kart/module/Dealer/features/screens/my%20auction%20and%20ocb/screens/widgets/ocb_tile.dart';
// import 'package:wheels_kart/module/Dealer/features/screens/my%20auction%20and%20ocb/screens/widgets/auction_tile.dart';

class BoughtOcbHistoryTab extends StatefulWidget {
  final String myId; // Pass your dealer ID

  const BoughtOcbHistoryTab({super.key, required this.myId});

  @override
  State<BoughtOcbHistoryTab> createState() => _BoughtOcbHistoryTabState();
}

class _BoughtOcbHistoryTabState extends State<BoughtOcbHistoryTab> {
  @override
  void initState() {
    super.initState();

    // Fetch OCB purchases
    context.read<MyOcbControllerBloc>().add(
      OnFetchMyOCBList(context: context),
    );

    // If you want only bought history, no need to fetch owned auctions
    // context.read<VMyAuctionControllerBloc>().add(
    //   OnGetMyAuctions(context: context),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyOcbControllerBloc, MyOcbControllerState>(
      builder: (context, ocbState) {
        // Removed auction BlocBuilder since we are not showing owned auctions
        // return BlocBuilder<VMyAuctionControllerBloc, VMyAuctionControllerState>(
        //   builder: (context, auctionState) {

        // Get OCB purchases
        final ocbList = ocbState is MyOncControllerSuccessState
            ? ocbState.myOcbList
            : [];

        // Loading state
        final isLoadingOcb = ocbState is! MyOncControllerSuccessState;

        // Show error if OCB fetch failed
        if (ocbState is MyOcbControllerErrorState) {
          return Center(child: AppEmptyText(text: ocbState.error));
        }

        // Show loading if OCB is loading
        if (isLoadingOcb) {
          return const Center(child: VLoadingIndicator());
        }

        // Show empty state if no items
        if (ocbList.isEmpty) {
          return Center(
              child: AppEmptyText(text: "No purchases found!"));
        }

        // OCB list view
        return ListView.separated(
          itemCount: ocbList.length,
          separatorBuilder: (context, index) =>
          const AppSpacer(heightPortion: .01),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          itemBuilder: (context, index) {
            final ocb = ocbList[index];
            return OcbTile(ocb: ocb);
          },
        );
        //   },
        // );
      },
    );
  }
}