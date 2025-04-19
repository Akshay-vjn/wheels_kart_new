import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wheels_kart/core/components/app_custom_widgets.dart';
import 'package:wheels_kart/core/components/app_empty_text.dart';
import 'package:wheels_kart/core/components/app_loading_indicator.dart';
import 'package:wheels_kart/core/components/app_margin.dart';
import 'package:wheels_kart/core/constant/colors.dart';
import 'package:wheels_kart/core/constant/dimensions.dart';
import 'package:wheels_kart/core/constant/style.dart';
import 'package:wheels_kart/core/utils/routes.dart';
import 'package:wheels_kart/module/evaluator/UI/screens/inspect%20car/answer%20questions/e_answer_question_screen.dart';
import 'package:wheels_kart/module/evaluator/UI/widgets/app_custom_selection_button.dart';
import 'package:wheels_kart/module/evaluator/data/bloc/get%20data/fetch%20inspections/fetch_inspections_bloc.dart';
import 'package:wheels_kart/module/evaluator/data/bloc/get%20data/fetch%20systems/fetch_systems_bloc.dart';
import 'package:wheels_kart/module/evaluator/data/model/inspection_data_model.dart';

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

class _EvSelectSystemScreenState extends State<EvSelectSystemScreen> {
  int? selectedindx;
  String? selectedSystemId;

  @override
  void initState() {
    super.initState();
    _fincCurrentCurrentStatus();
    context.read<FetchSystemsBloc>().add(
      OnFetchSystemsOfPortions(context: context, portionId: widget.portionId),
    );
  }

  late CurrentStatus current;
  _fincCurrentCurrentStatus() {
    try {
      final currentState = BlocProvider.of<FetchInspectionsBloc>(context).state;
      if (currentState is SuccessFetchInspectionsState) {
        final inspectionModel =
            currentState.listOfInspection
                .where((element) => element.inspectionId == widget.inspectionID)
                .toList()
                .first;
        current =
            inspectionModel.currentStatus
                .where((element) => element.portionId == widget.portionId)
                .toList()
                .first;
      }
    } catch (e) {
      log("Erro - ${e}");
    }
  }

  bool calledBackFunction = false;
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Select System',
            style: AppStyle.style(
              color: AppColors.white,
              context: context,
              fontWeight: FontWeight.bold,
              size: AppDimensions.fontSize18(context),
            ),
          ),
          backgroundColor: AppColors.DEFAULT_BLUE_DARK,
          leading: customBackButton(
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
        ),
        body: BlocListener<FetchInspectionsBloc, FetchInspectionsState>(
          listener: (context, state) {
            _fincCurrentCurrentStatus();
            setState(() {});
          },
          child: BlocBuilder<FetchSystemsBloc, FetchSystemsState>(
            builder: (context, state) {
              switch (state) {
                case LoadingFetchSystemsState():
                  {
                    return AppLoadingIndicator();
                  }
                case SuccessFetchSystemsState():
                  {
                    return AppMargin(
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          System? currentSystem;
                          final data =
                              current.systems
                                  .where(
                                    (element) =>
                                        element.systemId ==
                                        state.listOfSystemes[index].systemId,
                                  )
                                  .toList();
                          if (data.isNotEmpty) {
                            currentSystem = data.first;
                          }
                          return EvAppCustomeSelctionButton(
                            fillColor:
                                currentSystem != null &&
                                        currentSystem.balance == 0
                                    ? AppColors.kGreen.withAlpha(70)
                                    : null,
                            isButtonBorderView: true,
                            currentIndex: index,
                            onTap: () {
                              setState(() {
                                selectedindx = index;
                                selectedSystemId =
                                    state.listOfSystemes[index].systemId;
                              });
                              if (selectedSystemId != null) {
                                Navigator.of(context).push(
                                  AppRoutes.createRoute(
                                    EvAnswerQuestionScreen(
                                      portionName: widget.portionName,
                                      systemName:
                                          state
                                              .listOfSystemes[index]
                                              .systemName,
                                      portionId: widget.portionId,
                                      systemId: selectedSystemId!,
                                      inspectionId: widget.inspectionID,
                                    ),
                                  ),
                                );
                              }
                            },
                            selectedButtonIndex: selectedindx,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppDimensions.paddingSize10,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  if (currentSystem != null &&
                                      currentSystem.balance == 0)
                                    Icon(
                                      Icons.check_circle_outline_outlined,
                                      color: AppColors.kGreen,
                                    ),

                                  Text(
                                    state.listOfSystemes[index].systemName,
                                    style: AppStyle.style(
                                      fontWeight: FontWeight.w600,
                                      context: context,
                                    ),
                                  ),

                                  currentSystem != null
                                      ? Text(
                                        '${currentSystem.completed.toString()}/${currentSystem.totalQuestions.toString()}',
                                        style: AppStyle.style(
                                          fontWeight: FontWeight.w600,
                                          color:
                                              currentSystem.balance == 0
                                                  ? AppColors.kGreen
                                                  : AppColors.grey,
                                          context: context,
                                        ),
                                      )
                                      : SizedBox(),
                                ],
                              ),
                            ),
                          );
                        },

                        itemCount: state.listOfSystemes.length,
                      ),
                    );
                  }
                case ErrorFetchSystemsState():
                  {
                    return AppEmptyText(text: state.errorMessage);
                  }
                default:
                  {
                    return SizedBox();
                  }
              }
            },
          ),
        ),
      ),
    );
  }
}
