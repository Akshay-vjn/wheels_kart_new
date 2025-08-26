import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wheels_kart/common/components/app_spacer.dart';
import 'package:wheels_kart/common/dimensions.dart';
import 'package:wheels_kart/module/Dealer/core/components/v_loading.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_colors.dart';
import 'package:wheels_kart/module/Dealer/core/v_style.dart';
import 'package:wheels_kart/module/Dealer/features/screens/account/data/controller/profile%20controller/v_profile_controller_cubit.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/controller/ocb%20controller/v_ocb_controller_bloc.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/controller/v%20auction%20controller/v_dashboard_controlller_bloc.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/screens/widgets/Auction/auction_car_card_builder.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/screens/widgets/OCB/v_ocb_car_builder.dart';

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
    // // WEB SOCKET COONECTION
    // context.read<VAuctionControlllerBloc>().add(ConnectWebSocket());

    //

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
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: VColors.WHITE,
        title: Column(
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
            BlocBuilder<VProfileControllerCubit, VProfileControllerState>(
              builder: (context, state) {
                return Text(
                  state is VProfileControllerSuccessState
                      ? state.profileModel.vendorName
                      : "",
                  style: VStyle.style(
                    context: context,
                    color: VColors.REDHARD,
                    fontWeight: FontWeight.bold,
                    size: AppDimensions.fontSize24(context),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: BlocBuilder<VProfileControllerCubit, VProfileControllerState>(
        builder: (context, state) {
          return DefaultTabController(
            length: 2,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(color: VColors.WHITE),
                  child: TabBar(
                    labelStyle: VStyle.style(
                      context: context,
                      fontWeight: FontWeight.bold,
                      size: 15,
                      color: VColors.SECONDARY,
                    ),
                    unselectedLabelStyle: VStyle.style(
                      context: context,
                      size: 15,
                    ),
                    dividerHeight: 2,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorWeight: 3,

                    indicatorColor: VColors.SECONDARY,
                    overlayColor: WidgetStatePropertyAll(VColors.WHITE),
                    tabs: [Tab(text: "Auctions"), Tab(text: "OCB")],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      BlocProvider(
                        create: (context) => VAuctionControlllerBloc(),
                        child: VAuctionCarBuilder(),
                      ),
                      BlocProvider(
                        create: (context) => VOcbControllerBloc(),
                        child: VOCBCarBuilder(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
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
