import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:wheels_kart/common/components/app_empty_text.dart';
import 'package:wheels_kart/common/components/app_margin.dart';
import 'package:wheels_kart/common/components/app_spacer.dart';
import 'package:wheels_kart/common/utils/intl_helper.dart';
import 'package:wheels_kart/module/Dealer/core/components/v_loading.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_colors.dart';
import 'package:wheels_kart/module/Dealer/core/v_style.dart';
import 'package:wheels_kart/module/Dealer/features/screens/account/data/controller/documents_controller/documents_controller_cubit.dart';
import 'package:wheels_kart/module/Dealer/features/widgets/v_custom_backbutton.dart';

class VCollectedDocumentsScreen extends StatefulWidget {
  const VCollectedDocumentsScreen({super.key});

  @override
  State<VCollectedDocumentsScreen> createState() =>
      _VCollectedDocumentsScreenState();
}

class _VCollectedDocumentsScreenState extends State<VCollectedDocumentsScreen> {
  @override
  void initState() {
    context.read<DocumentsControllerCubit>().onGetCollectedDocuments(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: VColors.WHITE,
        leading: VCustomBackbutton(blendColor: VColors.DARK_GREY.withAlpha(50)),
        centerTitle: false,
        title: Text(
          "Documents",
          style: VStyle.style(
            context: context,
            color: VColors.BLACK,
            fontWeight: FontWeight.w700,
            size: 20,
          ),
        ),
      ),
      body: Center(
        child: AppMargin(
          child: BlocBuilder<DocumentsControllerCubit, DocumentsControllerState>(
            builder: (context, state) {
              log('VCollectedDocumentsScreen: Current state: ${state.runtimeType}');
              switch (state) {
                case DocumentsControllErrorState():
                  {
                    return AppEmptyText(text: state.errorMessage);
                  }
                case DocumentsControllerSuccessState():
                  {
                    final documents = state.documets;
                    log('VCollectedDocumentsScreen: Success state - Documents count: ${documents.length}');
                    if (documents.isEmpty) {
                      return AppEmptyText(text: 'No documents found');
                    }
                    return ListView.separated(
                      separatorBuilder: (context, index) => AppSpacer(heightPortion: .005,),
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        final data = documents[index];
                        return Container(
                          
                          margin: EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: VColors.DARK_GREY.withAlpha(120),
                              width: .5,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 6,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: ListTile(
                              leading: Stack(
                                children: [
                                  // Document image
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: VColors.DARK_GREY.withAlpha(120),
                                        width: 1,
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: data.image.isNotEmpty
                                          ? Image.network(
                                              data.image,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) {
                                                return Container(
                                                  color: VColors.DARK_GREY.withAlpha(20),
                                                  child: Icon(
                                                    SolarIconsOutline.document,
                                                    color: VColors.DARK_GREY,
                                                    size: 24,
                                                  ),
                                                );
                                              },
                                              loadingBuilder: (context, child, loadingProgress) {
                                                if (loadingProgress == null) return child;
                                                return Container(
                                                  color: VColors.DARK_GREY.withAlpha(20),
                                                  child: Center(
                                                    child: SizedBox(
                                                      width: 20,
                                                      height: 20,
                                                      child: CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                        valueColor: AlwaysStoppedAnimation<Color>(VColors.PRIMARY),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            )
                                          : Container(
                                              color: VColors.DARK_GREY.withAlpha(20),
                                              child: Icon(
                                                SolarIconsOutline.document,
                                                color: VColors.DARK_GREY,
                                                size: 24,
                                              ),
                                            ),
                                    ),
                                  ),
                                  // Status indicator
                                  Positioned(
                                    bottom: -2,
                                    right: -2,
                                    child: Container(
                                      width: 16,
                                      height: 16,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors:
                                              data.isCollected.toLowerCase() == "yes"
                                                  ? [
                                                    VColors.SUCCESS,
                                                    VColors.SUCCESS.withOpacity(0.7),
                                                  ]
                                                  : [
                                                    VColors.ERROR,
                                                    VColors.ERROR.withOpacity(0.7),
                                                  ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: VColors.WHITE,
                                          width: 1,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                data.isCollected.toLowerCase() == "yes"
                                                    ? VColors.SUCCESS.withOpacity(0.3)
                                                    : VColors.ERROR.withOpacity(0.3),
                                            spreadRadius: 0,
                                            blurRadius: 4,
                                            offset: Offset(0, 1),
                                          ),
                                        ],
                                      ),
                                      child: data.isCollected.toLowerCase() == "yes"
                                          ? Icon(
                                            SolarIconsOutline.checkCircle,
                                            color: VColors.WHITE,
                                            size: 10,
                                          )
                                          : Icon(
                                            SolarIconsOutline.closeCircle,
                                            color: VColors.WHITE,
                                            size: 10,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
          
                              title: Text(
                                data.inspection,
                                style: VStyle.style(
                                  context: context,
                                  fontWeight: FontWeight.w600,
                                  size: 16,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    IntlHelper.formteDate(data.collectedDate),
                                    style: VStyle.style(
                                      context: context,
                                      color: VColors.DARK_GREY,
                                      size: 14,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: data.isCollected.toLowerCase() == "yes"
                                          ? VColors.SUCCESS.withAlpha(20)
                                          : VColors.ERROR.withAlpha(20),
                                    ),
                                    child: Text(
                                      data.documentName,
                                      style: VStyle.style(
                                        context: context,
                                        size: 12,
                                        fontWeight: FontWeight.w500,
                                        color: data.isCollected.toLowerCase() == "yes"
                                            ? VColors.SUCCESS
                                            : VColors.ERROR,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
          
                              trailing: data.image.isNotEmpty
                                  ? IconButton(
                                      onPressed: () {
                                        // TODO: Implement image preview functionality
                                        showDialog(
                                          context: context,
                                          builder: (context) => Dialog(
                                            child: Container(
                                              padding: EdgeInsets.all(16),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    'Document Preview',
                                                    style: VStyle.style(
                                                      context: context,
                                                      fontWeight: FontWeight.bold,
                                                      size: 18,
                                                    ),
                                                  ),
                                                  SizedBox(height: 16),
                                                  ClipRRect(
                                                    borderRadius: BorderRadius.circular(8),
                                                    child: Image.network(
                                                      data.image,
                                                      fit: BoxFit.contain,
                                                      errorBuilder: (context, error, stackTrace) {
                                                        return Container(
                                                          height: 200,
                                                          color: VColors.DARK_GREY.withAlpha(20),
                                                          child: Center(
                                                            child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                Icon(
                                                                  SolarIconsOutline.document,
                                                                  color: VColors.DARK_GREY,
                                                                  size: 48,
                                                                ),
                                                                SizedBox(height: 8),
                                                                Text('Failed to load image'),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(height: 16),
                                                  ElevatedButton(
                                                    onPressed: () => Navigator.pop(context),
                                                    child: Text('Close'),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      icon: Icon(
                                        SolarIconsOutline.eye,
                                        color: VColors.PRIMARY,
                                      ),
                                    )
                                  : null,
                            ),
                          ),
                        );
                      },
                    );
                  }
                default:
                  {
                    return VLoadingIndicator();
                  }
              }
            },
          ),
        ),
      ),
    );
  }
}
