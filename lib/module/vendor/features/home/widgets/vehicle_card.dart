
import 'package:flutter/material.dart';
import 'package:wheels_kart/module/VENDOR/core/const/v_colors.dart';
import 'package:wheels_kart/module/VENDOR/features/home/home_tab.dart';

class VehicleCard extends StatelessWidget {
  final VehicleModel vehicle;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onBuyPressed;

  const VehicleCard({
    super.key,
    required this.vehicle,
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.onBuyPressed,
  });

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Vehicle Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Container(
              height: 200,
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
                            vehicle.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: VColors.BLACK,
                            ),
                          ),
                          Text(
                            vehicle.model,
                            style: const TextStyle(
                              fontSize: 16,
                              color: VColors.DARK_GREY,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      vehicle.price,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: VColors.PRIMARY,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Vehicle Details
                Row(
                  children: [
                    _buildDetailChip(
                      Icons.local_gas_station,
                      vehicle.fuelType,
                      vehicle.fuelType == 'Petrol'
                          ? VColors.SUCCESS
                          : VColors.WARNING,
                    ),
                    const SizedBox(width: 8),
                    _buildDetailChip(
                      Icons.speed,
                      '${vehicle.kmDriven} km',
                      VColors.SECONDARY,
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    _buildDetailChip(
                      Icons.person,
                      vehicle.ownership,
                      VColors.ACCENT,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Reg: ${vehicle.regNumber}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: VColors.DARK_GREY,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Features
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children:
                      vehicle.features.map((feature) {
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
                            style: const TextStyle(
                              fontSize: 11,
                              color: VColors.DARK_GREY,
                            ),
                          ),
                        );
                      }).toList(),
                ),

                const SizedBox(height: 16),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: ElevatedButton(
                        onPressed: onBuyPressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: VColors.PRIMARY,
                          foregroundColor: VColors.WHITE,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Buy Now',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onFavoriteToggle,
                        style: OutlinedButton.styleFrom(
                          foregroundColor:
                              isFavorite ? VColors.REDHARD : VColors.DARK_GREY,
                          side: BorderSide(
                            color:
                                isFavorite ? VColors.REDHARD : VColors.GREYHARD,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
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
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
