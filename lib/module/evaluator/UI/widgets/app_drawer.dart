import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wheels_kart/core/components/app_spacer.dart';
import 'package:wheels_kart/core/constant/colors.dart';
import 'package:wheels_kart/core/constant/dimensions.dart';
import 'package:wheels_kart/core/constant/style.dart';
import 'package:wheels_kart/core/utils/responsive_helper.dart';
import 'package:wheels_kart/module/evaluator/data/bloc/auth%20cubit/auth_cubit.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.white,
      width: w(context) * .65,
      shape: const BeveledRectangleBorder(),
      child: SafeArea(
        child: Column(
          children: [
            _buildListTile(
              context,
              "Privacy Policy",
              'Learn how we collect, use, and protect your personal information.',
              () {},
            ),
            _buildListTile(
              context,
              "Terms & Conditions",
              'Learn how we collect, use, and protect your personal information.',
              () {},
            ),
            _buildListTile(
              context,
              "Return & Cancellation",
              'Learn how we collect, use, and protect your personal information.',
              () {},
            ),
            _buildListTile(
              context,
              "Contact Us",
              'Learn how we collect, use, and protect your personal information.',
              () {},
            ),
            const Spacer(),
            SizedBox(
              width: w(context) * .5,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.kRed,
                ),
                onPressed: () async {
                  await context.read<EvAuthBlocCubit>().clearPreferenceData(
                    context,
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.logout, color: AppColors.white),
                    const AppSpacer(widthPortion: .02),
                    Text(
                      'Logout',
                      style: AppStyle.style(
                        context: context,
                        color: AppColors.white,
                        // fontWeight: FontWeight.w600,
                        size: AppDimensions.fontSize18(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const AppSpacer(heightPortion: .04),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context,
    String title,
    String subtitle,
    void Function()? onTap,
  ) {
    return ListTile(
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: onTap,
      title: Text(
        title,
        style: AppStyle.style(
          context: context,
          color: AppColors.black,
          fontWeight: FontWeight.w600,
          size: AppDimensions.fontSize15(context),
        ),
      ),
      // subtitle: Text(
      //   subtitle,
      //   style: AppStyle.opensansStyle(context: context),
      // )
    );
  }
}
