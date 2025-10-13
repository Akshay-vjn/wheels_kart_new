import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_colors.dart';
import 'package:wheels_kart/module/Dealer/core/v_style.dart';
import 'package:wheels_kart/module/Dealer/features/screens/account/data/controller/payment%20history%20controller/payment_history_controller_cubit.dart';
import 'package:wheels_kart/module/Dealer/features/screens/account/data/controller/rsd%20controller/rsd_controller_cubit.dart';
import 'package:wheels_kart/module/Dealer/features/screens/account/screens/tabs/payments_tab.dart';
import 'package:wheels_kart/module/Dealer/features/screens/account/screens/tabs/rsd_tab.dart';
import 'package:wheels_kart/module/Dealer/features/widgets/v_custom_backbutton.dart';

/// Payment History Screen with tabs
/// Contains two tabs: Payments and RSD
class VPaymentHistoryScreen extends StatefulWidget {
  const VPaymentHistoryScreen({super.key});

  @override
  State<VPaymentHistoryScreen> createState() => _VPaymentHistoryScreenState();
}

class _VPaymentHistoryScreenState extends State<VPaymentHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // Fetch payment history
    context.read<PaymentHistoryControllerCubit>().onGetPaymentHistory(context);
    
    // Fetch RSD history
    context.read<RsdControllerCubit>().fetchRsdList(context);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(child: _buildTabBarView()),
        ],
      ),
    );
  }

  /// Build app bar
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: VColors.WHITE,
      elevation: 0,
      leading: VCustomBackbutton(blendColor: VColors.DARK_GREY.withAlpha(50)),
      centerTitle: false,
      title: Text(
        "Payments & RSD",
        style: VStyle.style(
          context: context,
          color: VColors.BLACK,
          fontWeight: FontWeight.w700,
          size: 20,
        ),
      ),
    );
  }

  /// Build tab bar
  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: VColors.WHITE,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 0,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: VStyle.style(
          context: context,
          fontWeight: FontWeight.w700,
          size: 14,
        ),
        unselectedLabelStyle: VStyle.style(
          context: context,
          fontWeight: FontWeight.w600,
          size: 14,
        ),
        labelColor: VColors.SECONDARY,
        unselectedLabelColor: VColors.DARK_GREY,
        dividerColor: Colors.transparent,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        tabs: const [
          Tab(text: "PAYMENTS"),
          Tab(text: "RSD"),
        ],
      ),
    );
  }

  /// Build tab bar view
  Widget _buildTabBarView() {
    return TabBarView(
      controller: _tabController,
      children: const [
        PaymentsTab(),
        RsdTab(),
      ],
    );
  }
}
