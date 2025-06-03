// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:wheels_kart/core/components/app_custom_widgets.dart';
// import 'package:wheels_kart/core/components/app_empty_text.dart';
// import 'package:wheels_kart/core/components/app_loading_indicator.dart';
// import 'package:wheels_kart/core/components/app_margin.dart';
// import 'package:wheels_kart/core/constant/colors.dart';
// import 'package:wheels_kart/core/constant/dimensions.dart';
// import 'package:wheels_kart/core/constant/style.dart';
// import 'package:wheels_kart/core/utils/routes.dart';
// import 'package:wheels_kart/module/evaluator/UI/screens/inspect%20car/answer%20questions/e_answer_question_screen.dart';
// import 'package:wheels_kart/module/evaluator/UI/widgets/app_custom_selection_button.dart';
// import 'package:wheels_kart/module/evaluator/data/bloc/get%20data/fetch%20inspections/fetch_inspections_bloc.dart';
// import 'package:wheels_kart/module/evaluator/data/bloc/get%20data/fetch%20systems/fetch_systems_bloc.dart';
// import 'package:wheels_kart/module/evaluator/data/model/inspection_data_model.dart';

// class EvSelectSystemScreen extends StatefulWidget {
//   final String portionId;
//   final String inspectionID;
//   final String portionName;

//   const EvSelectSystemScreen({
//     super.key,
//     required this.portionId,
//     required this.inspectionID,
//     required this.portionName,
//   });

//   @override
//   State<EvSelectSystemScreen> createState() => _EvSelectSystemScreenState();
// }

// class _EvSelectSystemScreenState extends State<EvSelectSystemScreen> {
//   int? selectedindx;
//   String? selectedSystemId;

//   @override
//   void initState() {
//     super.initState();
//     _fincCurrentCurrentStatus();
//     context.read<FetchSystemsBloc>().add(
//       OnFetchSystemsOfPortions(context: context, portionId: widget.portionId),
//     );
//   }

//   late CurrentStatus current;
//   _fincCurrentCurrentStatus() {
//     try {
//       final currentState = BlocProvider.of<FetchInspectionsBloc>(context).state;
//       if (currentState is SuccessFetchInspectionsState) {
//         final inspectionModel =
//             currentState.listOfInspection
//                 .where((element) => element.inspectionId == widget.inspectionID)
//                 .toList()
//                 .first;
//         current =
//             inspectionModel.currentStatus
//                 .where((element) => element.portionId == widget.portionId)
//                 .toList()
//                 .first;
//       }
//     } catch (e) {
//       log("Erro - ${e}");
//     }
//   }

