import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:wheels_kart/common/components/app_empty_text.dart';
import 'package:wheels_kart/common/utils/routes.dart';
import 'package:wheels_kart/module/Dealer/core/components/v_loading.dart';
import 'package:wheels_kart/module/Dealer/features/screens/favorates/data/controller/wishlist%20controller/v_wishlist_controller_cubit.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/controller/v%20dashboard%20controller/v_dashboard_controlller_bloc.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/screens/car_details_screen.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/screens/widgets/vehicle_card.dart';

class VCarCardBuilder extends StatefulWidget {
  const VCarCardBuilder({super.key});

  @override
  State<VCarCardBuilder> createState() => _VCarCardBuilderState();
}

List<bool> myLikes = [];

class _VCarCardBuilderState extends State<VCarCardBuilder> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VDashboardControlllerBloc, VDashboardControlllerState>(
      builder: (context, state) {
        switch (state) {
          case VDashboardControllerErrorState():
            {
              return SliverToBoxAdapter(
                child: AppEmptyText(text: state.errorMesage),
              );
            }

          case VDashboardControllerSuccessState():
            {
              final carList = state.listOfCars;

              return SliverToBoxAdapter(
                child: AnimationLimiter(
                  child: ListView.builder(
                    padding: EdgeInsets.only(top: 10),
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      myLikes.add(carList[index].isLiked == 1 ? true : false);
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        child: SlideAnimation(
                          verticalOffset: 50.0,

                          child: FadeInAnimation(
                            child: CVehicleCard(
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
                                final isLiked = await Navigator.of(
                                  context,
                                ).push(
                                  AppRoutes.createRoute(
                                    VCarDetailsScreen(
                                      inspectionId: carList[index].inspectionId,
                                      isLiked:
                                          carList[index].isLiked == 1
                                              ? true
                                              : false,
                                    ),
                                  ),
                                );
                                myLikes[index]=isLiked;
                                setState(() {          
                                });
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
              return SliverToBoxAdapter(
                child: Align(child: VLoadingIndicator()),
              );
            }
        }
      },
    );
  }
}
