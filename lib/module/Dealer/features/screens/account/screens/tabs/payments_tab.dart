import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:wheels_kart/common/components/app_empty_text.dart';
import 'package:wheels_kart/common/utils/intl_helper.dart';
import 'package:wheels_kart/module/Dealer/core/components/v_loading.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_colors.dart';
import 'package:wheels_kart/module/Dealer/core/v_style.dart';
import 'package:wheels_kart/module/Dealer/features/screens/account/data/controller/payment%20history%20controller/payment_history_controller_cubit.dart';

/// Tab widget for displaying payment history
/// Shows list of payment transactions with expandable details
class PaymentsTab extends StatelessWidget {
  const PaymentsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentHistoryControllerCubit, PaymentHistoryControllerState>(
      builder: (context, state) {
        return switch (state) {
          PaymentHistoryControllerSuccessState() => _buildPaymentList(context, state),
          PaymentHistoryControllerErrorState() => _buildErrorState(state.errorMesage),
          _ => _buildLoadingState(),
        };
      },
    );
  }

  /// Build payment list view
  Widget _buildPaymentList(BuildContext context, PaymentHistoryControllerSuccessState state) {
    final payments = state.payments;

    if (payments.isEmpty) {
      return Center(
        child: AppEmptyText(text: "No payment history found!"),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: payments.length,
      itemBuilder: (context, index) {
        final payment = payments[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            border: Border.all(
              color: VColors.DARK_GREY.withAlpha(120),
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: ExpansionTile(
              initiallyExpanded: true,
              backgroundColor: Colors.white,
              collapsedBackgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              collapsedShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              leading: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      VColors.SUCCESS,
                      VColors.SUCCESS.withOpacity(0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: VColors.SUCCESS.withOpacity(0.3),
                      spreadRadius: 0,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  CupertinoIcons.money_dollar_circle,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              title: Text(
                payment.inspection,
                style: VStyle.style(
                  context: context,
                  size: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              subtitle: Container(
                margin: const EdgeInsets.only(top: 4),
                child: Row(
                  children: [
                    const Icon(
                      CupertinoIcons.calendar,
                      size: 14,
                      color: VColors.DARK_GREY,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      IntlHelper.formteDate(payment.createdAt.date),
                      style: VStyle.style(
                        color: VColors.DARK_GREY,
                        context: context,
                        size: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              expandedAlignment: Alignment.centerLeft,
              children: [
                Container(
                  width: double.infinity,
                  height: 1,
                  color: Colors.grey.withOpacity(0.2),
                  margin: const EdgeInsets.only(bottom: 12),
                ),
                Row(
                  children: [
                    Flexible(
                      child: _buildEnhancedItem(
                        context,
                        "Payment Mode",
                        payment.paymentMode,
                        SolarIconsOutline.banknote,
                        dataColor: payment.paymentMode == "Online"
                            ? VColors.ACCENT
                            : VColors.GREENHARD,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: _buildEnhancedItem(
                        context,
                        "Payment Type",
                        payment.paymentType,
                        CupertinoIcons.creditcard,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _buildEnhancedItem(
                  context,
                  "Paid Amount",
                  "₹${payment.paidAmount}",
                  CupertinoIcons.money_dollar,
                  dataColor: VColors.SUCCESS,
                ),
                if (payment.balanceAmount.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  _buildEnhancedItem(
                    context,
                    "Balance Amount",
                    "₹${payment.balanceAmount}",
                    CupertinoIcons.clock,
                    dataColor: Colors.orange[600],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  /// Build enhanced payment detail item
  Widget _buildEnhancedItem(
    BuildContext context,
    String title,
    String data,
    IconData icon, {
    Color? dataColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: (dataColor ?? VColors.DARK_GREY).withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              size: 16,
              color: dataColor ?? VColors.DARK_GREY,
            ),
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
                    fontWeight: FontWeight.w500,
                    size: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  data,
                  style: VStyle.style(
                    context: context,
                    color: dataColor ?? Colors.grey[800],
                    fontWeight: FontWeight.w600,
                    size: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build loading state
  Widget _buildLoadingState() {
    return const Center(child: VLoadingIndicator());
  }

  /// Build error state
  Widget _buildErrorState(String message) {
    return Center(child: AppEmptyText(text: message));
  }
}



