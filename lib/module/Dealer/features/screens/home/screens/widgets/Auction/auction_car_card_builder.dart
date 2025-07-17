import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:wheels_kart/common/components/app_empty_text.dart';
import 'package:wheels_kart/common/components/app_margin.dart';
import 'package:wheels_kart/common/utils/responsive_helper.dart';
import 'package:wheels_kart/common/utils/routes.dart';
import 'package:wheels_kart/module/Dealer/core/components/v_loading.dart';
import 'package:wheels_kart/module/Dealer/features/screens/favorates/data/controller/wishlist%20controller/v_wishlist_controller_cubit.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/controller/v%20dashboard%20controller/v_dashboard_controlller_bloc.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/screens/car_details_screen.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/screens/widgets/Auction/auction_vehicle_card.dart';

class VAuctionCarBuilder extends StatefulWidget {
  final String myId;
  const VAuctionCarBuilder({super.key, required this.myId});

  @override
  State<VAuctionCarBuilder> createState() => _VAuctionCarBuilderState();
}

List<bool> myLikes = [];

class _VAuctionCarBuilderState extends State<VAuctionCarBuilder> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VDashboardControlllerBloc, VDashboardControlllerState>(
      builder: (context, state) {
        switch (state) {
          case VDashboardControllerErrorState():
            {
              return Center(child: AppEmptyText(text: state.errorMesage));
            }
    
          case VDashboardControllerSuccessState():
            {
              final carList = state.listOfCars;
    
              return RefreshIndicator.adaptive(
                onRefresh: () async {
                  return context.read<VDashboardControlllerBloc>().add(
                    OnFetchVendorDashboardApi(context: context),
                  );
                },
                child: AnimationLimiter(
                  child: ListView.builder(
                    padding: EdgeInsets.only(top: 10),
                    itemBuilder: (context, index) {
                      myLikes.add(
                        carList[index].wishlisted == 1 ? true : false,
                      );
                      return AnimationConfiguration.staggeredList(
                        position: index,
                     
                        duration: const Duration(milliseconds: 375),
                        child: SlideAnimation(
                          verticalOffset: 50.0,
    
                          child: FadeInAnimation(
                            child: VAuctionVehicleCard(
                              myId: widget.myId,
                              endTime: carList[index].bidClosingTime,
                              vehicle: carList[index],
                              isFavorite: myLikes[index],
                              onFavoriteToggle: () async {
                                await context
                                    .read<VWishlistControllerCubit>()
                                    .onChangeFavState(
                                      context,
                                      carList[index].inspectionId,
                                    );
                                if (myLikes[index]) {
                                  myLikes[index] = false;
                                } else {
                                  myLikes[index] = true;
                                }
                                setState(() {});
                              },
                              onPressCard: () async {
                                // Handle buy action
                                if (carList[index].bidStatus != "Sold") {
                                  final isLiked = await Navigator.of(
                                    context,
                                  ).push(
                                    AppRoutes.createRoute(
                                      VCarDetailsScreen(
                                        hideBidPrice:
                                            carList[index].bidStatus !=
                                            "Open",
                                        frontImage: carList[index].frontImage,
                                        inspectionId:
                                            carList[index].inspectionId,
                                        isLiked:
                                            carList[index].wishlisted == 1
                                                ? true
                                                : false,
                                      ),
                                    ),
                                  );
    
                                  if (isLiked != null) {
                                    myLikes[index] = isLiked;
                                    setState(() {});
                                  }
                                }
                              },
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
