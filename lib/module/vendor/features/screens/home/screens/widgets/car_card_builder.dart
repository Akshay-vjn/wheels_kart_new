import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wheels_kart/common/components/app_empty_text.dart';
import 'package:wheels_kart/common/utils/routes.dart';
import 'package:wheels_kart/module/VENDOR/core/components/v_loading.dart';
import 'package:wheels_kart/module/VENDOR/features/screens/favorates/data/controller/wishlist%20controller/v_wishlist_controller_cubit.dart';
import 'package:wheels_kart/module/VENDOR/features/screens/home/data/controller/v%20dashboard%20controller/v_dashboard_controlller_bloc.dart';
import 'package:wheels_kart/module/VENDOR/features/screens/home/screens/car_details_screen.dart';
import 'package:wheels_kart/module/VENDOR/features/screens/home/screens/widgets/vehicle_card.dart';

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

              return SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  myLikes.add(carList[index].isLiked == 1 ? true : false);
                  return CVehicleCard(
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
                    onPressCard: () {
                      // Handle buy action
                      Navigator.of(context).push(
                        AppRoutes.createRoute(
                          VCarDetailsScreen(car: carList[index]),
                        ),
                      );
                    },
                  );
                }, childCount: carList.length),
              );
            }
          default:
            {
              return SliverToBoxAdapter(
                child: Center(child: VLoadingIndicator()),
              );
            }
        }
      },
    );
  }
}
