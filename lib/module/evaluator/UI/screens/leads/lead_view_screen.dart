import 'package:flutter/material.dart';
import 'package:wheels_kart/core/components/app_appbar.dart';
import 'package:wheels_kart/core/constant/colors.dart';

class LeadViewScreen extends StatelessWidget {
  final bool? isHidePrintButton;
  const LeadViewScreen({super.key, this.isHidePrintButton});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppbar(title: "Inspection Details"),
      body: Center(
        child: Text(
          'This is the Lead View Screen',
          style: TextStyle(fontSize: 20),
        ),
      ),
      floatingActionButton:
          isHidePrintButton == true
              ? null
              : FloatingActionButton(
                backgroundColor: AppColors.DEFAULT_ORANGE,
                onPressed: () {},
                child: Icon(Icons.picture_as_pdf, color: AppColors.kWhite),
              ),
    );
  }
}
