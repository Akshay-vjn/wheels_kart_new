import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:wheels_kart/core/constant/colors.dart';
import 'package:wheels_kart/core/constant/dimensions.dart';
import 'package:wheels_kart/core/constant/style.dart';
import 'package:wheels_kart/core/utils/responsive_helper.dart';
import 'package:wheels_kart/core/components/app_spacer.dart';
import 'package:wheels_kart/core/utils/routes.dart';
import 'package:wheels_kart/module/evaluator/UI/screens/leads/ev_add_new_lead_scree.dart';
import 'package:wheels_kart/module/evaluator/UI/screens/home/ev_profile_screen.dart';
import 'package:wheels_kart/module/evaluator/UI/screens/leads/completed/e_completed_evaluation_list.dart';
import 'package:wheels_kart/module/evaluator/UI/screens/leads/pending/ev_pending_leads.dart';

import 'package:wheels_kart/module/evaluator/UI/screens/leads/live/ev_live_leads_tab.dart';
import 'package:wheels_kart/module/evaluator/data/bloc/get%20data/fetch_dashboard/ev_fetch_dashboard_bloc.dart';
import 'package:wheels_kart/module/evaluator/data/cubit/app%20navigation%20cubit/app_navigation_cubit.dart';
import 'package:wheels_kart/module/evaluator/data/cubit/auth%20cubit/auth_cubit.dart';

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
                          padding: EdgeInsets.only(left: 20),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                AppRoutes.createRoute(const EvProfileScreen()),
                              );
                            },
                            child: Column(
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
                  ).push(AppRoutes.createRoute(EvAddNewLeadScreen()));
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
}
