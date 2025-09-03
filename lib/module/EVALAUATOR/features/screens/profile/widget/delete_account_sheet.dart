import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:wheels_kart/common/controllers/auth%20cubit/auth_cubit.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_colors.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/repositories/ev_delete_account_repo.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/widgets/ev_app_loading_indicator.dart';

import '../../../../../Dealer/core/v_style.dart';

class EvDeleteSheet extends StatefulWidget {
  EvDeleteSheet({super.key});

  @override
  State<EvDeleteSheet> createState() => _EvDeleteSheetState();
}

class _EvDeleteSheetState extends State<EvDeleteSheet> {
  bool isLoadingDeleting = false;

  Future<void> onDeleteAccount(BuildContext context) async {
    isLoadingDeleting = true;
    setState(() {});
    final response = await EvDeleteAccountRepo.deleteAccount(context);
    log(response.toString());
    if (response.isNotEmpty && response['error'] == false) {
      await context.read<AppAuthController>().clearPreferenceData(
        context,
        navigateToDelete: true,
      );
    } else {}
    isLoadingDeleting = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(SolarIconsOutline.trashBin2, color: VColors.ERROR, size: 40),
          const SizedBox(height: 12),
          Text(
            "Delete Account?",
            style: VStyle.style(
              context: context,
              size: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "This action is permanent and cannot be undone. "
            "Are you sure you want to delete your account?",
            textAlign: TextAlign.center,
            style: VStyle.style(
              context: context,
              size: 14,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Cancel",
                    style: VStyle.style(context: context, color: VColors.BLACK),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child:
                    isLoadingDeleting
                        ? Center(child: EVAppLoadingIndicator())
                        : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: VColors.ERROR,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () async {
                            await onDeleteAccount(context);
                          },
                          child: Text(
                            "Delete",
                            style: VStyle.style(
                              context: context,
                              color: VColors.BLACK,
                            ),
                          ),
                        ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
