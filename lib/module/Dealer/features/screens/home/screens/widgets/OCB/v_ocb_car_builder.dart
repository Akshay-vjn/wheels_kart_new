import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:wheels_kart/common/components/app_margin.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/controller/v%20dashboard%20controller/v_dashboard_controlller_bloc.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/model/v_car_model.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/screens/widgets/OCB/v_ocb_car_card.dart';

class VOCBCarBuilder extends StatelessWidget {
  final String myId;

  const VOCBCarBuilder({super.key, required this.myId});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      onRefresh: () async {
        return context.read<VDashboardControlllerBloc>().add(
          OnFetchVendorDashboardApi(context: context),
        );
      },
      child: AnimationLimiter(
        child: ListView.builder(
          padding: EdgeInsets.only(top: 10),
          itemCount: 1,
          itemBuilder:
              (context, index) => AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 375),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: VOcbCarCard(
                      isFavorite: false,
                      endTime: DateTime.now(),
                      myId: "1",
                      onFavoriteToggle: () {},
                      onPressCard: () {},
                      vehicle: VCarModel(
                        inspectionId: "1",
                        evaluationId: "ABC123",
                        modelName: "Swift",
                        frontImage: "",
                        manufacturingYear: "2012",
                        fuelType: "Petrol",
                        kmsDriven: "10000",
                        regNo: "KL10AB1333",
                        city: "Eranamkulam",
                        soldTo: "Open",
                        soldName: "soldName",
                        currentBid: "200300",
                        bidStatus: "Open",
                        bidClosingTime: DateTime.now(),
                        wishlisted: 1,
                        status: "status",
                      ),
                    ),
                  ),
                ),
              ),
        ),
      ),
    );
  }
}