//   bool calledBackFunction = false;
//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       canPop: false,
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text(
//             'Select System',
//             style: AppStyle.style(
//               color: AppColors.white,
//               context: context,
//               fontWeight: FontWeight.bold,
//               size: AppDimensions.fontSize18(context),
//             ),
//           ),
//           backgroundColor: AppColors.DEFAULT_BLUE_DARK,
//           leading: customBackButton(
//             context,
//             onPressed: () {
//               if (!calledBackFunction) {
//                 calledBackFunction = true;
//                 context.read<FetchInspectionsBloc>().add(
//                   OnGetInspectionList(
//                     context: context,
//                     inspetionListType: 'ASSIGNED',
//                   ),
//                 );
//               }

//               Navigator.of(context).pop();
//             },
//           ),
//         ),
//         body: BlocListener<FetchInspectionsBloc, FetchInspectionsState>(
//           listener: (context, state) {
//             _fincCurrentCurrentStatus();
//             setState(() {});
//           },
//           child: BlocBuilder<FetchSystemsBloc, FetchSystemsState>(
//             builder: (context, state) {
//               switch (state) {
//                 case LoadingFetchSystemsState():
//                   {
//                     return AppLoadingIndicator();
//                   }
//                 case SuccessFetchSystemsState():
//                   {
//                     return AppMargin(
//                       child: ListView.builder(
//                         physics: BouncingScrollPhysics(),
//                         itemBuilder: (context, index) {
//                           System? currentSystem;
//                           final data =
//                               current.systems
//                                   .where(
//                                     (element) =>
//                                         element.systemId ==
//                                         state.listOfSystemes[index].systemId,
//                                   )
//                                   .toList();
//                           if (data.isNotEmpty) {
//                             currentSystem = data.first;
//                           }
//                           return EvAppCustomeSelctionButton(
//                             fillColor:
//                                 currentSystem != null &&
//                                         currentSystem.balance == 0
//                                     ? AppColors.kGreen.withAlpha(70)
//                                     : null,
//                             isButtonBorderView: true,
//                             currentIndex: index,
//                             onTap: () {
//                               setState(() {
//                                 selectedindx = index;
//                                 selectedSystemId =
//                                     state.listOfSystemes[index].systemId;
//                               });
//                               if (selectedSystemId != null) {
//                                 Navigator.of(context).push(
//                                   AppRoutes.createRoute(
//                                     EvAnswerQuestionScreen(
//                                       portionName: widget.portionName,
//                                       systemName:
//                                           state
//                                               .listOfSystemes[index]
//                                               .systemName,
//                                       portionId: widget.portionId,
//                                       systemId: selectedSystemId!,
//                                       inspectionId: widget.inspectionID,
//                                     ),
//                                   ),
//                                 );
//                               }
//                             },
//                             selectedButtonIndex: selectedindx,
//                             child: Padding(
//                               padding: EdgeInsets.symmetric(
//                                 horizontal: AppDimensions.paddingSize10,
//                               ),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   if (currentSystem != null &&
//                                       currentSystem.balance == 0)
//                                     Icon(
//                                       Icons.check_circle_outline_outlined,
//                                       color: AppColors.kGreen,
//                                     ),

//                                   Text(
//                                     state.listOfSystemes[index].systemName,
//                                     style: AppStyle.style(
//                                       fontWeight: FontWeight.w600,
//                                       context: context,
//                                     ),
//                                   ),

//                                   currentSystem != null
//                                       ? Text(
//                                         '${currentSystem.completed.toString()}/${currentSystem.totalQuestions.toString()}',
//                                         style: AppStyle.style(
//                                           fontWeight: FontWeight.w600,
//                                           color:
//                                               currentSystem.balance == 0
//                                                   ? AppColors.kGreen
//                                                   : AppColors.grey,
//                                           context: context,
//                                         ),
//                                       )
//                                       : SizedBox(),
//                                 ],
//                               ),
//                             ),
//                           );
//                         },

//                         itemCount: state.listOfSystemes.length,
//                       ),
//                     );
//                   }
//                 case ErrorFetchSystemsState():
//                   {
//                     return AppEmptyText(text: state.errorMessage);
//                   }
//                 default:
//                   {
//                     return SizedBox();
//                   }
//               }
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/widgets/ev_app_custom_widgets.dart';
import 'package:wheels_kart/common/components/app_empty_text.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/widgets/ev_app_loading_indicator.dart';
import 'package:wheels_kart/common/components/app_margin.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_colors.dart';
import 'package:wheels_kart/common/dimensions.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_style.dart';
import 'package:wheels_kart/common/utils/routes.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/screens/inspect%20car/answer%20questions/e_answer_question_screen.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/widgets/ev_app_custom_selection_button.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/bloc/get%20data/fetch%20inspections/fetch_inspections_bloc.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/bloc/get%20data/fetch%20systems/fetch_systems_bloc.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/model/inspection_data_model.dart';

class EvSelectSystemScreen extends StatefulWidget {
  final String portionId;
  final String inspectionID;
  final String portionName;

  const EvSelectSystemScreen({
    super.key,
    required this.portionId,
    required this.inspectionID,
    required this.portionName,
  });

  @override
  State<EvSelectSystemScreen> createState() => _EvSelectSystemScreenState();
}

class _EvSelectSystemScreenState extends State<EvSelectSystemScreen>
    with TickerProviderStateMixin {
  int? selectedIndex;
  String? selectedSystemId;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _findCurrentStatus();
    context.read<FetchSystemsBloc>().add(
      OnFetchSystemsOfPortions(context: context, portionId: widget.portionId),
    );
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  CurrentStatus? current;
  
  void _findCurrentStatus() {
    try {
      final currentState = BlocProvider.of<FetchInspectionsBloc>(context).state;
      if (currentState is SuccessFetchInspectionsState) {
        final inspectionModel = currentState.listOfInspection
            .where((element) => element.inspectionId == widget.inspectionID)
            .toList()
            .firstOrNull;
        
        if (inspectionModel != null) {
          current = inspectionModel.currentStatus
              .where((element) => element.portionId == widget.portionId)
              .toList()
              .firstOrNull;
        }
      }
    } catch (e) {
      log("Error - $e");
      current = null;
    }
  }

  double _calculateOverallProgress() {
    if (current?.systems.isEmpty ?? true) return 0.0;
    
    int totalQuestions = 0;
    int completedQuestions = 0;
    
    for (var system in current!.systems) {
      totalQuestions += system.totalQuestions;
      completedQuestions += system.completed;
    }
    
    return totalQuestions > 0 ? completedQuestions / totalQuestions : 0.0;
  }

  bool calledBackFunction = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: _buildAppBar(),
        body: BlocListener<FetchInspectionsBloc, FetchInspectionsState>(
          listener: (context, state) {
            _findCurrentStatus();
            setState(() {});
          },
          child: Column(
            children: [
              _buildProgressHeader(),
              Expanded(
                child: BlocBuilder<FetchSystemsBloc, FetchSystemsState>(
                  builder: (context, state) {
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      child: _buildStateContent(state),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: EvAppColors.DEFAULT_BLUE_DARK,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select System',
            style: EvAppStyle.style(
              color: EvAppColors.white,
              context: context,
              fontWeight: FontWeight.bold,
              size: AppDimensions.fontSize18(context),
            ),
          ),
          Text(
            widget.portionName,
            style: EvAppStyle.style(
              color: EvAppColors.white.withOpacity(0.8),
              context: context,
              fontWeight: FontWeight.w400,
              size: AppDimensions.fontSize15(context),
            ),
          ),
        ],
      ),
      leading: evCustomBackButton(
        context,
        onPressed: () {
          if (!calledBackFunction) {
            calledBackFunction = true;
            context.read<FetchInspectionsBloc>().add(
              OnGetInspectionList(
                context: context,
                inspetionListType: 'ASSIGNED',
              ),
            );
          }
          Navigator.of(context).pop();
        },
      ),
      actions: [
        IconButton(
          onPressed: () {
            context.read<FetchSystemsBloc>().add(
              OnFetchSystemsOfPortions(
                context: context, 
                portionId: widget.portionId
              ),
            );
          },
          icon: const Icon(Icons.refresh, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildProgressHeader() {
    final overallProgress = _calculateOverallProgress();
    
    // Only show progress header if current data is available
    if (current == null) {
      return const SizedBox.shrink();
    }
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            EvAppColors.DEFAULT_BLUE_DARK,
            EvAppColors.DEFAULT_BLUE_DARK.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Overall Progress',
                style: EvAppStyle.style(
                  color: EvAppColors.white,
                  context: context,
                  fontWeight: FontWeight.w600,
                  size: AppDimensions.fontSize16(context),
                ),
              ),
              Text(
                '${(overallProgress * 100).toInt()}%',
                style: EvAppStyle.style(
                  color: EvAppColors.white,
                  context: context,
                  fontWeight: FontWeight.bold,
                  size: AppDimensions.fontSize16(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: overallProgress.clamp(0.0, 1.0)),
            duration: const Duration(milliseconds: 1500),
            curve: Curves.easeInOut,
            builder: (context, value, child) {
              return LinearProgressIndicator(
                value: value.clamp(0.0, 1.0),
                backgroundColor: Colors.white.withOpacity(0.3),
                valueColor: AlwaysStoppedAnimation<Color>(
                  value >= 1.0 ? EvAppColors.kGreen : Colors.white,
                ),
                minHeight: 8,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStateContent(FetchSystemsState state) {
    switch (state) {
      case LoadingFetchSystemsState():
        return _buildLoadingState();
      case SuccessFetchSystemsState():
        _animationController.forward();
        return _buildSuccessState(state);
      case ErrorFetchSystemsState():
        return _buildErrorState(state);
      default:
        return const SizedBox();
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
            'Loading systems...',
            style: EvAppStyle.style(
              color: Colors.grey[600],
              context: context,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessState(SuccessFetchSystemsState state) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: AppMargin(
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 16),
          itemBuilder: (context, index) {
            return _buildSystemCard(state, index);
          },
          itemCount: state.listOfSystemes.length,
        ),
      ),
    );
  }

  Widget _buildSystemCard(SuccessFetchSystemsState state, int index) {
    System? currentSystem;
    final data = current?.systems
        .where((element) =>
            element.systemId == state.listOfSystemes[index].systemId)
        .toList();
    
    if (data!=null&&data.isNotEmpty) {
      currentSystem = data.first;
    }

    final isCompleted = currentSystem != null && currentSystem.balance == 0;
    final progress = currentSystem != null 
        ? currentSystem.completed / currentSystem.totalQuestions 
        : 0.0;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + (index * 100)),
      curve: Curves.easeOutBack,
      builder: (context, animationValue, child) {
        // Clamp the animation value to ensure it stays within valid range
        final clampedValue = animationValue.clamp(0.0, 1.0);
        return Transform.translate(
          offset: Offset(0, 50 * (1 - clampedValue)),
          child: Opacity(
            opacity: clampedValue,
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => _onSystemTap(state, index),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            _buildStatusIcon(isCompleted, progress),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    state.listOfSystemes[index].systemName,
                                    style: EvAppStyle.style(
                                      fontWeight: FontWeight.w700,
                                      context: context,
                                      size: AppDimensions.fontSize16(context),
                                    ),
                                  ),
                                  if (currentSystem != null) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      '${currentSystem.completed} of ${currentSystem.totalQuestions} questions completed',
                                      style: EvAppStyle.style(
                                        color: Colors.grey[600],
                                        context: context,
                                        size: AppDimensions.fontSize15(context),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            _buildProgressIndicator(currentSystem, isCompleted),
                          ],
                        ),
                        if (currentSystem != null && !isCompleted) ...[
                          const SizedBox(height: 16),
                          _buildProgressBar(progress),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusIcon(bool isCompleted, double progress) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isCompleted 
            ? EvAppColors.kGreen.withOpacity(0.2)
            : progress > 0
                ? EvAppColors.DEFAULT_BLUE_DARK.withOpacity(0.2)
                : Colors.grey[200],
      ),
      child: Icon(
        isCompleted 
            ? Icons.check_circle
            : progress > 0
                ? Icons.play_circle_outline
                : Icons.circle_outlined,
        color: isCompleted 
            ? EvAppColors.kGreen
            : progress > 0
                ? EvAppColors.DEFAULT_BLUE_DARK
                : Colors.grey[400],
        size: 28,
      ),
    );
  }

  Widget _buildProgressIndicator(System? currentSystem, bool isCompleted) {
    if (currentSystem == null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          'Start',
          style: EvAppStyle.style(
            color: Colors.grey[600],
            context: context,
            fontWeight: FontWeight.w600,
            size: AppDimensions.fontSize12(context),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isCompleted 
            ? EvAppColors.kGreen.withOpacity(0.2)
            : EvAppColors.DEFAULT_BLUE_DARK.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '${currentSystem.completed}/${currentSystem.totalQuestions}',
        style: EvAppStyle.style(
          color: isCompleted 
              ? EvAppColors.kGreen
              : EvAppColors.DEFAULT_BLUE_DARK,
          context: context,
          fontWeight: FontWeight.w700,
          size: AppDimensions.fontSize12(context),
        ),
      ),
    );
  }

  Widget _buildProgressBar(double progress) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: progress.clamp(0.0, 1.0)),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return LinearProgressIndicator(
          value: value.clamp(0.0, 1.0),
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(
            EvAppColors.DEFAULT_BLUE_DARK,
          ),
          minHeight: 4,
        );
      },
    );
  }

  Widget _buildErrorState(ErrorFetchSystemsState state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red[300],
          ),
          const SizedBox(height: 16),
          AppEmptyText(text: state.errorMessage),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              context.read<FetchSystemsBloc>().add(
                OnFetchSystemsOfPortions(
                  context: context,
                  portionId: widget.portionId,
                ),
              );
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: EvAppColors.DEFAULT_BLUE_DARK,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onSystemTap(SuccessFetchSystemsState state, int index) {
    setState(() {
      selectedIndex = index;
      selectedSystemId = state.listOfSystemes[index].systemId;
    });

    // Add haptic feedback
    // HapticFeedback.lightImpact();

    if (selectedSystemId != null) {
      Navigator.of(context).push(
        AppRoutes.createRoute(
          EvAnswerQuestionScreen(
            portionName: widget.portionName,
            systemName: state.listOfSystemes[index].systemName,
            portionId: widget.portionId,
            systemId: selectedSystemId!,
            inspectionId: widget.inspectionID,
          ),
        ),
      );
    }
  }
}