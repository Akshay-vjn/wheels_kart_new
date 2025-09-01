import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:wheels_kart/common/components/app_margin.dart';
import 'package:wheels_kart/common/utils/routes.dart';
import 'package:wheels_kart/module/Dealer/core/components/v_loading.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_colors.dart';
import 'package:wheels_kart/module/Dealer/core/v_style.dart';
import 'package:wheels_kart/module/Dealer/features/screens/account/data/controller/profile%20controller/v_profile_controller_cubit.dart';
import 'package:wheels_kart/module/Dealer/features/widgets/v_custom_backbutton.dart';
import 'package:wheels_kart/module/spash_screen.dart';

class VSettngsScreen extends StatelessWidget {
  const VSettngsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: VColors.WHITE,
        leading: VCustomBackbutton(blendColor: VColors.DARK_GREY.withAlpha(50)),
        centerTitle: false,
        title: Text(
          "Settings",
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
          ListTile(
            onTap: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          SolarIconsOutline.trashBin2,
                          color: VColors.ERROR,
                          size: 40,
                        ),
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
                                  style: VStyle.style(
                                    context: context,
                                    color: VColors.BLACK,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: BlocBuilder<
                                VProfileControllerCubit,
                                VProfileControllerState
                              >(
                                builder: (context, state) {
                                  if (state is VProfileControllerLoadingState) {
                                    return Center(child: VLoadingIndicator());
                                  }
                                  return ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: VColors.ERROR,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: () async {
                                      await context
                                          .read<VProfileControllerCubit>()
                                          .onDeleteAccount(context);
                                    },
                                    child: Text(
                                      "Delete",
                                      style: VStyle.style(
                                        context: context,
                                        color: VColors.BLACK,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            trailing: CircleAvatar(
              backgroundColor: VColors.ERROR.withAlpha(10),
              child: Icon(
                SolarIconsOutline.trashBin2,
                size: 15,
                color: VColors.ERROR,
              ),
            ),
            title: Text(
              "Delete account",
              style: VStyle.style(
                context: context,
                size: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
