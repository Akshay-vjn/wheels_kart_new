import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:wheels_kart/core/components/app_appbar.dart';
import 'package:wheels_kart/core/constant/colors.dart';
import 'package:wheels_kart/core/constant/dimensions.dart';
import 'package:wheels_kart/core/constant/style.dart';

class AddNewLeadScree extends StatelessWidget {
  const AddNewLeadScree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppbar(title: "Add New Lead"),
      body: Center(child: Text('This is the Add New Lead Screen')),
    );
  }
}
