import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wheels_kart/core/components/app_spacer.dart';
import 'package:wheels_kart/core/constant/colors.dart';
import 'package:wheels_kart/core/constant/dimensions.dart';
import 'package:wheels_kart/core/constant/style.dart';
import 'package:wheels_kart/core/utils/responsive_helper.dart';
import 'package:wheels_kart/core/utils/routes.dart';
import 'package:wheels_kart/module/evaluator/data/bloc/get%20data/fetch%20car%20models/fetch_car_model_bloc.dart';
import 'package:wheels_kart/module/evaluator/data/model/car_models_model.dart';
import 'package:wheels_kart/module/evaluator/data/model/evaluation_data_model.dart';
import 'package:wheels_kart/module/evaluator/UI/screens/inspect%20car/fill%20basic%20details/4_select_varient_type.dart';
import 'package:wheels_kart/module/evaluator/UI/widgets/app_custom_selection_button.dart';
import 'package:wheels_kart/core/components/app_custom_widgets.dart';
import 'package:wheels_kart/core/components/app_empty_text.dart';
import 'package:wheels_kart/core/components/app_loading_indicator.dart';
import 'package:wheels_kart/core/components/app_margin.dart';
import 'package:wheels_kart/module/evaluator/UI/widgets/app_search_field.dart';

class EvSelectAndSearchCarModelScreen extends StatefulWidget {
  EvaluationDataEntryModel evaluationDataEntryModel;
  EvSelectAndSearchCarModelScreen({
    super.key,
    required this.evaluationDataEntryModel,
  });

  @override
  State<EvSelectAndSearchCarModelScreen> createState() =>
      _EvSelectAndSearchCarModelScreenState();
}

