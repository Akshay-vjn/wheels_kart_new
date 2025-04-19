import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wheels_kart/core/components/app_loading_indicator.dart';

import 'package:wheels_kart/core/constant/colors.dart';
import 'package:wheels_kart/core/constant/dimensions.dart';
import 'package:wheels_kart/core/constant/style.dart';
import 'package:wheels_kart/core/utils/responsive_helper.dart';
import 'package:wheels_kart/core/components/app_spacer.dart';
import 'package:wheels_kart/core/utils/routes.dart';
import 'package:wheels_kart/module/evaluator/UI/screens/leads/ev_create_new_inspection_screen.dart';
import 'package:wheels_kart/module/evaluator/UI/screens/home/ev_profile_screen.dart';
import 'package:wheels_kart/module/evaluator/UI/screens/leads/completed/e_completed_evaluation_list.dart';
import 'package:wheels_kart/module/evaluator/UI/screens/leads/pending/ev_pending_leads.dart';

import 'package:wheels_kart/module/evaluator/UI/screens/leads/live/ev_live_leads_tab.dart';
import 'package:wheels_kart/module/evaluator/data/bloc/get%20data/fetch_dashboard/ev_fetch_dashboard_bloc.dart';
import 'package:wheels_kart/module/evaluator/data/bloc/app%20navigation%20cubit/app_navigation_cubit.dart';
import 'package:wheels_kart/module/evaluator/data/bloc/auth%20cubit/auth_cubit.dart';

class EvDashboardScreen extends StatefulWidget {
  const EvDashboardScreen({super.key});

  @override
  State<EvDashboardScreen> createState() => _EvDashboardScreenState();
}

class _EvDashboardScreenState extends State<EvDashboardScreen> {
  @override
  void initState() {
    context.read<EvFetchDashboardBloc>().add(
      OnGetDashBoadDataEvent(context: context),
    );
    super.initState();
  }

  final _pages = [EvLiveLeadsTab(), EvPendingLeadsTab(), EvCompletedLeadTab()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kSelectionColor,
      body: Column(
        children: [
          Container(
            width: w(context),
            color: AppColors.DEFAULT_BLUE_DARK,
            child: SafeArea(
              bottom: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSpacer(heightPortion: .01),
                  BlocBuilder<EvAuthBlocCubit, EvAuthBlocState>(
                    builder: (context, state) {
                      if (state is AuthCubitAuthenticateState) {
                        return Padding(
                          padding: EdgeInsets.only(left: 20, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Hi,",
                                    style: AppStyle.style(
                                      context: context,
                                      color: AppColors.white,
                                      fontWeight: FontWeight.w300,
                                      size: AppDimensions.fontSize15(context),
                                    ),
                                  ),
                                  Text(
                                    state.userModel.userName,
                                    style: AppStyle.style(
                                      color: AppColors.kSelectionColor,
                                      context: context,
                                      fontWeight: FontWeight.bold,
                                      size: AppDimensions.fontSize18(context),
                                    ),
                                  ),
                                  AppSpacer(heightPortion: .02),
                                ],
                              ),
                              TextButton(
                                onPressed: () async {
                                  showLogoutDialog(context, () async {
                                    context
                                        .read<EvAuthBlocCubit>()
                                        .clearPreferenceData(context);
                                  });
                                },
                                child: Text(
                                  "Logout",
                                  style: AppStyle.style(
                                    context: context,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.kRed,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return FadeTransition(opacity: animation, child: child);
              },

              child: BlocBuilder<EvAppNavigationCubit, EvAppNavigationState>(
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
        ],
      ),
      floatingActionButton: BlocBuilder<
        EvAppNavigationCubit,
        EvAppNavigationState
      >(
        builder: (context, state) {
          return (state is AppNavigationInitialState && state.initailIndex == 0)
              ? FloatingActionButton(
                backgroundColor: AppColors.DEFAULT_ORANGE,
                onPressed: () {
                  Navigator.of(
                    context,
                  ).push(AppRoutes.createRoute(EvCreateInspectionScreen()));
                },
                child: const Icon(CupertinoIcons.add, color: AppColors.white),
              )
              : SizedBox();
        },
      ),

      bottomNavigationBar: BlocBuilder<
        EvAppNavigationCubit,
        EvAppNavigationState
      >(
        builder: (context, state) {
          return (state is AppNavigationInitialState)
              ? BottomNavigationBar(
                currentIndex: state.initailIndex,

                backgroundColor: AppColors.DEFAULT_BLUE_DARK,
                selectedItemColor: AppColors.DEFAULT_ORANGE,
                unselectedItemColor: AppColors.white,
                selectedLabelStyle: AppStyle.style(
                  context: context,
                  color: AppColors.DEFAULT_ORANGE,
                  fontWeight: FontWeight.w500,
                  size: AppDimensions.fontSize12(context),
                ),
                unselectedLabelStyle: AppStyle.style(
                  context: context,
                  color: AppColors.white,
                  fontWeight: FontWeight.w500,
                  size: AppDimensions.fontSize12(context),
                ),

                items: [
                  _buildDestinationButton("Live Leads", CupertinoIcons.bolt),
                  _buildDestinationButton("Pending Leads", CupertinoIcons.time),
                  _buildDestinationButton(
                    "Completed Leads",
                    CupertinoIcons.check_mark_circled,
                  ),
                ],
                onTap: (value) {
                  context.read<EvAppNavigationCubit>().handleBottomnavigation(
                    value,
                  );
                },
              )
              : SizedBox();
        },
      ),
    );
  }

  BottomNavigationBarItem _buildDestinationButton(String label, IconData icon) {
    return BottomNavigationBarItem(
      // activeIcon: Icon(icon),
      icon: Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Icon(icon),
      ),
      label: label,
    );
  }

  void showLogoutDialog(
    BuildContext context,
    Future<void> Function() onConfirmLogout,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _LogoutDialog(onConfirmLogout: onConfirmLogout),
    );
  }
}

class _LogoutDialog extends StatefulWidget {
  final Future<void> Function() onConfirmLogout;

  const _LogoutDialog({super.key, required this.onConfirmLogout});

  @override
  State<_LogoutDialog> createState() => _LogoutDialogState();
}

class _LogoutDialogState extends State<_LogoutDialog> {
  bool isLoading = false;

  void _handleLogout() async {
    setState(() => isLoading = true);
    await widget.onConfirmLogout();
    if (mounted) Navigator.of(context).pop(); // Close dialog after logout
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child:
            isLoading
                ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppLoadingIndicator(),
                    SizedBox(height: 16),
                    Text(
                      "Logging out...",
                      style: AppStyle.style(context: context, size: 16),
                    ),
                  ],
                )
                : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.logout, size: 50, color: Colors.redAccent),
                    const SizedBox(height: 16),
                    const Text(
                      "Logout",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Are you sure you want to log out?",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(
                              "Cancel",
                              style: AppStyle.style(
                                context: context,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: _handleLogout,
                            child: Text(
                              "Logout",
                              style: AppStyle.style(
                                context: context,
                                color: AppColors.FILL_COLOR,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
      ),
    );
  }
}
