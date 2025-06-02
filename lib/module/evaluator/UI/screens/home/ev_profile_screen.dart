import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:wheels_kart/core/components/app_custom_widgets.dart';
import 'package:wheels_kart/core/constant/colors.dart';
import 'package:wheels_kart/core/constant/dimensions.dart';
import 'package:wheels_kart/core/constant/style.dart';
import 'package:wheels_kart/core/utils/responsive_helper.dart';
import 'package:wheels_kart/module/evaluator/data/bloc/app%20navigation%20cubit/app_navigation_cubit.dart';
import 'package:wheels_kart/module/evaluator/data/bloc/auth%20cubit/auth_cubit.dart';
import 'package:wheels_kart/module/evaluator/data/model/auth_model.dart';
import 'package:wheels_kart/core/components/app_spacer.dart';

class EvProfileScreen extends StatefulWidget {
  const EvProfileScreen({super.key});

  @override
  State<EvProfileScreen> createState() => _EvProfileScreenState();
}

class _EvProfileScreenState extends State<EvProfileScreen>
    with TickerProviderStateMixin {
  late AuthUserModel userModel;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    final state = context.read<EvAuthBlocCubit>().state;
    if (state is AuthCubitAuthenticateState) {
      userModel = state.userModel;
    }

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
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
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: CustomScrollView(
          slivers: [
            // Custom App Bar with Profile Header
            SliverToBoxAdapter(child: _buildProfileHeader()),

            // Profile Menu Items
            SliverToBoxAdapter(
              child: SlideTransition(
                position: _slideAnimation,
                child: Padding(
                  padding: EdgeInsets.all(AppDimensions.paddingSize20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AppSpacer(heightPortion: .02),

                      // Account Section
                      // _buildSectionTitle("Account"),
                      // const AppSpacer(heightPortion: .01),
                      // _buildMenuSection([
                      //   _buildProfileTile(
                      //     "Edit Profile",
                      //     SolarIconsBold.user,
                      //     () => _showEditProfileDialog(),
                      //     backgroundColor: Colors.blue[50],
                      //     iconColor: Colors.blue[600],
                      //   ),
                      //   _buildProfileTile(
                      //     "Change Password",
                      //     SolarIconsBold.lockPassword,
                      //     () => _showChangePasswordDialog(),
                      //     backgroundColor: Colors.orange[50],
                      //     iconColor: Colors.orange[600],
                      //   ),
                      //   _buildProfileTile(
                      //     "Notifications",
                      //     SolarIconsBold.notificationUnread,
                      //     () => _navigateToNotifications(),
                      //     backgroundColor: Colors.green[50],
                      //     iconColor: Colors.green[600],
                      //   ),
                      // ]),

                      // const AppSpacer(heightPortion: .03),

                      // // Support Section
                      // _buildSectionTitle("Support"),
                      // const AppSpacer(heightPortion: .01),
                      // _buildMenuSection([
                      //   _buildProfileTile(
                      //     "Help & Support",
                      //     SolarIconsBold.questionCircle,
                      //     () => _showHelpDialog(),
                      //     backgroundColor: Colors.purple[50],
                      //     iconColor: Colors.purple[600],
                      //   ),
                      //   _buildProfileTile(
                      //     "About",
                      //     SolarIconsBold.infoCircle,
                      //     () => _showAboutDialog(),
                      //     backgroundColor: Colors.indigo[50],
                      //     iconColor: Colors.indigo[600],
                      //   ),
                      // ]),

                      // const AppSpacer(heightPortion: .04),

                      // Logout Button
                      _buildLogoutButton(),

                      const AppSpacer(heightPortion: .02),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      height: h(context) * .43,
      child: Stack(
        children: [
          // Background Gradient
          Container(
            height: h(context) * .35,
            width: w(context),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.DEFAULT_BLUE_DARK,
                  AppColors.DEFAULT_BLUE_DARK.withOpacity(0.8),
                ],
              ),
            ),
            child: Stack(
              children: [
                // Decorative circles
                Positioned(
                  top: -50,
                  right: -50,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                ),
                Positioned(
                  top: 50,
                  left: -30,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.05),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Positioned(top: 50, child: customBackButton(context)),

          // Profile Avatar
          Positioned(
            top: h(context) * .12,
            left: w(context) * .5 - 60,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey[200],
                child: Icon(
                  SolarIconsBold.user,
                  size: 60,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ),

          // Profile Info Card
          Positioned(
            bottom: 0,
            left: w(context) * .05,
            right: w(context) * .05,
            child: Container(
              padding: EdgeInsets.all(AppDimensions.paddingSize20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppDimensions.radiusSize18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    userModel.userName,
                    style: AppStyle.style(
                      context: context,
                      fontWeight: FontWeight.bold,
                      size: AppDimensions.fontSize18(context),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const AppSpacer(heightPortion: .005),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        SolarIconsBold.phone,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      SizedBox(width: 8),
                      Text(
                        userModel.mobileNumber,
                        style: AppStyle.style(
                          context: context,
                          fontWeight: FontWeight.w400,
                          size: AppDimensions.fontSize15(context),
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const AppSpacer(heightPortion: .01),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingSize10,
                      vertical: AppDimensions.paddingSize5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.DEFAULT_BLUE_DARK.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusSize18,
                      ),
                    ),
                    child: Text(
                      userModel.userType,
                      style: AppStyle.style(
                        context: context,
                        fontWeight: FontWeight.w600,
                        size: AppDimensions.fontSize12(context),
                        color: AppColors.DEFAULT_BLUE_DARK,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(left: AppDimensions.paddingSize10),
      child: Text(
        title,
        style: AppStyle.style(
          context: context,
          fontWeight: FontWeight.bold,
          size: AppDimensions.fontSize18(context),
          color: Colors.grey[800],
        ),
      ),
    );
  }

  Widget _buildMenuSection(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSize18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildProfileTile(
    String title,
    IconData icon,
    void Function()? onTap, {
    bool? hideArrow,
    Color? textColor,
    Color? iconColor,
    Color? backgroundColor,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSize18),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingSize20,
            vertical: AppDimensions.paddingSize15,
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(AppDimensions.paddingSize10),
                decoration: BoxDecoration(
                  color: backgroundColor ?? Colors.grey[100],
                  borderRadius: BorderRadius.circular(
                    AppDimensions.radiusSize10,
                  ),
                ),
                child: Icon(
                  icon,
                  color: iconColor ?? Colors.grey[600],
                  size: 22,
                ),
              ),
              SizedBox(width: AppDimensions.paddingSize15),
              Expanded(
                child: Text(
                  title,
                  style: AppStyle.style(
                    context: context,
                    fontWeight: FontWeight.w500,
                    size: AppDimensions.fontSize16(context),
                    color: textColor ?? Colors.grey[800],
                  ),
                ),
              ),
              if (hideArrow != true)
                Icon(
                  SolarIconsBold.roundAltArrowRight,
                  color: Colors.grey[400],
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () => _showLogoutDialog(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red[50],
          foregroundColor: Colors.red[600],
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusSize18),
            side: BorderSide(color: Colors.red[200]!),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(SolarIconsBold.logout_3, size: 22),
            SizedBox(width: 12),
            Text(
              "Logout",
              style: AppStyle.style(
                context: context,
                fontWeight: FontWeight.w600,
                size: AppDimensions.fontSize16(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Dialog and Navigation Methods
  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusSize18),
            ),
            title: Text("Edit Profile"),
            content: Text(
              "Edit profile functionality will be implemented here.",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Edit"),
              ),
            ],
          ),
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusSize18),
            ),
            title: Text("Change Password"),
            content: Text(
              "Change password functionality will be implemented here.",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Change"),
              ),
            ],
          ),
    );
  }

  void _navigateToNotifications() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Navigating to Notifications..."),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusSize10),
        ),
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusSize18),
            ),
            title: Text("Help & Support"),
            content: Text("For assistance, please contact our support team."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Close"),
              ),
            ],
          ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusSize18),
            ),
            title: Text("About"),
            content: Text("Wheels Kart Evaluator App\nVersion 1.0.0"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Close"),
              ),
            ],
          ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusSize18),
            ),
            title: Text("Logout"),
            content: Text("Are you sure you want to logout?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await context.read<EvAuthBlocCubit>().clearPreferenceData(
                    context,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[600],
                  foregroundColor: Colors.white,
                ),
                child: Text("Logout"),
              ),
            ],
          ),
    );
  }
}
