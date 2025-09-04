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
    context.read<DocumentsControllerCubit>().onGetPaymentHistory(context);
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
              switch (state) {
                case DocumentsControllErrorState():
                  {
                    return AppEmptyText(text: state.errorMessage);
                  }
                case DocumentsControllerSuccessState():
                  {
                    final documents = state.documets;
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
                              leading: Container(
                                width: 48,
                                height: 48,
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
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          data.isCollected.toLowerCase() == "yes"
                                              ? VColors.SUCCESS.withOpacity(0.3)
                                              : VColors.ERROR.withOpacity(0.3),
                                      spreadRadius: 0,
                                      blurRadius: 8,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child:
                                    data.isCollected.toLowerCase() == "yes"
                                        ? Icon(
                                          SolarIconsOutline.checkCircle,
                                          color: VColors.WHITE,
                                        )
                                        : Icon(
                                          SolarIconsOutline.closeCircle,
                                          color: VColors.WHITE,
                                        ),
                              ),
          
                              title: Text(data.inspection),
                              subtitle: Text(
                                IntlHelper.formteDate(data.collectedDate),
                              ),
          
                              trailing: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: VColors.DARK_GREY.withAlpha(20),
                                ),
                                child: Text(
                                  data.documentName,
                                  style: VStyle.style(
                                    context: context,
                                    size: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
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
