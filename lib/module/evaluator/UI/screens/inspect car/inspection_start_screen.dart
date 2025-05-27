import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wheels_kart/core/components/app_custom_widgets.dart';
import 'package:wheels_kart/core/components/app_margin.dart';
import 'package:wheels_kart/core/constant/colors.dart';
import 'package:wheels_kart/core/constant/dimensions.dart';
import 'package:wheels_kart/core/constant/style.dart';
import 'package:wheels_kart/core/utils/routes.dart';
import 'package:wheels_kart/module/evaluator/UI/screens/inspect%20car/answer%20questions/e_eselect_portion_screen.dart';
import 'package:wheels_kart/module/evaluator/UI/screens/inspect%20car/upload%20documentts/view_upload_documents.dart';
import 'package:wheels_kart/module/evaluator/UI/screens/inspect%20car/upload%20vehilce%20photo/upload_vehilce_photo_screen.dart';
import 'package:wheels_kart/module/evaluator/UI/screens/inspect%20car/upload%20vehilce%20photo/view_uploaded_vihilce_photos.dart';

class InspectionStartScreen extends StatefulWidget {
  final String inspectionId;
  final String? instructionData;
  const InspectionStartScreen({
    super.key,
    required this.inspectionId,
    this.instructionData,
  });

  @override
  State<InspectionStartScreen> createState() => _InspectionStartScreenState();
}

class _InspectionStartScreenState extends State<InspectionStartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: customBackButton(context),
        title: Text(
          'Inspection',
          style: AppStyle.style(
            color: AppColors.white,
            context: context,
            fontWeight: FontWeight.bold,
            size: AppDimensions.fontSize18(context),
          ),
        ),
      ),

      body: AppMargin(
        child: Column(
          children: [
            _buildButton("Car Photos", CupertinoIcons.photo, () {
              Navigator.of(context).push(
                AppRoutes.createRoute(
                  ViewUploadedVihilcePhotosScreen(
                    inspectionId: widget.inspectionId,
                  ),
                ),
              );
            }),
            _buildButton("Documents", CupertinoIcons.doc, () {
              Navigator.of(context).push(
                AppRoutes.createRoute(
                  ViewUploadDocumentsScreen(inspectionId: widget.inspectionId),
                ),
              );
            }),
            _buildButton("Inspection Report", CupertinoIcons.doc_text, () {
              Navigator.of(context).push(
                AppRoutes.createRoute(
                  EvSelectPortionScreen(
                    inspectionId: widget.inspectionId,
                    instructionData: widget.instructionData,
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String title, IconData icon, void Function()? onTap) {
    return InkWell(
      overlayColor: WidgetStatePropertyAll(Colors.transparent),
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.DEFAULT_BLUE_DARK),
        ),
        child: ListTile(
          leading: Icon(icon, color: AppColors.kAppSecondaryColor),
          title: Text(
            title,
            style: AppStyle.style(
              context: context,
              size: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          trailing: Icon(Icons.arrow_forward_ios_outlined),
        ),
      ),
    );
  }
}
