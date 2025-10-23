// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:pdf/pdf.dart';
// import 'package:transformable_list_view/transformable_list_view.dart';
// import 'package:wheels_kart/core/components/app_empty_text.dart';
// import 'package:wheels_kart/core/components/app_loading_indicator.dart';
// import 'package:wheels_kart/core/components/app_margin.dart';
// import 'package:wheels_kart/core/components/app_spacer.dart';
// import 'package:wheels_kart/core/constant/colors.dart';
// import 'package:wheels_kart/core/constant/dimensions.dart';
// import 'package:wheels_kart/core/constant/style.dart';
// import 'package:wheels_kart/core/utils/routes.dart';
// import 'package:wheels_kart/module/evaluator/UI/screens/pdf/pdf_preview.dart';
// import 'package:wheels_kart/module/evaluator/data/bloc/download%20pdf/download_pdf_cubit.dart';
// import 'package:wheels_kart/module/evaluator/data/bloc/get%20data/fetch%20inspections/fetch_inspections_bloc.dart';
// import 'package:wheels_kart/module/evaluator/UI/screens/inspect%20car/fill%20basic%20details/2_select_and_search_manufacturing_year_selection.dart';
// import 'package:wheels_kart/module/evaluator/data/model/inspection_data_model.dart';

// class EvCompletedLeadTab extends StatefulWidget {
//   const EvCompletedLeadTab({super.key});

//   @override
//   State<EvCompletedLeadTab> createState() => _EvCompletedLeadTabState();
// }

// class _EvCompletedLeadTabState extends State<EvCompletedLeadTab> {
//   @override
//   void initState() {
//     super.initState();
//     context.read<FetchInspectionsBloc>().add(
//       OnGetInspectionList(context: context, inspetionListType: 'COMPLETED'),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 10),
//       child: BlocBuilder<FetchInspectionsBloc, FetchInspectionsState>(
//         builder: (context, state) {
//           switch (state) {
//             case LoadingFetchInspectionsState():
//               {
//                 return AppLoadingIndicator();
//               }
//             case SuccessFetchInspectionsState():
//               {
//                 return state.listOfInspection.isEmpty
//                     ? AppEmptyText(text: state.message)
//                     : ListView.separated(
//                       padding: EdgeInsets.all(0),
//                       itemBuilder: (context, index) {
//                         InspectionModel data = state.listOfInspection[index];

//                         return AppMargin(child: _buildItems(context, data));
//                       },
//                       // getTransformMatrix: (item) {
//                       //   return getTransformMatrix(item);
//                       // },
//                       separatorBuilder:
//                           (context, index) => AppSpacer(heightPortion: .02),
//                       itemCount: state.listOfInspection.length,
//                     );
//               }
//             case ErrorFetchInspectionsState():
//               {
//                 return AppEmptyText(text: state.errormessage);
//               }
//             default:
//               {
//                 return SizedBox();
//               }
//           }
//         },
//       ),
//     );
//   }

//   Widget _buildItems(BuildContext context, InspectionModel model) {
//     return InkWell(
//       onTap: () {
//         // Navigator.of(context).push(
//         //   MaterialPageRoute(builder: (_) => PdfPreviewScreen(model: model)),
//         // );

//         Navigator.of(
//           context,
//         ).push(AppRoutes.createRoute(PdfPreviewScreen(model: model)));
//       },
//       child: Column(
//         children: [
//           Container(
//             padding: EdgeInsets.all(10),
//             decoration: BoxDecoration(color: AppColors.white),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.center,

//               children: [
//                 InkWell(
//                   onTap: () async {
//                     await context.read<DownloadPdfCubit>().onDownloadPDF(
//                       context,
//                       model.inspectionId,
//                     );
//                   },
//                   child: Container(
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: AppColors.DARK_SECONDARY,
//                     ),
//                     height: 100,
//                     width: 100,
//                     child: Icon(Icons.download),
//                   ),
//                 ),
//                 AppSpacer(widthPortion: .02),
//                 Expanded(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.start,

//                     children: [
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,

//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,

