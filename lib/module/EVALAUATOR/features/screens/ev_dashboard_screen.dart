import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wheels_kart/common/components/app_spacer.dart';
import 'package:wheels_kart/common/utils/responsive_helper.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/widgets/ev_app_loading_indicator.dart';

import 'package:wheels_kart/module/EVALAUATOR/core/ev_colors.dart';
import 'package:wheels_kart/common/dimensions.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_style.dart';
import 'package:wheels_kart/common/utils/routes.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/screens/profile/ev_profile_screen.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/screens/new%20lead/ev_create_new_inspection_screen.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/screens/home/e_completed_evaluation_list.dart';

import 'package:wheels_kart/module/EVALAUATOR/features/screens/home/ev_live_leads_tab.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/bloc/get%20data/fetch_dashboard/ev_fetch_dashboard_bloc.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/bloc/app%20navigation%20cubit/app_navigation_cubit.dart';
import 'package:wheels_kart/common/controllers/auth%20cubit/auth_cubit.dart';

class EvDashboardScreen extends StatefulWidget {
  const EvDashboardScreen({super.key});

  @override
  State<EvDashboardScreen> createState() => _EvDashboardScreenState();
}

class _EvDashboardScreenState extends State<EvDashboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _headerAnimationController;
  late AnimationController _fabAnimationController;
  late Animation<double> _headerSlideAnimation;
  late Animation<double> _fabScaleAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animations
    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _headerSlideAnimation = Tween<double>(begin: -100.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _headerAnimationController,
        curve: Curves.easeOutBack,
      ),
    );

    _fabScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fabAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    // Fetch dashboard data
    context.read<EvFetchDashboardBloc>().add(
      OnGetDashBoadDataEvent(context: context),
    );

    // Start animations
    _headerAnimationController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _fabAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _headerAnimationController.dispose();
    _fabAnimationController.dispose();
    super.dispose();
  }

  final _pages = [
    EvLiveLeadsTab(),
    //  EvPendingLeadsTab(),
    EvCompletedLeadTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // Enhanced Header Section
          AnimatedBuilder(
            animation: _headerSlideAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _headerSlideAnimation.value),
                child: _buildEnhancedHeader(),
              );
            },
          ),

          // Main Content with Page Transition
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                // borderRadius: const BorderRadius.only(
                //   topLeft: Radius.circular(24),
                //   topRight: Radius.circular(24),
                // ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  transitionBuilder: (child, animation) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.1, 0),
                        end: Offset.zero,
                      ).animate(
                        CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeOutCubic,
                        ),
                      ),
                      child: FadeTransition(opacity: animation, child: child),
                    );
                  },
                  child:
                      BlocBuilder<EvAppNavigationCubit, EvAppNavigationState>(
                        builder: (context, state) {
                          if (state is AppNavigationInitialState) {
                            return _pages[state.initailIndex];
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),
                ),
              ),
            ),
          ),
        ],
      ),

      // Enhanced Floating Action Button
      floatingActionButton: BlocBuilder<
        EvAppNavigationCubit,
        EvAppNavigationState
      >(
        builder: (context, state) {
          return (state is AppNavigationInitialState && state.initailIndex == 0)
              ? AnimatedBuilder(
                animation: _fabScaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _fabScaleAnimation.value,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: EvAppColors.DEFAULT_ORANGE.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: FloatingActionButton.extended(
                        backgroundColor: EvAppColors.DEFAULT_ORANGE,
                        elevation: 0,
                        onPressed: () {
                          Navigator.of(context).push(
                            AppRoutes.createRoute(EvCreateInspectionScreen()),
                          );
                        },
                        icon: const Icon(
                          CupertinoIcons.add_circled_solid,
                          color: Colors.white,
                          size: 20,
                        ),
                        label: Text(
                          "New Inspection",
                          style: EvAppStyle.style(
                            context: context,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            size: AppDimensions.fontSize15(context),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )
              : const SizedBox();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      // Enhanced Bottom Navigation Bar
      bottomNavigationBar:
          BlocBuilder<EvAppNavigationCubit, EvAppNavigationState>(
            builder: (context, state) {
              return (state is AppNavigationInitialState)
                  ? Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      child: Container(
                        // height: 80,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildNavItem(
                              index: 0,
                              currentIndex: state.initailIndex,
                              label: "Live",
                              icon: CupertinoIcons.bolt_fill,
                              activeColor: EvAppColors.DEFAULT_ORANGE,
                              onTap: () => _onNavTap(0),
                            ),
                            // _buildNavItem(
                            //   index: 1,
                            //   currentIndex: state.initailIndex,
                            //   label: "Pending",
                            //   icon: CupertinoIcons.clock_fill,
                            //   activeColor: Colors.amber,
                            //   onTap: () => _onNavTap(1),
                            // ),
                            _buildNavItem(
                              index: 1,
                              currentIndex: state.initailIndex,
                              label: "Completed",
                              icon: CupertinoIcons.checkmark_circle_fill,
                              activeColor: Colors.green,
                              onTap: () => _onNavTap(1),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  : const SizedBox();
            },
          ),
    );
  }

  Widget _buildEnhancedHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            EvAppColors.DEFAULT_BLUE_DARK,
            EvAppColors.DEFAULT_BLUE_DARK.withOpacity(0.8),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: EvAppColors.DEFAULT_BLUE_DARK.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 20),
          child: BlocBuilder<AppAuthController, AppAuthControllerState>(
            builder: (context, state) {
              if (state is AuthCubitAuthenticateState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Welcome back,",
                                style: EvAppStyle.style(
                                  context: context,
                                  color: Colors.white.withOpacity(0.8),
                                  fontWeight: FontWeight.w400,
                                  size: AppDimensions.fontSize18(context),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                state.userModel.userName,
                                style: EvAppStyle.style(
                                  color: Colors.white,
                                  context: context,
                                  fontWeight: FontWeight.bold,
                                  size: AppDimensions.fontSize18(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                        _buildProfileSection(state.userModel.userName),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildQuickStatsRow(),
                  ],
                );
              } else {
                return const SizedBox();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection(String userName) {
    return GestureDetector(
      onTap: () => _showProfileMenu(),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 15,
              backgroundColor: EvAppColors.DEFAULT_ORANGE,
              child: Text(
                userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              CupertinoIcons.chevron_down,
              color: Colors.white,
              size: 13,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStatsRow() {
    return BlocBuilder<EvFetchDashboardBloc, EvFetchDashboardState>(
      builder: (context, state) {
        if (state is SuccessEvFetchDashboardState) {
          return Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: CupertinoIcons.bolt_fill,
                  label: "Live",
                  value: state.progressRequest,
                  color: EvAppColors.DEFAULT_ORANGE,
                ),
              ),
              // const SizedBox(width: 12),
              // Expanded(
              //   child: _buildStatCard(
              //     icon: CupertinoIcons.clock_fill,
              //     label: "Pending",
              //     value: "8",
              //     color: Colors.amber,
              //   ),
              // ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  icon: CupertinoIcons.checkmark_circle_fill,
                  label: "Completed",
                  value: state.completedRequested,
                  color: Colors.green,
                ),
              ),
            ],
          );
        } else {
          return SizedBox();
        }
      },
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                style: EvAppStyle.style(
                  context: context,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  size: AppDimensions.fontSize24(context),
                ),
              ),
              AppSpacer(widthPortion: .05),
              Icon(icon, color: color, size: 25),
            ],
          ),
      AppSpacer(heightPortion: .01,),
          Text(
            label,
            style: EvAppStyle.style(
              context: context,
              color: Colors.white.withOpacity(0.8),
              fontWeight: FontWeight.w400,
              size: AppDimensions.fontSize15(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required int currentIndex,
    required String label,
    required IconData icon,
    required Color activeColor,
    required VoidCallback onTap,
  }) {
    final isActive = index == currentIndex;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        width: w(context)*.25,
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: isActive ? activeColor.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isActive ? activeColor : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isActive ? Colors.white : Colors.grey[600],
                size: 15,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: EvAppStyle.style(
                context: context,
                color: isActive ? activeColor : Colors.grey[600]!,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w400,
                size: AppDimensions.fontSize12(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onNavTap(int index) {
    context.read<EvAppNavigationCubit>().handleBottomnavigation(index);

    // Add haptic feedback
    HapticFeedback.lightImpact();
  }

  void _showProfileMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _ProfileMenuSheet(),
    );
  }
}

class _ProfileMenuSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: const Icon(
                CupertinoIcons.person_circle,
                color: Colors.grey,
              ),
              title: const Text("Profile"),
              onTap:
                  () => Navigator.of(
                    context,
                  ).push(AppRoutes.createRoute(EvProfileScreen())),
            ),
            // ListTile(
            //   leading: const Icon(CupertinoIcons.settings, color: Colors.grey),
            //   title: const Text("Settings"),
            //   onTap: () => Navigator.pop(context),
            // ),
            // ListTile(
            //   leading: const Icon(CupertinoIcons.question_circle, color: Colors.grey),
            //   title: const Text("Help & Support"),
            //   onTap: () => Navigator.pop(context),
            // ),
            const Divider(),
            ListTile(
              leading: const Icon(
                CupertinoIcons.square_arrow_right,
                color: Colors.red,
              ),
              title: const Text("Logout", style: TextStyle(color: Colors.red)),
              onTap: () {
                _showLogoutDialog(context, () async {
                  context.read<AppAuthController>().clearPreferenceData(context);
                });
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(
    BuildContext context,
    Future<void> Function() onConfirmLogout,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => _EnhancedLogoutDialog(onConfirmLogout: onConfirmLogout),
    );
  }
}

class _EnhancedLogoutDialog extends StatefulWidget {
  final Future<void> Function() onConfirmLogout;

  const _EnhancedLogoutDialog({super.key, required this.onConfirmLogout});

  @override
  State<_EnhancedLogoutDialog> createState() => _EnhancedLogoutDialogState();
}

class _EnhancedLogoutDialogState extends State<_EnhancedLogoutDialog>
    with SingleTickerProviderStateMixin {
  bool isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleLogout() async {
    setState(() => isLoading = true);
    await widget.onConfirmLogout();
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(24),
              child:
                  isLoading
                      ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: EVAppLoadingIndicator(),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "Logging out...",
                            style: EvAppStyle.style(
                              context: context,
                              size: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      )
                      : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: const Icon(
                              CupertinoIcons.square_arrow_right,
                              size: 32,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "Logout",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Are you sure you want to log out?",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: BorderSide(
                                        color: Colors.grey[300]!,
                                      ),
                                    ),
                                  ),
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text(
                                    "Cancel",
                                    style: EvAppStyle.style(
                                      context: context,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[700]!,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: _handleLogout,
                                  child: Text(
                                    "Logout",
                                    style: EvAppStyle.style(
                                      context: context,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
            ),
          ),
        );
      },
    );
  }
}
