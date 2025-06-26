import 'package:flutter/material.dart';
import 'package:wheels_kart/common/components/app_margin.dart';
import 'package:wheels_kart/common/components/app_spacer.dart';
import 'package:wheels_kart/common/dimensions.dart';
import 'package:wheels_kart/module/VENDOR/core/v_style.dart';
import 'package:wheels_kart/module/VENDOR/features/screens/home/data/model/v_car_model.dart';
import 'package:wheels_kart/module/VENDOR/features/screens/home/screens/widgets/vehicle_card.dart';
import 'package:wheels_kart/module/vendor/core/const/v_colors.dart';

class VFavTab extends StatelessWidget {
  const VFavTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: VColors.WHITE,
        surfaceTintColor: VColors.WHITE,
        centerTitle: false,
        elevation: 5,
        title: Text(
          "For You",
          style: VStyle.style(
            context: context,
            size: AppDimensions.fontSize18(context),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: AppMargin(
        child: Column(
          children: [
            AppSpacer(heightPortion: .02),
            CVehicleCard(
              isFavorite: true,
              onFavoriteToggle: () {},
              onPressCard: () {},
              vehicle: VCarModel(
                inspectionId: "1",
                modelName: "Swift",
                frontImage: "",
                manufacturingYear: "2000",
                fuelType: "Petrol",
                kmsDriven: "1000 - 20000",
                regNo: "KL12AB1223",
                city: "Mapappalli",
                currentBid: "100000",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
