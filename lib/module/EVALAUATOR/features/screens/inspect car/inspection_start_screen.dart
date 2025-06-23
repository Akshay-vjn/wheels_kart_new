import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/model/document_data_model.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/screens/inspect%20car/upload%20car%20leags/upload_car_legals.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/screens/inspect%20car/upload%20car%20leags/view_car_legals.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/widgets/ev_app_custom_widgets.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/widgets/ev_app_loading_indicator.dart';

import 'package:wheels_kart/module/EVALAUATOR/core/ev_colors.dart';
import 'package:wheels_kart/common/dimensions.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_style.dart';
import 'package:wheels_kart/common/utils/routes.dart';
import 'package:wheels_kart/main.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/screens/inspect%20car/answer%20questions/e_eselect_portion_screen.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/screens/inspect%20car/upload%20vehilce%20photo/upload_vehicle_photos.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/bloc/get%20data/fetch%20document%20types/fetch_document_type_bloc.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/bloc/get%20data/fetch%20documents/fetch_documents_cubit.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/bloc/get%20data/fetch%20inspections/fetch_inspections_bloc.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/bloc/get%20data/fetch%20picture%20angles/fetch_picture_angles_cubit.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/bloc/get%20data/fetch_vehilce_photo/fetch_uploaded_vehilce_photos_cubit.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/bloc/submit%20answer%20controller/submit_answer_controller_cubit.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/model/inspection_data_model.dart';

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