//                             children: [
//                               Flexible(
//                                 child: Text(
//                                   "",
//                                   style: AppStyle.style(
//                                     context: context,
//                                     fontWeight: FontWeight.bold,
//                                     size: AppDimensions.fontSize18(context),
//                                   ),
//                                 ),
//                               ),
//                               Container(
//                                 padding: EdgeInsets.symmetric(
//                                   horizontal: 10,
//                                   vertical: 2,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: AppColors.kGreen,
//                                   borderRadius: BorderRadius.circular(50),
//                                 ),
//                                 child: Text(
//                                   model.status,
//                                   style: AppStyle.style(
//                                     context: context,
//                                     fontWeight: FontWeight.bold,
//                                     color: AppColors.white,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           Text(
//                             model.regNo,
//                             style: AppStyle.style(
//                               context: context,
//                               fontWeight: FontWeight.bold,
//                               size: AppDimensions.fontSize13(context),
//                             ),
//                           ),
//                         ],
//                       ),
//                       AppSpacer(heightPortion: .01),
//                       Column(
//                         // mainAxisSize: MainAxisSize.min,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               Text(
//                                 "Contact Info",
//                                 style: AppStyle.style(
//                                   context: context,
//                                   color: AppColors.black2,
//                                   fontWeight: FontWeight.w300,
//                                   size: AppDimensions.fontSize18(context),
//                                 ),
//                               ),
//                               Flexible(child: Divider(indent: 10)),
//                             ],
//                           ),
//                           AppSpacer(heightPortion: .001),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,

//                             children: [
//                               Text(
//                                 model.customer.customerName,
//                                 style: AppStyle.style(
//                                   context: context,
//                                   fontWeight: FontWeight.bold,
//                                   size: AppDimensions.fontSize18(context),
//                                 ),
//                               ),
//                               Text(
//                                 model.customer.customerMobileNumber,
//                                 style: AppStyle.style(
//                                   context: context,
//                                   fontWeight: FontWeight.bold,
//                                   size: AppDimensions.fontSize18(context),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wheels_kart/common/utils/custome_show_messages.dart';
import 'package:wheels_kart/common/utils/routes.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/bloc/update%20remarks/update_remarks_cubit.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/repositories/master/fetch_the_instruction_repo.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/screens/inspect%20car/inspection_start_screen.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/widgets/ev_app_custom_button.dart';

import 'package:wheels_kart/module/EVALAUATOR/features/widgets/ev_app_loading_indicator.dart';

import 'package:wheels_kart/module/EVALAUATOR/core/ev_colors.dart';

import 'package:wheels_kart/module/EVALAUATOR/data/bloc/download%20pdf/download_pdf_cubit.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/bloc/get%20data/fetch%20inspections/fetch_inspections_bloc.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/model/inspection_data_model.dart';

class EvCompletedLeadTab extends StatefulWidget {
  const EvCompletedLeadTab({super.key});

  @override
  State<EvCompletedLeadTab> createState() => _EvCompletedLeadTabState();
}

