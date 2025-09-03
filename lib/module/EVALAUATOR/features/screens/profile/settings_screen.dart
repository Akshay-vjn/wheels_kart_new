import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:wheels_kart/common/components/app_margin.dart';
import 'package:wheels_kart/common/controllers/auth%20cubit/auth_cubit.dart';
import 'package:wheels_kart/module/Dealer/core/components/v_loading.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_colors.dart';
import 'package:wheels_kart/module/Dealer/core/v_style.dart';
import 'package:wheels_kart/module/Dealer/features/screens/account/data/controller/profile%20controller/v_profile_controller_cubit.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_colors.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_style.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/repositories/ev_delete_account_repo.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/screens/profile/widget/delete_account_sheet.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/widgets/ev_app_custom_widgets.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/widgets/ev_app_loading_indicator.dart';

class EvSettingsScreen extends StatefulWidget {
  EvSettingsScreen({super.key});

  @override
  State<EvSettingsScreen> createState() => _EvSettingsScreenState();
}

class _EvSettingsScreenState extends State<EvSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: evCustomBackButton(context),
        centerTitle: false,
        title: Text(
          "Settings",
          style: EvAppStyle.style(
            context: context,
            color: EvAppColors.white,
            size: 20,
          ),
        ),
      ),
      body: AppMargin(
        child: Column(
          children: [
            ListTile(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  builder: (context) {
                    return EvDeleteSheet();
                  },
                );
              },
              contentPadding: EdgeInsets.all(0),
              leading: Icon(
                SolarIconsOutline.trashBin2,
                color: Colors.deepOrange,
                size: 15,
              ),
              title: Text(
                "Delete Account",
                style: EvAppStyle.style(
                  context: context,
                  color: EvAppColors.DARK_PRIMARY,
                  fontWeight: FontWeight.bold,
                  size: 15,
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: EvAppColors.grey,
                size: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