class _InspectionStartScreenState extends State<InspectionStartScreen>
    with TickerProviderStateMixin, RouteAware {
  InspectionModel? inspectionModel;
  bool isLoading = true;
  bool isQuestionsAllCompleded = false;
  bool isLegalsAllUPloaded = false;
  bool isPicturedAllUploaded = false;

  late AnimationController _progressController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    log("inspectionId =>${widget.inspectionId}");
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    initScreen();
  }

  @override
  void didPopNext() {
    if (mounted) {
      initScreen();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    _progressController.dispose();
    _fadeController.dispose();
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  Future<void> _onFetchApis() async {
    // PHOTOS
    context.read<FetchPictureAnglesCubit>().onFetchPictureAngles(context);
    context.read<FetchUploadedVehilcePhotosCubit>().onFetchUploadVehiclePhotos(
      context,
      widget.inspectionId,
    );
    // DOCUMENTS
    context.read<FetchDocumentsCubit>().onFetchDocumets(
      context,
      widget.inspectionId,
    );
    context.read<FetchDocumentTypeBloc>().add(
      OnFetchDocumentTypeEvent(context: context),
    );
  }

  _checkQuestionsAreAnswersOrNot() {
    // QUESTIONS
    try {
      final currentState = BlocProvider.of<FetchInspectionsBloc>(context).state;
      if (currentState is SuccessFetchInspectionsState) {
        inspectionModel =
            currentState.listOfInspection
                .where((element) => element.inspectionId == widget.inspectionId)
                .toList()
                .first;

        isQuestionsAllCompleded = inspectionModel!.currentStatus.every(
          (element) => element.balance == 0,
        );
      }
    } catch (e) {
      log("Error - ${e}");
    }
  }

  _checkDocumetsAllUplaoded() {
    // DOCS
    final stateOfUploadedDocs =
        BlocProvider.of<FetchDocumentsCubit>(context).state;
    
    if (stateOfUploadedDocs is FetchDocumentsSuccessState
    ) {
      final vehicleLegalModel = stateOfUploadedDocs.vehicleLgalModel;
     

      bool isDocAllUploaded = false;

      
      final haveInsurenceDoc = vehicleLegalModel.documents.any(
        (element) => element.documentType == DocumentType.INSURANCE,
      );
      final haveRc = vehicleLegalModel.documents.any(
        (element) => element.documentType == DocumentType.RC_CARD,
      );
      isDocAllUploaded = haveRc && haveInsurenceDoc;
     
      final inspection = vehicleLegalModel.inspection;
      final numberOfAwners = inspection.noOfOwners;
      final roadTaxPaid = inspection.roadTaxPaid;
      final roadTaxValidity = inspection.roadTaxValidity;
      final insuranceType = inspection.insuranceType;
      final insuranceValidity = inspection.insuranceValidity;
      final currentRto = inspection.currentRto;
      final carLength = inspection.carLength;
      final cubicCapacity = inspection.cubicCapacity;
      final manufactureDate = inspection.manufactureDate;
      final noOfKeys = inspection.noOfKeys;
      final regDate = inspection.regDate;

      if (numberOfAwners.isEmpty ||
          roadTaxPaid.isEmpty ||
          roadTaxValidity.isEmpty ||
          insuranceType.isEmpty ||
          currentRto.isEmpty ||
          carLength.isEmpty ||
          cubicCapacity.isEmpty ||
          manufactureDate.isEmpty ||
          noOfKeys.isEmpty ||
          regDate.isEmpty ||
          insuranceValidity.isEmpty ||
          !isDocAllUploaded) {
        isLegalsAllUPloaded = false;
      } else {
        isLegalsAllUPloaded = true;
      }
      log("Doc" + isDocAllUploaded.toString());
      log(isLegalsAllUPloaded.toString());
    } else {
      log("Doc Not initialized.");
    }
  }

  _checkCarPhotosAllUplaoded() {
    // PHOTOS
    final stateOfUploadedPhotos =
        BlocProvider.of<FetchUploadedVehilcePhotosCubit>(context).state;

    final stateOfCarAngles =
        BlocProvider.of<FetchPictureAnglesCubit>(context).state;

    if (stateOfUploadedPhotos is FetchUploadedVehilcePhotosSuccessSate &&
        stateOfCarAngles is FetchPictureAnglesSuccessState) {
      final angles = stateOfCarAngles.pictureAngles;
      final uploadedPhotos = stateOfUploadedPhotos.vehiclePhtotos;

      for (var angle in angles) {
        if (uploadedPhotos.any((element) => element.angleId == angle.angleId)) {
          isPicturedAllUploaded = true;
        } else {
          isPicturedAllUploaded = false;
          break;
        }
      }
    } else {
      log("Photo Not initialized.");
    }
  }

  initScreen() async {
    // FETCH ALL APIS FOR CHECKING COMPLETED OR NOT
    try {
      _onFetchApis();
      await Future.delayed(Duration(seconds: 1));
      // -- Check completed Inspection Report --
      _checkQuestionsAreAnswersOrNot();
      // -- Check completed Documents --
      _checkDocumetsAllUplaoded();
      // -- Check completed Car Photos --
      _checkCarPhotosAllUplaoded();
      // await Future.delayed(Duration(seconds: 1));
      isLoading = false;
      setState(() {});
      _fadeController.forward();
      _progressController.forward();
    } catch (e) {
      log("Erro while fetching the iniScreen Function on initState()");
    }
  }

  double get completionProgress {
    int completed = 0;
    if (isPicturedAllUploaded) completed++;
    if (isLegalsAllUPloaded) completed++;
    if (isQuestionsAllCompleded) completed++;
    return completed / 3;
  }

  bool get isAllCompleted =>
      isPicturedAllUploaded && isLegalsAllUPloaded && isQuestionsAllCompleded;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: EvAppColors.DEFAULT_BLUE_DARK,
        leading: evCustomBackButton(context),
        title: Text(
          'Vehicle Inspection',
          style: EvAppStyle.style(
            color: EvAppColors.white,
            context: context,
            fontWeight: FontWeight.bold,
            size: AppDimensions.fontSize18(context),
          ),
        ),
        centerTitle: true,
      ),
      body:
          isLoading
              ? Center(child: EVAppLoadingIndicator())
              : FadeTransition(
                opacity: _fadeAnimation,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProgressHeader(),
                      const SizedBox(height: 30),
                      _buildInspectionSteps(),
                      const SizedBox(height: 40),
                      _buildSubmitButton(),
                    ],
                  ),
                ),
              ),
    );
  }

  Widget _buildProgressHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            EvAppColors.DEFAULT_BLUE_DARK,
            EvAppColors.DEFAULT_BLUE_DARK.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: EvAppColors.DEFAULT_BLUE_DARK.withOpacity(0.3),
            offset: const Offset(0, 8),
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Inspection Progress',
                style: EvAppStyle.style(
                  color: Colors.white,
                  context: context,
                  fontWeight: FontWeight.bold,
                  size: 20,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${(completionProgress * 100).toInt()}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          AnimatedBuilder(
            animation: _progressController,
            builder: (context, child) {
              return LinearProgressIndicator(
                value: completionProgress * _progressController.value,
                backgroundColor: Colors.white.withOpacity(0.3),
                valueColor: AlwaysStoppedAnimation<Color>(
                  isAllCompleted ? Colors.green : Colors.orange,
                ),
                minHeight: 8,
              );
            },
          ),
          const SizedBox(height: 12),
          Text(
            isAllCompleted
                ? 'All steps completed! Ready to submit.'
                : '${3 - [isPicturedAllUploaded, isLegalsAllUPloaded, isQuestionsAllCompleded].where((e) => e).length} steps remaining',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInspectionSteps() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Inspection Steps',
          style: EvAppStyle.style(
            context: context,
            size: 22,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 20),
        _buildEnhancedStepCard(
          title: "Vehicle Photos",
          subtitle: "Capture all required angles",
          icon: CupertinoIcons.camera_fill,
          isCompleted: isPicturedAllUploaded,
          onTap: () => _navigateToPhotos(),
          stepNumber: 1,
        ),
        const SizedBox(height: 16),
        _buildEnhancedStepCard(
          title: "Vehicle Legals",
          subtitle: "Upload required vehilce legals",
          icon: CupertinoIcons.doc_fill,
          isCompleted: isLegalsAllUPloaded,
          onTap: () => _navigateToDocuments(),
          stepNumber: 2,
        ),
        const SizedBox(height: 16),
        _buildEnhancedStepCard(
          title: "Inspection Report",
          subtitle: "Complete evaluation checklist",
          icon: CupertinoIcons.checkmark_seal_fill,
          isCompleted: isQuestionsAllCompleded,
          onTap: () => _navigateToReport(),
          stepNumber: 3,
        ),
      ],
    );
  }

  Widget _buildEnhancedStepCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isCompleted,
    required VoidCallback onTap,
    required int stepNumber,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color:
                  isCompleted
                      ? Colors.green.withOpacity(0.3)
                      : Colors.grey.withOpacity(0.2),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color:
                    isCompleted
                        ? Colors.green.withOpacity(0.1)
                        : Colors.grey.withOpacity(0.1),
                offset: const Offset(0, 4),
                blurRadius: 12,
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color:
                      isCompleted
                          ? Colors.green.withOpacity(0.1)
                          : EvAppColors.DEFAULT_BLUE_DARK.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Icon(
                        icon,
                        color:
                            isCompleted
                                ? Colors.green
                                : EvAppColors.DEFAULT_BLUE_DARK,
                        size: 28,
                      ),
                    ),
                    if (isCompleted)
                      Positioned(
                        top: 2,
                        right: 2,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color:
                                isCompleted ? Colors.green : Colors.grey[400],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              stepNumber.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          title,
                          style: EvAppStyle.style(
                            context: context,
                            size: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subtitle,
                      style: EvAppStyle.style(
                        context: context,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isCompleted
                                ? Colors.green.withOpacity(0.1)
                                : Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        isCompleted ? "Completed" : "Pending",
                        style: TextStyle(
                          color:
                              isCompleted
                                  ? Colors.green[700]
                                  : Colors.orange[700],
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: isAllCompleted ? _onSubmit : _onIncompleteSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: isAllCompleted ? Colors.green : Colors.grey[400],
          foregroundColor: Colors.white,
          elevation: isAllCompleted ? 8 : 2,
          shadowColor:
              isAllCompleted
                  ? Colors.green.withOpacity(0.3)
                  : Colors.grey.withOpacity(0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isAllCompleted) ...[
              const Icon(Icons.check_circle, size: 24),
              const SizedBox(width: 12),
            ],
            Text(
              isAllCompleted ? "Submit Inspection" : "Complete All Steps First",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToPhotos() {
    Navigator.of(context).push(
      AppRoutes.createRoute(
        UploadVehiclePhotos(inspectionId: widget.inspectionId),
      ),
    );
  }

  void _navigateToDocuments() {
    final state = context.read<FetchDocumentsCubit>().state;
    if (state is FetchDocumentsSuccessState) {
      if (isLegalsAllUPloaded) {
        Navigator.of(context).push(
          AppRoutes.createRoute(
            ViewCarLegals(inspectionId: widget.inspectionId,),
          ),
        );
      } else {
        Navigator.of(context).push(
          AppRoutes.createRoute(
            UploadCarLegals(inspectionId: widget.inspectionId),
          ),
        );
      }
    } else {
      // Navigator.of(context).push(
      //   AppRoutes.createRoute(
      //     UploadCarLegals(inspectionId: widget.inspectionId),
      //   ),
      // );
    }
  }

  void _navigateToReport() {
    Navigator.of(context).push(
      AppRoutes.createRoute(
        EvSelectPortionScreen(
          inspectionId: widget.inspectionId,
          instructionData: widget.instructionData,
        ),
      ),
    );
  }

  void _onSubmit() async {
    if (isAllCompleted) {
      log("Inspection submitted successfully");

      final isError = await context
          .read<EvSubmitAnswerControllerCubit>()
          .onSubmitInspectionForPending(context, widget.inspectionId);
      // Add your submission logic here

      if (isError) {
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Inspection submitted successfully!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        Navigator.of(context).pop();
      }
    }
  }

  void _onIncompleteSubmit() {
    if (!isPicturedAllUploaded) {
      _showWarningAndNavigate(
        "Upload Vehicle Photos",
        "Please upload all required vehicle photos before submitting.",
        _navigateToPhotos,
      );
    } else if (!isLegalsAllUPloaded) {
      _showWarningAndNavigate(
        "Upload Vehilce Legals",
        "Please upload all required vehilce legals before submitting.",
        _navigateToDocuments,
      );
    } else if (!isQuestionsAllCompleded) {
      _showWarningAndNavigate(
        "Complete Inspection",
        "Please complete the inspection report before submitting.",
        _navigateToReport,
      );
    }
  }

  void _showWarningAndNavigate(
    String title,
    String message,
    VoidCallback onNavigate,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.warning_amber, color: Colors.orange[600]),
              const SizedBox(width: 12),
              Text(title),
            ],
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onNavigate();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: EvAppColors.DEFAULT_BLUE_DARK,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Go Now',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
