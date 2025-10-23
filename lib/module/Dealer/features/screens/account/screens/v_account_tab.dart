import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:wheels_kart/common/components/app_empty_text.dart';
import 'package:wheels_kart/common/components/app_margin.dart';
import 'package:wheels_kart/common/components/app_spacer.dart';
import 'package:wheels_kart/common/config/pushnotification_controller.dart';
import 'package:wheels_kart/common/controllers/auth%20cubit/auth_cubit.dart';
import 'package:wheels_kart/common/dimensions.dart';
import 'package:wheels_kart/common/utils/responsive_helper.dart';
import 'package:wheels_kart/common/utils/routes.dart';
import 'package:wheels_kart/module/Dealer/core/components/v_loading.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_colors.dart';
import 'package:wheels_kart/module/Dealer/features/screens/account/data/controller/profile%20controller/v_profile_controller_cubit.dart';
import 'package:wheels_kart/module/Dealer/features/screens/account/data/model/v_profile_model.dart';
import 'package:wheels_kart/module/Dealer/features/screens/account/screens/colledted_documetnts_screen.dart';
import 'package:wheels_kart/module/Dealer/features/screens/account/screens/payments/payment_history.dart';
import 'package:wheels_kart/module/Dealer/features/screens/account/screens/settngs_screen.dart';
import 'package:wheels_kart/module/Dealer/features/screens/account/screens/terms_and_condition_screen.dart';
import 'package:wheels_kart/module/Dealer/features/screens/my%20auction%20and%20ocb/screens/v_mybid_screen.dart';
import 'package:wheels_kart/module/Dealer/features/screens/account/screens/v_edit_profile_screen.dart';
import 'package:wheels_kart/module/Dealer/features/widgets/v_custom_button.dart';
import 'package:wheels_kart/module/Dealer/core/blocs/v%20nav%20controller/v_nav_controller_cubit.dart';
import 'package:wheels_kart/module/Dealer/core/v_style.dart';

class VAccountTab extends StatefulWidget {
  const VAccountTab({super.key});

  @override
  State<VAccountTab> createState() => _VAccountTabState();
}

