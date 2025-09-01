import 'package:flutter/material.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_colors.dart';
import 'package:wheels_kart/module/Dealer/core/v_style.dart';
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                ],
              ),
            ),
          ),
        ],
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
