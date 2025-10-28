import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_colors.dart';
import 'package:wheels_kart/module/Dealer/core/v_style.dart';
import 'package:wheels_kart/module/Dealer/features/screens/account/data/controller/policy%20controller/v_policy_controller_cubit.dart';
import 'package:wheels_kart/module/Dealer/features/widgets/v_custom_backbutton.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_colors.dart';

class VTermsAndConditionScreen extends StatefulWidget {
  const VTermsAndConditionScreen({super.key});

  @override
  State<VTermsAndConditionScreen> createState() =>
      _VTermsAndConditionScreenState();
}

class _VTermsAndConditionScreenState extends State<VTermsAndConditionScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch policy data when the screen is initialized
    context.read<VPolicyControllerCubit>().fetchPolicy(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: VColors.WHITE,
        backgroundColor: VColors.WHITE,
        leading: VCustomBackbutton(blendColor: VColors.DARK_GREY.withAlpha(50)),
        centerTitle: false,
        title: Text(
          "Terms & Conditions",
          style: VStyle.style(
            context: context,
            color: VColors.BLACK,
            fontWeight: FontWeight.w700,
            size: 20,
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 1,
            width: double.infinity,
            child: Material(
              elevation: 1,
              shadowColor: VColors.BLACK.withAlpha(100),
            ),
          ),
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
                  // Display HTML content using flutter_html
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Html(
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
    );
  }
}
