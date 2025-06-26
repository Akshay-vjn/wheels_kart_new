


import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wheels_kart/common/components/app_empty_text.dart';
import 'package:wheels_kart/common/components/app_spacer.dart';
import 'package:wheels_kart/common/dimensions.dart';
import 'package:wheels_kart/common/utils/responsive_helper.dart';
import 'package:wheels_kart/common/utils/routes.dart';
import 'package:wheels_kart/module/VENDOR/core/components/v_loading.dart';
import 'package:wheels_kart/module/VENDOR/core/const/v_colors.dart';
import 'package:wheels_kart/module/VENDOR/core/v_style.dart';
import 'package:wheels_kart/module/VENDOR/features/screens/home/data/controller/v%20dashboard%20controller/v_dashboard_controlller_bloc.dart';
import 'package:wheels_kart/module/VENDOR/features/screens/home/screens/car_details_screen.dart';
import 'package:wheels_kart/module/VENDOR/features/screens/home/screens/widgets/vehicle_card.dart';

class VHomeTab extends StatefulWidget {
  const VHomeTab({super.key});

  @override
  State<VHomeTab> createState() => _VHomeTabState();
}

class _VHomeTabState extends State<VHomeTab> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Sample vehicle data

  Set<String> favoriteVehicles = {};
  bool isScrolled = false;
  @override
  void initState() {
    super.initState();
    context.read<VDashboardControlllerBloc>().add(
      OnFetchVendorDashboardApi(context: context),
    );
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
      body: BlocBuilder<VDashboardControlllerBloc, VDashboardControlllerState>(
        builder: (context, state) {
          switch (state) {
            case VDashboardControllerErrorState():
              {
                return AppEmptyText(text: state.errorMesage);
              }

            case VDashboardControllerSuccessState():
              {
                final carList = state.listOfCars;
                return CustomScrollView(
                  // physics: NeverScrollableScrollPhysics(),
                  controller: _scrollController,
                  slivers: [
                    // Custom Sliver App Bar
                    SliverAppBar(
                      surfaceTintColor: VColors.WHITE,
                      automaticallyImplyLeading: false,
                      expandedHeight: h(context) * .15,
                      toolbarHeight: h(context) * .08,
                      floating: false,
                      pinned: true,
                      elevation: 5,
                      backgroundColor: VColors.WHITE,
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Welcome back,",
                                style: VStyle.style(
                                  context: context,
                                  color: VColors.GREY,
                                  fontWeight: FontWeight.w300,
                                  size: AppDimensions.fontSize15(context),
                                ),
                              ),
                              AppSpacer(heightPortion: .005),
                              Text(
                                "Akbar",
                                style: VStyle.style(
                                  context: context,
                                  color: VColors.REDHARD,
                                  fontWeight: FontWeight.bold,
                                  size: AppDimensions.fontSize24(context),
                                ),
                              ),
                            ],
                          ),
                          isScrolled
                              ? Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                ),
                                child: FadeIn(
                                  child: _buildNotificationButton(),
                                ),
                              )
                              : SizedBox(),
                        ],
                      ),
                      flexibleSpace: FlexibleSpaceBar(
                        // collapseMode: CollapseMode.parallax,
                        centerTitle: false,
                        titlePadding: EdgeInsets.all(20),

                        background: SafeArea(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 20,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: VColors.WHITE,
                                      borderRadius: BorderRadius.circular(25),
                                      boxShadow: [
                                        BoxShadow(
                                          color: VColors.GREENHARD.withAlpha(
                                            50,
                                          ),
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

                    // Vehicle List
                    SliverPadding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 5,
                      ),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          return CVehicleCard(
                            vehicle: carList[index],
                            isFavorite: favoriteVehicles.contains(
                              carList[index].inspectionId,
                            ),
                            onFavoriteToggle: () {
                              setState(() {
                                if (favoriteVehicles.contains(
                                  carList[index].inspectionId,
                                )) {
                                  favoriteVehicles.remove(
                                    carList[index].inspectionId,
                                  );
                                } else {
                                  favoriteVehicles.add(
                                    carList[index].inspectionId,
                                  );
                                }
                              });
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
                      ),
                    ),

                    // Bottom padding
                    const SliverToBoxAdapter(child: SizedBox(height: 20)),
                  ],
                );
              }
            default:
              {
                return Center(child: VLoadingIndicator());
              }
          }
        },
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
          color: VColors.SECONDARY.withAlpha(50),
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
