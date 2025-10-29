import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:wheels_kart/common/components/app_spacer.dart';
import 'package:wheels_kart/common/config/pushnotification_controller.dart';
import 'package:wheels_kart/common/controllers/auth%20cubit/auth_cubit.dart';
import 'package:wheels_kart/common/utils/custome_show_messages.dart';
import 'package:wheels_kart/common/utils/routes.dart';
import 'package:wheels_kart/module/Dealer/core/blocs/v%20nav%20controller/v_nav_controller_cubit.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_colors.dart';
import 'package:wheels_kart/module/Dealer/core/v_style.dart';
import 'package:wheels_kart/module/Dealer/features/screens/account/data/controller/policy%20controller/v_policy_controller_cubit.dart';
import 'package:wheels_kart/module/Dealer/features/v_nav_screen.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_colors.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/model/auth_model.dart';

class VTermsAndCondionAcceptScreen extends StatefulWidget {
  const VTermsAndCondionAcceptScreen({super.key});

  @override
  State<VTermsAndCondionAcceptScreen> createState() =>
      _VTermsAndCondionAcceptScreenState();
}

class _VTermsAndCondionAcceptScreenState
    extends State<VTermsAndCondionAcceptScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch policy data when the screen is initialized
    context.read<VPolicyControllerCubit>().fetchPolicy(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: EvAppColors.DEFAULT_BLUE_DARK.withAlpha(10),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Text(
                "Terms & Conditions",
                style: VStyle.style(
                  context: context,
                  color: VColors.BLACK,
                  fontWeight: FontWeight.w800,
                  size: 20,
                ),
              ),
              AppSpacer(heightPortion: .01),
              Expanded(
                child: BlocBuilder<VPolicyControllerCubit, VPolicyControllerState>(
                  builder: (context, state) {
                    if (state is VPolicyControllerLoadingState) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (state is VPolicyControllerErrorState) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 64,
                              color: VColors.DARK_GREY,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              state.error,
                              style: VStyle.style(
                                context: context,
                                size: 16,
                                color: VColors.DARK_GREY,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                context.read<VPolicyControllerCubit>().fetchPolicy(context);
                              },
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }

                    if (state is VPolicyControllerSuccessState) {
                      return SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 10,
                        ),
                        child: Column(
                          children: [
                            // Display HTML content using flutter_html
                            Html(
                              data: state.htmlContent,
                              style: {
                                "body": Style(
                                  fontSize: FontSize(14.0),
                                  color: VColors.BLACK,
                                  lineHeight: const LineHeight(1.6),
                                ),
                                "h1": Style(
                                  fontSize: FontSize(22.0),
                                  fontWeight: FontWeight.bold,
                                  margin: Margins.only(bottom: 12),
                                  color: VColors.BLACK,
                                ),
                                "h2": Style(
                                  fontSize: FontSize(20.0),
                                  fontWeight: FontWeight.bold,
                                  margin: Margins.only(top: 20, bottom: 12),
                                  color: VColors.BLACK,
                                ),
                                "h3": Style(
                                  fontSize: FontSize(18.0),
                                  fontWeight: FontWeight.bold,
                                  margin: Margins.only(top: 16, bottom: 8),
                                  color: VColors.BLACK,
                                ),
                                "p": Style(
                                  margin: Margins.only(bottom: 12),
                                ),
                                "ul": Style(
                                  margin: Margins.only(bottom: 12),
                                ),
                                "li": Style(
                                  margin: Margins.only(bottom: 8),
                                ),
                                "strong": Style(
                                  fontWeight: FontWeight.bold,
                                ),
                                "hr": Style(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: VColors.DARK_GREY.withOpacity(0.2),
                                      width: 1,
                                    ),
                                  ),
                                  margin: Margins.symmetric(vertical: 16),
                                ),
                              },
                            ),
                            const SizedBox(height: 24),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: ElevatedButton.icon(
                                icon: const Icon(
                                  Icons.check_circle_outline,
                                  color: VColors.WHITE,
                                ),
                                label: Text(
                                  "Accept & Continue",
                                  style: VStyle.style(
                                    context: context,
                                    color: VColors.WHITE,
                                    fontWeight: FontWeight.w600,
                                    size: 16,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: VColors.SECONDARY,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 12,
                                  ),
                                ),
                                onPressed: () async {
                                  context.read<VNavControllerCubit>().onChangeNav(0);
                                  HapticFeedback.heavyImpact();
                                  await PushNotificationConfig().initNotification(
                                    context,
                                  );
                                  await context
                                      .read<AppAuthController>()
                                      .updateLoginPreference(
                                        AuthUserModel(
                                          isDealerAcceptedTermsAndCondition: true,
                                        ),
                                      );
                                  showToastMessage(
                                    context,
                                    "Login Successful, Welcome to Wheels Kart",
                                  );

                                  Navigator.of(context).pushAndRemoveUntil(
                                    AppRoutes.createRoute(VNavScreen()),
                                    (context) => false,
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      );
                    }

                    // Initial state - show loading
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