class _EvCompletedLeadTabState extends State<EvCompletedLeadTab>
    with TickerProviderStateMixin {
  late AnimationController _refreshController;
  late Animation<double> _refreshAnimation;
  String? _downloadingId;

  @override
  void initState() {
    super.initState();
    _refreshController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _refreshAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _refreshController, curve: Curves.easeInOut),
    );

    _fetchInspections();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  void _fetchInspections() {
    context.read<FetchInspectionsBloc>().add(
      OnGetInspectionList(context: context, inspetionListType: 'COMPLETED'),
    );
  }

  Future<void> _onRefresh() async {
    _refreshController.forward();
    _fetchInspections();
    await Future.delayed(const Duration(milliseconds: 1000));
    _refreshController.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.grey[50]!, Colors.white],
        ),
      ),
      child: RefreshIndicator.adaptive(
        onRefresh: () async {
          _onRefresh();
        },
        color: EvAppColors.DEFAULT_BLUE_DARK,
        backgroundColor: Colors.white,
        child: MultiBlocListener(
          listeners: [
            BlocListener<DownloadPdfCubit, DownloadPdfState>(
              listener: (context, state) {
                if (state is DownloadPdfLoadingState) {
                  // Loading handled by UI state
                } else if (state is DowloadPdfSuccessState) {
                  setState(() {
                    _downloadingId = null;
                  });
                  showSnakBar(
                    context,
                    'PDF downloaded successfully!',
                    isError: false,
                  );
                } else if (state is DowloadPdfErrorState) {
                  setState(() {
                    _downloadingId = null;
                  });
                  showSnakBar(
                    context,
                    // state.message,
                    'Failed to download PDF. Please try again.',
                    isError: true,
                  );
                }
              },
            ),
          ],
          child: BlocBuilder<FetchInspectionsBloc, FetchInspectionsState>(
            builder: (context, state) {
              switch (state) {
                case LoadingFetchInspectionsState():
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        EVAppLoadingIndicator(),
                        SizedBox(height: 16),
                        Text(
                          'Loading completed inspections...',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  );

                case SuccessFetchInspectionsState():
                  if (state.listOfInspection.isEmpty) {
                    return _buildEmptyState(state.message);
                  }
                  return _buildInspectionsList(state.listOfInspection);

                case ErrorFetchInspectionsState():
                  return _buildErrorState(state.errormessage);

                default:
                  return const SizedBox();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.assignment_turned_in_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Completed Inspections',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message.isNotEmpty
                ? message
                : 'All completed inspections will appear here',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
          ),
          // const SizedBox(height: 24),
          // ElevatedButton.icon(
          //   onPressed: _onRefresh,
          //   icon: const Icon(Icons.refresh),
          //   label: const Text('Refresh'),
          //   style: ElevatedButton.styleFrom(
          //     backgroundColor: EvAppColors.DARK_SECONDARY,
          //     foregroundColor: Colors.white,
          //     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String errorMessage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red.shade400,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Something went wrong',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.red.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.red.shade500),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _onRefresh,
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInspectionsList(List<InspectionModel> inspections) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final inspection = inspections[index];
        return AnimatedContainer(
          duration: Duration(milliseconds: 300 + (index * 50)),
          curve: Curves.easeOutBack,
          child: _buildInspectionCard(context, inspection, index),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemCount: inspections.length,
    );
  }

  Widget _buildInspectionCard(
    BuildContext context,
    InspectionModel model,
    int index,
  ) {
    final isDownloading = _downloadingId == model.inspectionId;

    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Colors.grey.shade50],
          ),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDownloadButton(context, model, isDownloading),
                const SizedBox(width: 16),
                Expanded(child: _buildInspectionDetails(context, model)),
              ],
            ),
            const SizedBox(height: 12),

            _buildContactInfo(context, model),

            const SizedBox(height: 10),

            _buildActionButton(
              label: "Edit Inspection",
              icon: Icons.edit,
              isEnabled: model.status.toLowerCase() != "approved",
              // isEnabled:
              //     model.status.toLowerCase() == 'new' ||
              //     model.status.toLowerCase() == 'assigned',
              isCompleted: false,
              onTap: () => _onClicEditInspection(model),
              backgroundColor: EvAppColors.DEFAULT_BLUE_GREY,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDownloadButton(
    BuildContext context,
    InspectionModel model,
    bool isDownloading,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 80,
      width: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors:
              isDownloading
                  ? [Colors.grey.shade400, Colors.grey.shade500]
                  : [
                    EvAppColors.DEFAULT_ORANGE,
                    EvAppColors.DEFAULT_ORANGE.withOpacity(0.8),
                  ],
        ),
        boxShadow: [
          BoxShadow(
            color: (isDownloading ? Colors.grey : EvAppColors.DEFAULT_ORANGE)
                .withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap:
              isDownloading
                  ? null
                  : () async {
                    HapticFeedback.mediumImpact();
                    setState(() {
                      _downloadingId = model.inspectionId;
                    });
                    await context.read<DownloadPdfCubit>().onDownloadPDF(
                      context,
                      model.inspectionId,
                    );
                  },
          borderRadius: BorderRadius.circular(40),
          child: Center(
            child:
                isDownloading
                    ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.white,
                        ),
                        strokeWidth: 2.5,
                      ),
                    )
                    : const Icon(
                      Icons.file_download_outlined,
                      color: Colors.white,
                      size: 28,
                    ),
          ),
        ),
      ),
    );
  }

  Widget _buildInspectionDetails(BuildContext context, InspectionModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.regNo.isNotEmpty
                        ? model.regNo
                        : 'Vehicle Registration',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    model.modelName,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  Text(
                    'Inspection ID: ${model.evaluationId}',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            _buildStatusChip(model.status),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'assigned':
      case "completed":
        color = Colors.orange;
        break;

      case 'sold':
        color = Colors.red;
        break;
      case 'cancelled':
        color = Colors.grey;
        break;
      default:
        color = Colors.grey;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [color, color.withOpacity(0.8)]),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        status,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 8,
        ),
      ),
    );
  }

  Widget _buildContactInfo(BuildContext context, InspectionModel model) {
    return ExpansionTile(
      collapsedBackgroundColor: EvAppColors.grey.withAlpha(30),
      backgroundColor: EvAppColors.grey.withAlpha(40),
      collapsedShape: ContinuousRectangleBorder(
        side: BorderSide(color: Colors.grey.shade200),
        borderRadius: BorderRadiusGeometry.circular(20),
      ),

      shape: ContinuousRectangleBorder(
        side: BorderSide(color: Colors.grey.shade200),
        borderRadius: BorderRadiusGeometry.circular(20),
      ),
      tilePadding: EdgeInsets.symmetric(horizontal: 16),
      childrenPadding: EdgeInsets.symmetric(horizontal: 16),

      title: Row(
        children: [
          Icon(Icons.person_outline, size: 16, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Text(
            'Customer Information',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 12),
              height: 1,
              color: Colors.grey.shade300,
            ),
          ),
        ],
      ),
      children: [
        const SizedBox(height: 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Name',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    model.customer.customerName.isNotEmpty
                        ? model.customer.customerName
                        : 'Not available',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Phone',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 2),
                InkWell(
                  onTap: () {
                    // Add phone call functionality here
                    HapticFeedback.lightImpact();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: EvAppColors.DARK_SECONDARY.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.phone_outlined,
                          size: 14,
                          color: EvAppColors.DARK_SECONDARY,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          model.customer.customerMobileNumber.isNotEmpty
                              ? model.customer.customerMobileNumber
                              : 'Not available',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: EvAppColors.DARK_SECONDARY,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required bool isCompleted,
    bool isEnabled = true,
    required VoidCallback? onTap,
    required Color backgroundColor,
  }) {
    return InkWell(
      onTap: isEnabled ? onTap : null,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
        decoration: BoxDecoration(
          color:
              isEnabled ? backgroundColor.withOpacity(0.1) : Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isEnabled ? backgroundColor : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isCompleted ? Icons.check_circle : icon,
              color: isEnabled ? backgroundColor : Colors.grey[400],
              size: 20,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  color: isEnabled ? backgroundColor : Colors.grey[400],
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => const Center(
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Loading instructions...'),
                  ],
                ),
              ),
            ),
          ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        action: SnackBarAction(
          label: 'DISMISS',
          textColor: Colors.white,
          onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
        ),
      ),
    );
  }

  void _onClicEditInspection(InspectionModel model) async {
    try {
      _showLoadingDialog(context);

      if (model.engineTypeId == '1') {
        final snapshot =
            await FetchTheInstructionRepo.getTheInstructionForStartEngine(
              context,
              model.engineTypeId,
            );

        Navigator.of(context).pop(); // Close loading dialog

        if (snapshot['error'] == true) {
          _showErrorSnackBar(context, snapshot['message']);
        } else if (snapshot.isEmpty) {
          _showErrorSnackBar(context, 'Instruction page not found!');
        } else if (snapshot['error'] == false) {
          Navigator.of(context).push(
            AppRoutes.createRoute(
              BlocProvider(
                create: (context) => UpdateRemarksCubit(),
                child: InspectionStartScreen(
                  hideCompleteButon: true,
                  inspectionId: model.inspectionId,
                  instructionData: snapshot['data'][0]['instructions'],
                ),
              ),
            ),
          );
        }
      } else {
        Navigator.of(context).pop(); // Close loading dialog
        Navigator.of(context).push(
          AppRoutes.createRoute(
            BlocProvider(
              create: (context) => UpdateRemarksCubit(),
              child: InspectionStartScreen(
                hideCompleteButon: true,
                instructionData: null,
                inspectionId: model.inspectionId,
              ),
            ),
          ),
        );
      }
    } catch (e) {
      Navigator.of(context).pop(); // Close loading dialog
      _showErrorSnackBar(context, 'An error occurred. Please try again.');
    }
  }
}
