import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:wheels_kart/common/components/app_empty_text.dart';
import 'package:wheels_kart/common/controllers/auth%20cubit/auth_cubit.dart';
import 'package:wheels_kart/common/utils/responsive_helper.dart';
import 'package:wheels_kart/module/Dealer/core/components/v_loading.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/controller/v%20auction%20controller/v_dashboard_controlller_bloc.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/screens/widgets/Auction/auction_vehicle_card.dart';

class VAuctionCarBuilder extends StatefulWidget {
  const VAuctionCarBuilder({super.key});

  @override
  State<VAuctionCarBuilder> createState() => _VAuctionCarBuilderState();
}

// List<bool> myLikes = [];

class _VAuctionCarBuilderState extends State<VAuctionCarBuilder> {
  @override
  void initState() {
    // WEB SOCKET COONECTION
    context.read<VAuctionControlllerBloc>().add(ConnectWebSocket());
    _getMyId();
    super.initState();
  }

  String myId = "";
  Future<void> _getMyId() async {
    final userData = await context.read<AppAuthController>().getUserData;
    myId = userData.userId ?? '';
    log("My Id :$myId");
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
                child: AnimationLimiter(
                  child: ListView.builder(
                    padding: EdgeInsets.only(top: 10),
                    itemBuilder: (context, index) {
                      // myLikes.add(
                      //   carList[index].wishlisted == 1 ? true : false,
                      // );
                      return AnimationConfiguration.staggeredList(
                        position: index,

                        duration: const Duration(milliseconds: 375),
                        child: SlideAnimation(
                          verticalOffset: 50.0,

                          child: FadeInAnimation(
                            child: VAuctionVehicleCard(
                              myId: myId,

                              vehicle: carList[index],
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: carList.length,
                  ),
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
