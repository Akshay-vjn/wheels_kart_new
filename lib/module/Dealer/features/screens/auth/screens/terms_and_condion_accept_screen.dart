import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wheels_kart/common/controllers/auth%20cubit/auth_cubit.dart';
import 'package:wheels_kart/common/utils/custome_show_messages.dart';
import 'package:wheels_kart/common/utils/routes.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_colors.dart';
import 'package:wheels_kart/module/Dealer/core/v_style.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: EvAppColors.DEFAULT_BLUE_DARK.withAlpha(10),
        child: SafeArea(
          bottom: false,
          child: Container(
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: VColors.WHITE,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: VColors.DARK_GREY.withOpacity(0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  _sectionTitle("Bidding & Proof"),
                  _sectionText(
                    "• Auctions are conducted via WhatsApp; chat is treated as legal proof.\n"
                    "• Highest bidder will be updated in app backend + WhatsApp confirmation message.\n"
                    "• Deleted messages are invalid; latest visible record is final.\n"
                    "• Any discrepancy must be reported immediately.",
                  ),

                  _sectionTitle("Payments"),
                  _sectionText(
                    "• 10% of bid to be paid immediately.\n"
                    "• Balance 90% within 2 working days.\n"
                    "• Delay > 2 days → ₹1,000/day parking charges.\n"
                    "• No payment within 5 days → deal cancelled & 10% forfeited.",
                  ),

                  _sectionTitle("RC Transfer"),
                  _sectionText(
                    "• RC transfer is mandatory within 180 days.\n"
                    "• If not completed, vehicle will be transferred to dealer’s name and dealer bears all liabilities.",
                  ),

                  _sectionTitle("Refreshment Cost (RF Cost)"),
                  _sectionText(
                    "• RF costs below ₹15,000 will not be entertained; dealer must bear these expenses.",
                  ),

                  _sectionTitle("Post-Delivery Responsibility"),
                  _sectionText(
                    "• Dealer is responsible for maintenance, traffic violations, challans, liabilities.\n"
                    "• Any mismatch must be reported within 3 hours of delivery; later claims not accepted.",
                  ),

                  _sectionTitle("Vehicle Report & Features"),
                  _sectionText(
                    "• Any standard features missing but not mentioned in the app will not be treated as mismatch/claim.",
                  ),

                  _sectionTitle("Security Deposit"),
                  _sectionText(
                    "• Dealer must maintain ₹6,500 app deposit.\n"
                    "• For every purchase, an additional ₹6,500 security deposit is required.\n"
                    "• Bid backout → ₹6,500 deducted from deposit.",
                  ),

                  _sectionTitle("Compliance"),
                  _sectionText(
                    "• Defaults or non-compliance may result in deduction, suspension, or removal from the platform.",
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
                        "Accept",
                        style: VStyle.style(
                          context: context,
                          color: VColors.WHITE,
                          fontWeight: FontWeight.w600,
                          size: 16,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: EvAppColors.kAppSecondaryColor,

                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      onPressed: () async {
                        // AppAuthController().updateLoginPreference(
                        //   AuthUserModel(
                        //     isDealerAcceptedTermsAndCondition: true,
                        //   ),
                        // );
                        HapticFeedback.heavyImpact();
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 6),
      child: Text(
        title,
        style: VStyle.style(
          context: context,
          size: 18,
          fontWeight: FontWeight.bold,
          color: VColors.BLACK,
        ),
      ),
    );
  }

  Widget _sectionText(String text) {
    return Text(text, style: VStyle.style(context: context, size: 14));
  }
}