class _EvSelectAndSearchCarModelScreenState
    extends State<EvSelectAndSearchCarModelScreen> {
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<EvFetchCarModelBloc>().add(
      InitialFetchCarModelEvent(
        context: context,
        makeId: widget.evaluationDataEntryModel.makeId!,
        makeYear: widget.evaluationDataEntryModel.makeYear!,
      ),
    );
  }

  List<CarModeModel> listOfCarModel = [];
  int? selectedCarModelIndex;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            surfaceTintColor: Colors.transparent,
            shadowColor: Colors.transparent,
            backgroundColor: AppColors.DEFAULT_BLUE_DARK,
            foregroundColor: Colors.transparent,
            leading: customBackButton(context, color: AppColors.kWhite),
            floating: true,
            pinned: false,
            snap: true,
            title: Text(
              'Select car model',
              style: AppStyle.style(
                context: context,
                fontWeight: FontWeight.w500,
                color: AppColors.kWhite,
                size: AppDimensions.fontSize18(context),
              ),
            ),
            toolbarHeight: h(context) * .07,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(h(context) * .09),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: AppDimensions.paddingSize15,
                  right: AppDimensions.paddingSize15,
                  bottom: AppDimensions.paddingSize25,
                ),
                child: EvAppSearchField(
                  controller: searchController,
                  hintText: 'Search car model',
                  onChanged: (value) {
                    context.read<EvFetchCarModelBloc>().add(
                      OnSearchCarModelEvent(
                        initialListOfCarModels: listOfCarModel,
                        query: value,
                      ),
                    );
                  },
                ),
              ),
            ),
            flexibleSpace: const FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
            ),
          ),
          SliverList.list(
            children: [
              BlocConsumer<EvFetchCarModelBloc, EvFetchCarModelState>(
                listener: (context, state) {
                  if (state is FetchCarModelSuccessState) {
                    listOfCarModel = state.listOfCarModel;
                  }
                },
                builder: (context, state) {
                  switch (state) {
                    case FetchCarModelLoadingState():
                      {
                        return AppLoadingIndicator();
                      }
                    case FetchCarModelSuccessState():
                      {
                        return _buildGrid(state.listOfCarModel);
                      }
                    case SearchCarModelEmtyDataState():
                      {
                        return AppEmptyText(
                          text: state.emptyMessage,
                          neddMorhieght: true,
                        );
                      }
                    case SearchCarModelHasDataState():
                      {
                        return _buildGrid(state.searchResult);
                      }
                    case FetchCarModelErrorState():
                      {
                        return AppEmptyText(
                          text: state.errorMessage,
                          neddMorhieght: true,
                        );
                      }
                    default:
                      {
                        return AppEmptyText(
                          text: 'Please wait...',
                          neddMorhieght: true,
                        );
                      }
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGrid(List<CarModeModel> list) {
    return list.isEmpty
        ? AppEmptyText(text: 'No Data Found !', neddMorhieght: true)
        : AppMargin(
          child: GridView.builder(
            padding: EdgeInsets.symmetric(
              vertical: AppDimensions.paddingSize10,
            ),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: list.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: .89,
              crossAxisCount: 3,
              mainAxisSpacing: 15,
              crossAxisSpacing: 12,
            ),
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  setState(() {
                    selectedCarModelIndex = index;
                  });

                  Navigator.of(context).push(
                    AppRoutes.createRoute(
                      EvSelectFuealTypeScreen(
                        evaluationDataEntryModel: EvaluationDataEntryModel(
                          inspectionId:
                              widget.evaluationDataEntryModel.inspectionId,
                          makeId: widget.evaluationDataEntryModel.makeId,
                          makeYear: widget.evaluationDataEntryModel.makeYear,
                          carMake: widget.evaluationDataEntryModel.carMake,
                          carModel: list[index].modelName,
                          modelId: list[index].modelId,
                        ),
                      ),
                    ),
                  );
                },
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: w(context),
                      height: w(context) * .24,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.paddingSize5,
                        ),
                        border: Border.all(
                          width: 1.5,
                          color:
                              selectedCarModelIndex == index
                                  ? AppColors.kAppSecondaryColor
                                  : AppColors.kBlack,
                        ),
                      ),
                      child: CachedNetworkImage(
                        errorListener: (value) {},
                        errorWidget:
                            (context, path, error) =>
                                const AppImageNotFoundText(),
                        imageUrl: list[index].image,
                      ),
                    ),
                    AppSpacer(heightPortion: .01),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppDimensions.paddingSize5,
                      ),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color:
                            selectedCarModelIndex == index
                                ? AppColors.kAppSecondaryColor
                                : AppColors.DEFAULT_BLUE_DARK,
                        gradient:
                            selectedCarModelIndex == index
                                ? LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    AppColors.kAppSecondaryColor,
                                    AppColors.DEFAULT_BLUE_DARK,
                                  ],
                                )
                                : null,
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusSize5,
                        ),
                      ),
                      child: Text(
                        list[index].modelName,
                        style: AppStyle.style(
                          color: AppColors.kWhite,
                          context: context,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
              // return AppMargin(
              //   child: EvAppCustomeSelctionButton(
              //       isButtonBorderView: true,
              //       currentIndex: index,
              //       onTap: () {
              //         setState(() {
              //           selectedCarModelIndex = index;
              //         });

              //         Navigator.of(context)
              //             .push(AppRoutes.createRoute(EvSelectFuealTypeScreen(
              //           evaluationDataEntryModel: EvaluationDataEntryModel(
              //               inspectionId:
              //                   widget.evaluationDataEntryModel.inspectionId,
              //               makeId: widget.evaluationDataEntryModel.makeId,
              //               makeYear: widget.evaluationDataEntryModel.makeYear,
              //               carMake: widget.evaluationDataEntryModel.carMake,
              //               carModel: list[index].modelName,
              //               modelId: list[index].modelId),
              //         )));
              //       },
              //       // data: list,
              //       selectedButtonIndex: selectedCarModelIndex,
              //       child: Column(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: [
              //           SizedBox(
              //             width: w(context),
              //             height: h(context) * .1,
              //             child: Center(
              //               child: CachedNetworkImage(
              //                   errorListener: (value) {},
              //                   errorWidget: (context, path, error) =>
              //                       const AppImageNotFoundText(),
              //                   imageUrl: list[index].image),
              //             ),
              //           ),
              //           const Expanded(child: SizedBox()),
              //           Container(
              //             margin: const EdgeInsets.symmetric(
              //                 horizontal: AppDimensions.paddingSize5),
              //             padding: const EdgeInsets.symmetric(
              //                 vertical: AppDimensions.paddingSize5),
              //             alignment: Alignment.center,
              //             decoration: BoxDecoration(
              //                 color: AppColors.kAppPrimaryColor,
              //                 borderRadius: BorderRadius.circular(
              //                     AppDimensions.radiusSize5)),
              //             child: Text(
              //               list[index].modelName,
              //               style: AppStyle.opensansStyle(
              //                   color: AppColors.kWhite,
              //                   context: context,
              //                   fontWeight: FontWeight.bold),
              //             ),
              //           ),
              //         ],
              //       )),
              // );
            },
          ),
        );
  }
}
