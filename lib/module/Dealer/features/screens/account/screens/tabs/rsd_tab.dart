import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:wheels_kart/common/components/app_empty_text.dart';
import 'package:wheels_kart/module/Dealer/core/components/v_loading.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_colors.dart';
import 'package:wheels_kart/module/Dealer/core/v_style.dart';
import 'package:wheels_kart/module/Dealer/features/screens/account/data/controller/rsd%20controller/rsd_controller_cubit.dart';

/// Tab widget for displaying RSD (Refundable Security Deposit) history
/// Shows list of RSD transactions with expandable details
class RsdTab extends StatelessWidget {
  const RsdTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RsdControllerCubit, RsdControllerState>(
      builder: (context, state) {
        return switch (state) {
          RsdControllerSuccessState() => _buildRsdList(context, state),
          RsdControllerErrorState() => _buildErrorState(state.errorMessage),
          _ => _buildLoadingState(),
        };
      },
    );
  }

  /// Build RSD list view
  Widget _buildRsdList(BuildContext context, RsdControllerSuccessState state) {
    final rsdList = state.rsdList;

    if (rsdList.isEmpty) {
      return Center(
        child: AppEmptyText(text: "No RSD history found!"),
      );
    }

    return RefreshIndicator(
      onRefresh: () => context.read<RsdControllerCubit>().refreshRsdList(context),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: rsdList.length,
        itemBuilder: (context, index) {
          final rsd = rsdList[index];
          return _buildRsdCard(context, rsd);
        },
      ),
    );
  }

  /// Build individual RSD card
  Widget _buildRsdCard(BuildContext context, dynamic rsd) {
    // Determine color based on payment type
    final bool isOnline = rsd.isOnline;
    
    final Color statusColor = isOnline
        ? VColors.SECONDARY
        : VColors.GREENHARD;

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
          title: Row(
            children: [
              Text(
                'RSD Payment',
                style: VStyle.style(
                  context: context,
                  size: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(width: 8),
              _buildStatusBadge(context, rsd),
            ],
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
                  rsd.paymentDate,
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
                    "RSD Amount",
                    rsd.formattedAmount,
                    Icons.currency_rupee,
                    dataColor: VColors.SUCCESS,
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: _buildEnhancedItem(
                    context,
                    "Payment Type",
                    rsd.paymentType,
                    CupertinoIcons.creditcard,
                    dataColor: rsd.isOnline
                        ? VColors.SECONDARY
                        : VColors.GREENHARD,
                  ),
                ),
              ],
            ),
            if (rsd.transactionId.isNotEmpty) ...[
              const SizedBox(height: 8),
              _buildEnhancedItem(
                context,
                "Transaction ID",
                rsd.transactionId,
                CupertinoIcons.barcode,
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Build status badge for RSD payment
  Widget _buildStatusBadge(BuildContext context, dynamic rsd) {
    final status = rsd.paymentStatus;
    final isWon = status == 'won';
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isWon 
            ? VColors.GREENHARD.withOpacity(0.15)
            : Colors.orange.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isWon 
              ? VColors.GREENHARD.withOpacity(0.5)
              : Colors.orange.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Text(
        isWon ? 'Won' : 'Active',
        style: VStyle.style(
          context: context,
          size: 11,
          fontWeight: FontWeight.w600,
          color: isWon ? VColors.GREENHARD : Colors.orange,
        ),
      ),
    );
  }

  /// Build enhanced RSD detail item
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
                  overflow: TextOverflow.ellipsis,
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

