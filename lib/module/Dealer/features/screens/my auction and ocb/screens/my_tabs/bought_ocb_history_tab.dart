import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wheels_kart/common/components/app_empty_text.dart';
import 'package:wheels_kart/common/components/app_spacer.dart';
import 'package:wheels_kart/module/Dealer/core/components/v_loading.dart';
import 'package:wheels_kart/module/Dealer/features/screens/my%20auction%20and%20ocb/data/controller/enhanced_ocb_controller/enhanced_ocb_controller.dart';
import 'package:wheels_kart/module/Dealer/features/screens/my%20auction%20and%20ocb/screens/widgets/enhanced_ocb_card.dart';

class BoughtOcbHistoryTab extends StatefulWidget {
  final String myId; // Pass your dealer ID

  const BoughtOcbHistoryTab({super.key, required this.myId});

  @override
  State<BoughtOcbHistoryTab> createState() => _BoughtOcbHistoryTabState();
}

class _BoughtOcbHistoryTabState extends State<BoughtOcbHistoryTab> {
  @override
  void initState() {
    super.initState();

    // Fetch OCB purchases with owned details
    context.read<EnhancedOcbController>().add(
      OnFetchOcbWithOwnedDetails(context: context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EnhancedOcbController, EnhancedOcbState>(
      builder: (context, state) {
        if (state is EnhancedOcbLoadingState) {
          return const Center(child: VLoadingIndicator());
        }
        
        if (state is EnhancedOcbErrorState) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppEmptyText(text: state.error),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<EnhancedOcbController>().add(
                      OnRefreshOcbWithOwnedDetails(context: context),
                    );
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        
        if (state is EnhancedOcbSuccessState) {
          if (state.ocbList.isEmpty) {
            return Center(
              child: AppEmptyText(text: "No purchases found!"),
            );
          }
          
          return RefreshIndicator(
            onRefresh: () async {
              context.read<EnhancedOcbController>().add(
                OnRefreshOcbWithOwnedDetails(context: context),
              );
            },
            child: ListView.separated(
              itemCount: state.ocbList.length,
              separatorBuilder: (context, index) => const AppSpacer(heightPortion: .01),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              itemBuilder: (context, index) {
                return EnhancedOcbCard(
                  ocb: state.ocbList[index],
                  ownedDetails: state.ownedDetailsList[index],
                );
              },
            ),
          );
        }
        
        return const SizedBox.shrink();
      },
    );
  }
}