import 'package:flutter/material.dart';
import 'package:wheels_kart/common/dimensions.dart';
import 'package:wheels_kart/common/utils/routes.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_colors.dart';
import 'package:wheels_kart/module/VENDOR/features/screens/home/car_details_screen.dart';
import 'package:wheels_kart/module/VENDOR/features/screens/home/widgets/vehicle_card.dart';
import 'package:wheels_kart/module/VENDOR/helper/models/vehicle_model.dart';
import 'package:wheels_kart/module/vendor/core/const/v_colors.dart';
import 'package:wheels_kart/module/vendor/core/v_style.dart';

class VHomeTab extends StatefulWidget {
  const VHomeTab({super.key});

  @override
  State<VHomeTab> createState() => _VHomeTabState();
}

class _VHomeTabState extends State<VHomeTab> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Sample vehicle data
  final List<VehicleModel> vehicles = [
    VehicleModel(
      id: '1',
      name: 'Honda City',
      model: '2022',
      fuelType: 'Petrol',
      regNumber: 'KA 01 AB 1234',
      ownership: '1st Owner',
      kmDriven: '15,000',
      price: '₹12,50,000',
      imageUrl: 'https://via.placeholder.com/300x200',
      features: ['ABS', 'Airbags', 'AC', 'Power Steering'],
    ),
    VehicleModel(
      id: '2',
      name: 'Maruti Swift',
      model: '2021',
      fuelType: 'Petrol',
      regNumber: 'KA 02 CD 5678',
      ownership: '2nd Owner',
      kmDriven: '25,000',
      price: '₹7,80,000',
      imageUrl: 'https://via.placeholder.com/300x200',
      features: ['ABS', 'AC', 'Central Lock'],
    ),
    VehicleModel(
      id: '3',
      name: 'Hyundai Creta',
      model: '2023',
      fuelType: 'Diesel',
      regNumber: 'KA 03 EF 9012',
      ownership: '1st Owner',
      kmDriven: '8,500',
      price: '₹18,90,000',
      imageUrl: 'https://via.placeholder.com/300x200',
      features: ['ABS', 'Airbags', 'Sunroof', 'Touchscreen'],
    ),
  ];

  Set<String> favoriteVehicles = {};
  bool isScrolled = false;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _scrollController.addListener(() {
        if (_scrollController.offset > 0) {
          isScrolled = true;
        } else {
          isScrolled = false;
        }
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VColors.WHITEBGCOLOR,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Custom Sliver App Bar
          SliverAppBar(
            automaticallyImplyLeading: false,
            expandedHeight: 100,
            floating: false,
            pinned: false,
            elevation: 0,
            backgroundColor: VColors.WHITE,

            flexibleSpace: FlexibleSpaceBar(
              // collapseMode: CollapseMode.parallax,
              centerTitle: false,
              titlePadding: EdgeInsets.all(20),
              title:
                  isScrolled
                      ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "WheelsKart",
                            style: VStyle.style(
                              context: context,
                              color: VColors.BLACK,
                              fontWeight: FontWeight.bold,
                              size: AppDimensions.fontSize24(context),
                            ),
                          ),
                        ],
                      )
                      : SizedBox(),
              background: SafeArea(
                child: Container(
                  decoration: BoxDecoration(
                    // gradient: LinearGradient(
                    //   begin: Alignment.topCenter,
                    //   end: Alignment.bottomCenter,
                    //   // colors: [VColors.SECONDARY.withAlpha(120), VColors.WHITE.withAlpha(120)],
                    // ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: VColors.WHITE,
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: VColors.BLACK.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: _searchController,
                              decoration: const InputDecoration(
                                hintText: 'Search vehicles...',
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: VColors.DARK_GREY,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 15,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        _buildNotificationButton(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Vehicle List
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16,vertical: 5),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return CVehicleCard(
                  vehicle: vehicles[index],
                  isFavorite: favoriteVehicles.contains(vehicles[index].id),
                  onFavoriteToggle: () {
                    setState(() {
                      if (favoriteVehicles.contains(vehicles[index].id)) {
                        favoriteVehicles.remove(vehicles[index].id);
                      } else {
                        favoriteVehicles.add(vehicles[index].id);
                      }
                    });
                  },
                  onPressCard: () {
                    // Handle buy action
                    Navigator.of(context).push(AppRoutes.createRoute(VCarDetailsScreen())); 
                  },
                );
              }, childCount: vehicles.length),
            ),
          ),

          // Bottom padding
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }

  Widget _buildNotificationButton() => Container(
    height: 50,
    width: 50,
    decoration: BoxDecoration(
      color: VColors.WHITE,
      borderRadius: BorderRadius.circular(25),
      boxShadow: [
        BoxShadow(
          color: VColors.BLACK.withOpacity(0.1),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: IconButton(
      onPressed: () {
        // Handle notification tap
      },
      icon: const Icon(Icons.notifications_outlined, color: VColors.SECONDARY),
    ),
  );
}