class _VAccountTabState extends State<VAccountTab>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    // context.read<VProfileControllerCubit>().onFetchProfile(context);
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      onRefresh: () async {
        context.read<VProfileControllerCubit>().onFetchProfile(context);
      },
      child: BlocBuilder<VProfileControllerCubit, VProfileControllerState>(
        builder: (context, state) {
          switch (state) {
            case VProfileControllerErrorState():
              {
                return AppEmptyText(text: state.error);
              }
            case VProfileControllerSuccessState():
              {
                final model = state.profileModel;
                return SafeArea(
                  child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: AppMargin(
                              child: Column(
                                children: [
                                  AppSpacer(heightPortion: .02),

                                  // Profile Header Section
                                  _buildProfileHeader(context, model),

                                  AppSpacer(heightPortion: .03),

                                  // Account Info Section
                                  _buildAccountInfoSection(context, model),

                                  AppSpacer(heightPortion: .02),

                                  // Quick Actions Section
                                  _buildQuickActionsSection(context, model),

                                  AppSpacer(heightPortion: .02),

                                  // Settings Section
                                  _buildSettingsSection(context),

                                  AppSpacer(heightPortion: .02),

                                  // Logout Button
                                  _buildLogoutButton(context),

                                  AppSpacer(heightPortion: .02),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
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

  Widget _buildProfileHeader(BuildContext context, VProfileModel model) {
    return Container(
      padding: const EdgeInsets.all(24),
      width: w(context),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            VColors.SECONDARY.withOpacity(0.1),
            VColors.SECONDARY.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusSize15 + 5),
        border: Border.all(color: VColors.SECONDARY.withOpacity(0.2), width: 1),
      ),
      child: Column(
        children: [
          // Profile Avatar
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [VColors.SECONDARY, VColors.SECONDARY.withOpacity(0.7)],
              ),
              boxShadow: [
                BoxShadow(
                  color: VColors.SECONDARY.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Icon(
              SolarIconsOutline.user,
              size: 35,
              color: VColors.WHITE,
            ),
          ),

          AppSpacer(heightPortion: .02),

          // Name and Bidder ID
          Text(
            model.vendorName,
            style: VStyle.style(
              context: context,
              fontWeight: FontWeight.bold,
              size: AppDimensions.fontSize18(context),
              color: VColors.SECONDARY,
            ),
          ),

          AppSpacer(heightPortion: .003),

          // Bidder ID
          Text(
            "ID: ${model.bidderId}",
            style: VStyle.style(
              context: context,
              fontWeight: FontWeight.w600,
              size: AppDimensions.fontSize18(context),
              color: VColors.SECONDARY.withOpacity(0.7),
            ),
          ),

          AppSpacer(heightPortion: .005),

          model.vendorStatus == "ACTIVE"
              ? Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "Active Dealer",
                      style: VStyle.style(
                        context: context,
                        size: 12,
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )
              : SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _buildAccountInfoSection(BuildContext context, VProfileModel model) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: w(context),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: VColors.SECONDARY.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
        borderRadius: BorderRadius.circular(AppDimensions.radiusSize15 + 5),
        color: VColors.WHITE,
        border: Border.all(color: VColors.GREY.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(SolarIconsOutline.user, color: VColors.SECONDARY, size: 20),
              const SizedBox(width: 8),
              Text(
                "Account Information",
                style: VStyle.style(
                  context: context,
                  fontWeight: FontWeight.bold,
                  size: AppDimensions.fontSize16(context),
                  color: VColors.SECONDARY,
                ),
              ),
            ],
          ),

          AppSpacer(heightPortion: .02),

          _buildInfoItem(
            "Full Name",
            model.vendorName,
            SolarIconsOutline.user,
            context,
            isFirst: true,
          ),

          _buildInfoItem(
            "Phone Number",
            model.vendorMobileNumber,
            SolarIconsOutline.phone,
            context,
          ),

          _buildInfoItem(
            "Email Address",
            model.vendorEmail,
            CupertinoIcons.mail,
            context,
          ),

          _buildInfoItem(
            "Location",
            model.vendorCity,
            CupertinoIcons.location,
            context,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsSection(BuildContext context, VProfileModel model) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: w(context),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: VColors.SECONDARY.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
        borderRadius: BorderRadius.circular(AppDimensions.radiusSize15 + 5),
        color: VColors.WHITE,
        border: Border.all(color: VColors.GREY.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                SolarIconsOutline.widget,
                color: VColors.SECONDARY,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                "Quick Actions",
                style: VStyle.style(
                  context: context,
                  fontWeight: FontWeight.bold,
                  size: AppDimensions.fontSize16(context),
                  color: VColors.SECONDARY,
                ),
              ),
            ],
          ),

          AppSpacer(heightPortion: .02),

          Row(
            children: [
              Expanded(
                child: _buildActionCard(
                  "Edit Profile",
                  SolarIconsOutline.pen,
                  context,
                  onTap: () {
                    Navigator.of(context).push(
                      AppRoutes.createRoute(VEditProfileScreen(model: model)),
                    );
                  },
                ),
              ),

              AppSpacer(widthPortion: .04),
              Expanded(
                child: _buildActionCard(
                  "Payments",
                  Icons.payments,
                  context,
                  onTap: () {
                    Navigator.of(
                      context,
                    ).push(AppRoutes.createRoute(VPaymentHistoryScreen()));
                  },
                ),
              ),
              // const SizedBox(width: 12),
              // Expanded(
              //   child: _buildActionCard(
              //     "Change Password",
              //     SolarIconsOutline.lock,
              //     context,
              //     onTap: () {
              //       // Navigate to change password
              //     },
              //   ),
              // ),
            ],
          ),
          AppSpacer(heightPortion: .02),
          Row(
            children: [
              Expanded(
                child: _buildActionCard(
                  "Collected Documents",
                  SolarIconsOutline.documents,
                  context,
                  onTap: () {
                    Navigator.of(
                      context,
                    ).push(AppRoutes.createRoute(VCollectedDocumentsScreen()));
                  },
                ),
              ),

              // AppSpacer(widthPortion: .04),

              // const SizedBox(width: 12),
              // Expanded(
              //   child: _buildActionCard(
              //     "Change Password",
              //     SolarIconsOutline.lock,
              //     context,
              //     onTap: () {
              //       // Navigate to change password
              //     },
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: w(context),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: VColors.SECONDARY.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
        borderRadius: BorderRadius.circular(AppDimensions.radiusSize15 + 5),
        color: VColors.WHITE,
        border: Border.all(color: VColors.GREY.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                SolarIconsOutline.settings,
                color: VColors.SECONDARY,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                "Settings & Preferences",
                style: VStyle.style(
                  context: context,
                  fontWeight: FontWeight.bold,
                  size: AppDimensions.fontSize16(context),
                  color: VColors.SECONDARY,
                ),
              ),
            ],
          ),

          AppSpacer(heightPortion: .02),

          // _buildSettingsItem(
          //   "Bidding History",
          //   "Tap to view your bidding records",
          //   SolarIconsOutline.list,
          //   context,
          //   onTap: () {
          //     Navigator.of(context).push(AppRoutes.createRoute(VMyBidTab()));
          //   },
          //   isFirst: true,
          // ),

          // _buildSettingsItem(
          //   "Notifications",
          //   "Manage your notification preferences",
          //   SolarIconsOutline.bell,
          //   context,
          //   onTap: () {},
          //   isFirst: true,
          // ),
          _buildSettingsItem(
            "Settings",
            "Manage your account",
            SolarIconsOutline.settings,
            context,
            onTap: () {
              Navigator.of(
                context,
              ).push(AppRoutes.createRoute(VSettngsScreen()));
            },
            isFirst: true,
          ),
          _buildSettingsItem(
            "Terms & Conditions",
            "Read our terms and policies",
            SolarIconsOutline.document,
            context,
            onTap: () {
              Navigator.of(
                context,
              ).push(AppRoutes.createRoute(const VTermsAndConditionScreen()));
            },
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(
    String label,
    String value,
    IconData icon,
    BuildContext context, {
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : 12, top: isFirst ? 0 : 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: VColors.GREY.withOpacity(0.05),
        border: Border.all(color: VColors.GREY.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: VColors.SECONDARY.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: VColors.SECONDARY, size: 18),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: VStyle.style(
                    context: context,
                    size: 12,
                    color: VColors.GREY,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: VStyle.style(
                    context: context,
                    size: 15,
                    color: VColors.SECONDARY,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
    String title,
    IconData icon,
    BuildContext context, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: VColors.SECONDARY.withOpacity(0.05),
          border: Border.all(color: VColors.SECONDARY.withOpacity(0.1)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: VColors.SECONDARY.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: VColors.SECONDARY, size: 24),
            ),

            const SizedBox(height: 8),

            Text(
              title,
              textAlign: TextAlign.center,
              style: VStyle.style(
                context: context,
                size: 13,
                color: VColors.SECONDARY,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem(
    String title,
    String subtitle,
    IconData icon,
    BuildContext context, {
    VoidCallback? onTap,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: isLast ? 0 : 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: VColors.GREY.withOpacity(0.05),
          border: Border.all(color: VColors.GREY.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: VColors.SECONDARY.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: VColors.SECONDARY, size: 18),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: VStyle.style(
                      context: context,
                      size: 15,
                      color: VColors.SECONDARY,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: VStyle.style(
                      context: context,
                      size: 12,
                      color: VColors.GREY,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),

            Icon(CupertinoIcons.chevron_right, color: VColors.GREY, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    // return VCustomButton(
    //   bgColor: VColors.ERROR,
    //   title: "LOGOUT",
    //   onTap: () {
    //     _showLogoutDialog(context);
    //   },
    // );
    return ElevatedButton.icon(
      onPressed: () {
        _showLogoutDialog(context);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: VColors.ERROR.withAlpha(150),
        minimumSize: Size(w(context), 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      icon: const Icon(
        CupertinoIcons.square_arrow_right,
        color: VColors.WHITE,
        weight: 10,
      ),
      label: Text(
        "Logout",
        style: VStyle.style(
          context: context,

          color: VColors.WHITE,
          size: 17,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(SolarIconsOutline.logout, color: Colors.red, size: 24),
              const SizedBox(width: 8),
              const Text("Logout"),
            ],
          ),
          content: const Text(
            "Are you sure you want to logout from your account?",
          ),
          actions: [
            TextButton(
              child: Text(
                "Cancel",
                style: VStyle.style(
                  context: context,
                  color: VColors.GREY,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                "Logout",
                style: VStyle.style(
                  context: context,
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () {
              
                PushNotificationConfig().deleteToken();
                context.read<AppAuthController>().clearPreferenceData(context);
              },
            ),
          ],
        );
      },
    );
  }
}
