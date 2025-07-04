
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/widgets/ev_app_custom_widgets.dart';
import 'package:wheels_kart/common/components/app_empty_text.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/widgets/ev_app_loading_indicator.dart';
import 'package:wheels_kart/common/components/app_margin.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_colors.dart';
import 'package:wheels_kart/common/dimensions.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_style.dart';
import 'package:wheels_kart/common/utils/routes.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/screens/inspect%20car/answer%20questions/e_select_system_screen.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/bloc/get%20data/fetch%20inspections/fetch_inspections_bloc.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/bloc/get%20data/fetch%20portions/fetch_portions_bloc.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/model/inspection_data_model.dart';

class EvSelectPortionScreen extends StatefulWidget {
  final String inspectionId;
  final String? instructionData;

  const EvSelectPortionScreen({
    super.key,
    required this.inspectionId,
    required this.instructionData,
  });

  @override
  State<EvSelectPortionScreen> createState() => _EvSelectPortionScreenState();
}

class _EvSelectPortionScreenState extends State<EvSelectPortionScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late InspectionModel inspectionModel;
  int? selectedIndex;
  String? selectedPortionId;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _findInspectionData();
    _fetchPortions();
    _scheduleInstructionDisplay();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));
    
    _fadeController.forward();
    _slideController.forward();
  }

  void _fetchPortions() {
    context.read<FetchPortionsBloc>().add(
      OngetPostionsEvent(context: context, inspectionId: widget.inspectionId),
    );
  }

  void _scheduleInstructionDisplay() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.instructionData != null && 
          inspectionModel.currentStatus.isEmpty) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) _showInstructions();
        });
      }
    });
  }

  void _findInspectionData() {
    try {
      final currentState = BlocProvider.of<FetchInspectionsBloc>(context).state;
      if (currentState is SuccessFetchInspectionsState) {
        inspectionModel = currentState.listOfInspection
            .firstWhere((element) => element.inspectionId == widget.inspectionId);
      }
    } catch (e) {
      log("Error finding inspection data: $e");
    }
  }

  String get _instructionHtml => """
    <!DOCTYPE html>
    <html>
    <head>
      <meta name="viewport" content="width=device-width, initial-scale=1">
      <style>
        body { 
          font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; 
          padding: 16px; 
          line-height: 1.6;
          color: #333;
        }
        ul { 
          padding-left: 20px; 
          margin: 12px 0;
        }
        li { 
          margin-bottom: 8px; 
          padding-left: 4px;
        }
        h1, h2, h3, h4, h5, h6 {
          color: #2c3e50;
          margin-top: 20px;
          margin-bottom: 10px;
        }
        p { margin-bottom: 12px; }
        strong { color: #2c3e50; }
      </style>
    </head>
    <body>
      ${widget.instructionData ?? ''}
    </body>
    </html>
  """;

  double _calculateProgress(List<dynamic> portions, List<CurrentStatus> statuses) {
    if (portions.isEmpty) return 0.0;
    
    int completedPortions = 0;
    for (var portion in portions) {
      final status = statuses.firstWhere(
        (s) => s.portionId == portion.portionId,
        orElse: () => CurrentStatus(balance: 1, completed: 0, totalQuestions: 1, portionId: '', portionName: "",systems: []),
      );
      if (status.balance == 0) completedPortions++;
    }
    
    return completedPortions / portions.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: BlocListener<FetchInspectionsBloc, FetchInspectionsState>(
        listener: (context, state) {
          _findInspectionData();
          if (mounted) setState(() {});
        },
        child: BlocBuilder<FetchPortionsBloc, FetchPortionsState>(
          builder: (context, state) => _buildBody(state),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: EvAppColors.DEFAULT_BLUE_DARK,
      foregroundColor: Colors.white,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Portion',
            style: EvAppStyle.style(
              color: EvAppColors.white,
              context: context,
              fontWeight: FontWeight.bold,
              size: AppDimensions.fontSize18(context),
            ),
          ),
          Text(
            'Choose a section to inspect',
            style: EvAppStyle.style(
              color: EvAppColors.white.withOpacity(0.8),
              context: context,
              size: AppDimensions.fontSize12(context),
            ),
          ),
        ],
      ),
      leading: evCustomBackButton(context),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(4),
        child: Container(
          height: 4,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                EvAppColors.DEFAULT_BLUE_DARK.withOpacity(0.1),
                Colors.transparent,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(FetchPortionsState state) {
    switch (state) {
      case LoadingFetchPortionsState():
        return _buildLoadingState();
      case SuccessFetchPortionsState():
        return _buildSuccessState(state);
      case ErrorFetchPortionsState():
        return _buildErrorState(state);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          EVAppLoadingIndicator(),
          const SizedBox(height: 16),
          Text(
            'Loading inspection portions...',
            style: EvAppStyle.style(
              context: context,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessState(SuccessFetchPortionsState state) {
    final progress = _calculateProgress(state.listOfPortios, inspectionModel.currentStatus);
    
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Column(
          children: [
            _buildProgressHeader(progress, state.listOfPortios.length),
            Expanded(
              child: _buildPortionsList(state),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressHeader(double progress, int totalPortions) {
    final completedPortions = (progress * totalPortions).round();
    
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Inspection Progress',
                style: EvAppStyle.style(
                  context: context,
                  fontWeight: FontWeight.w600,
                  size: AppDimensions.fontSize16(context),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: progress == 1.0 ? EvAppColors.kGreen : EvAppColors.DEFAULT_BLUE_DARK,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$completedPortions/$totalPortions',
                  style: EvAppStyle.style(
                    context: context,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    size: AppDimensions.fontSize12(context),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                progress == 1.0 ? EvAppColors.kGreen : EvAppColors.DEFAULT_BLUE_DARK,
              ),
              minHeight: 8,
            ),
          ),
          if (progress == 1.0) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.check_circle, color: EvAppColors.kGreen, size: 16),
                const SizedBox(width: 6),
                Text(
                  'All portions completed!',
                  style: EvAppStyle.style(
                    context: context,
                    color: EvAppColors.kGreen,
                    fontWeight: FontWeight.w500,
                    size: AppDimensions.fontSize12(context),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPortionsList(SuccessFetchPortionsState state) {
    return AppMargin(
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: state.listOfPortios.length,
        itemBuilder: (context, index) => _buildPortionItem(state, index),
      ),
    );
  }

  Widget _buildPortionItem(SuccessFetchPortionsState state, int index) {
    final portion = state.listOfPortios[index];
    final currentStatus = inspectionModel.currentStatus.firstWhere(
      (element) => element.portionId == portion.portionId,
      orElse: () => CurrentStatus(balance: 1, completed: 0, totalQuestions: 1, portionId: '',portionName: "",systems: []),
    );

    final isCompleted = currentStatus.balance == 0;
    final progressPercentage = currentStatus.totalQuestions > 0 
        ? (currentStatus.completed / currentStatus.totalQuestions * 100).round()
        : 0;

    return AnimatedContainer(
      duration: Duration(milliseconds: 300 + (index * 50)),
      curve: Curves.easeOutCubic,
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _onPortionTap(index, portion.portionId, portion.portionName),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: selectedIndex == index 
                    ? EvAppColors.DEFAULT_BLUE_DARK 
                    : Colors.transparent,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    _buildPortionIcon(isCompleted, progressPercentage),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            portion.portionName,
                            style: EvAppStyle.style(
                              color: isCompleted ? EvAppColors.kGreen : null,
                              fontWeight: FontWeight.w600,
                              context: context,
                              size: AppDimensions.fontSize16(context),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _getStatusText(currentStatus, isCompleted),
                            style: EvAppStyle.style(
                              color: isCompleted ? EvAppColors.kGreen : Colors.grey[600],
                              context: context,
                              size: AppDimensions.fontSize12(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${currentStatus.completed}/${currentStatus.totalQuestions}',
                          style: EvAppStyle.style(
                            fontWeight: FontWeight.bold,
                            color: isCompleted ? EvAppColors.kGreen : EvAppColors.DEFAULT_BLUE_DARK,
                            context: context,
                            size: AppDimensions.fontSize15(context),
                          ),
                        ),
                        if (!isCompleted) ...[
                          const SizedBox(height: 4),
                          Text(
                            '$progressPercentage%',
                            style: EvAppStyle.style(
                              color: Colors.grey[500],
                              context: context,
                              size: AppDimensions.fontSize10(context),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
                if (!isCompleted && currentStatus.totalQuestions > 0) ...[
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: currentStatus.completed / currentStatus.totalQuestions,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(EvAppColors.DEFAULT_BLUE_DARK),
                      minHeight: 4,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPortionIcon(bool isCompleted, int progressPercentage) {
    if (isCompleted) {
      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: EvAppColors.kGreen.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.check_circle,
          color: EvAppColors.kGreen,
          size: 28,
        ),
      );
    } else {
      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: EvAppColors.DEFAULT_BLUE_DARK.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            CircularProgressIndicator(
              value: progressPercentage / 100,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(EvAppColors.DEFAULT_BLUE_DARK),
              strokeWidth: 3,
            ),
            Icon(
              Icons.assignment_outlined,
              color: EvAppColors.DEFAULT_BLUE_DARK,
              size: 20,
            ),
          ],
        ),
      );
    }
  }

  String _getStatusText(CurrentStatus status, bool isCompleted) {
    if (isCompleted) {
      return 'Completed ✓';
    } else if (status.completed > 0) {
      return 'In Progress';
    } else {
      return 'Not Started';
    }
  }

  void _onPortionTap(int index, String portionId, String portionName) {
    setState(() {
      selectedIndex = index;
      selectedPortionId = portionId;
    });

    // Add haptic feedback
    // HapticFeedback.lightImpact();

    Navigator.of(context).push(
      AppRoutes.createRoute(
        EvSelectSystemScreen(
          portionName: portionName,
          inspectionID: widget.inspectionId,
          portionId: portionId,
        ),
      ),
    );
  }

  Widget _buildErrorState(ErrorFetchPortionsState state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          AppEmptyText(text: state.errorMessage),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _fetchPortions,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: EvAppColors.DEFAULT_BLUE_DARK,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _showInstructions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildInstructionModal(),
    );
  }

  Widget _buildInstructionModal() {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (context, scrollController) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            _buildModalHandle(),
            _buildModalHeader(),
            Expanded(
              child: _buildModalContent(scrollController),
            ),
            _buildModalFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildModalHandle() {
    return Container(
      width: 40,
      height: 4,
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildModalHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: EvAppColors.DEFAULT_BLUE_DARK.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.info_outline,
              color: EvAppColors.DEFAULT_BLUE_DARK,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Instructions',
                  style: EvAppStyle.style(
                    context: context,
                    size: AppDimensions.fontSize18(context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Please read carefully before proceeding',
                  style: EvAppStyle.style(
                    context: context,
                    color: Colors.grey[600],
                    size: AppDimensions.fontSize12(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModalContent(ScrollController scrollController) {
    return SingleChildScrollView(
      controller: scrollController,
      padding: const EdgeInsets.all(20),
      child: Html(
        data: _instructionHtml,
        style: {
          "body": Style(margin: Margins.zero, padding: HtmlPaddings.zero),
          "ul": Style(fontSize: FontSize.medium, margin: Margins.symmetric(vertical: 8)),
          "li": Style(fontSize: FontSize.medium, margin: Margins.only(bottom: 4)),
          "table": Style(backgroundColor: const Color.fromARGB(0x50, 0xee, 0xee, 0xee)),
          "tr": Style(border: const Border(bottom: BorderSide(color: Colors.grey))),
          "th": Style(
            padding: HtmlPaddings.all(12),
            backgroundColor: Colors.grey[100],
            fontWeight: FontWeight.bold,
          ),
          "td": Style(
            padding: HtmlPaddings.all(12),
            alignment: Alignment.topLeft,
          ),
          "h1, h2, h3, h4, h5, h6": Style(
            color: const Color(0xFF2c3e50),
            fontWeight: FontWeight.bold,
          ),
        },
      ),
    );
  }

  Widget _buildModalFooter() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: EvAppColors.DEFAULT_BLUE_DARK,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Text(
              'Got it, let\'s start!',
              style: EvAppStyle.style(
                context: context,
                color: Colors.white,
                fontWeight: FontWeight.w600,
                size: AppDimensions.fontSize16(context),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }
}