import 'package:flutter/material.dart';
import 'package:wheels_kart/common/components/app_spacer.dart';
import 'package:wheels_kart/common/dimensions.dart';
import 'package:wheels_kart/module/VENDOR/core/const/v_colors.dart';
import 'package:wheels_kart/module/vendor/core/v_style.dart';
import 'package:wheels_kart/module/vendor/data/models/vehicle_model.dart';

class CVehicleCard extends StatefulWidget {
  final VehicleModel vehicle;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onPressCard;

  const CVehicleCard({
    super.key,
    required this.vehicle,
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.onPressCard,
  });

  @override
  State<CVehicleCard> createState() => _CVehicleCardState();
}

class _CVehicleCardState extends State<CVehicleCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: VColors.WHITE,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: VColors.BLACK.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          GestureDetector(
            onTap: widget.onPressCard,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Vehicle Image
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    color: VColors.LIGHT_GREY,
                    child: const Icon(
                      Icons.directions_car,
                      size: 80,
                      color: VColors.DARK_GREY,
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Vehicle Name and Model
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.vehicle.name,
                                  style: VStyle.style(
                                    context: context,
                                    size: 20,
                                    fontWeight: FontWeight.bold,
                                    color: VColors.BLACK,
                                  ),
                                ),
                                Text(
                                  widget.vehicle.model,
                                  style: VStyle.style(
                                    context: context,
                                    size: 16,
                                    color: VColors.DARK_GREY,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _buildDetailChip(
                            Icons.location_on_rounded,
                            "Malappuram,Kerala",
                            VColors.DARK_GREY,
                          ),
                        ],
                      ),

                      AppSpacer(heightPortion: .012),

                      // Vehicle Details
                      Row(
                        children: [
                          _buildDetailChip(
                            Icons.local_gas_station,
                            widget.vehicle.fuelType,
                            widget.vehicle.fuelType == 'Petrol'
                                ? VColors.SUCCESS
                                : VColors.WARNING,
                          ),
                          const SizedBox(width: 8),
                          _buildDetailChip(
                            Icons.speed,
                            '${widget.vehicle.kmDriven} km',
                            VColors.SECONDARY,
                          ),
                        ],
                      ),

                      AppSpacer(heightPortion: .008),

                      Row(
                        children: [
                          _buildDetailChip(
                            Icons.person,
                            widget.vehicle.ownership,
                            VColors.ACCENT,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Reg: ${widget.vehicle.regNumber}',
                              style: VStyle.style(
                                context: context,
                                size: 12,
                                color: VColors.DARK_GREY,
                              ),
                            ),
                          ),
                        ],
                      ),

                      AppSpacer(heightPortion: .012),

                      // Features
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children:
                            widget.vehicle.features.map((feature) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: VColors.LIGHT_GREY,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  feature,
                                  style: VStyle.style(
                                    context: context,
                                    size: 11,
                                    color: VColors.DARK_GREY,
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                      AppSpacer(heightPortion: .02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Current bid",
                            style: VStyle.style(
                              context: context,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          AppSpacer(widthPortion: .02,),
                          Text(
                            widget.vehicle.price,
                            style: VStyle.style(
                              context: context,
                              size: 18,
                              fontWeight: FontWeight.bold,
                              color: VColors.BLACK,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 10,
            top: 10,
            child: IconButton(
              color: widget.isFavorite ? VColors.ACCENT : VColors.GREYHARD,
              onPressed: widget.onFavoriteToggle,
              icon: Icon(
                widget.isFavorite ? Icons.favorite : Icons.favorite_border,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: VStyle.style(
              context: context,
              size: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
