import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_colors.dart';
import 'package:wheels_kart/common/dimensions.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_style.dart';
import 'package:wheels_kart/common/utils/responsive_helper.dart';
import 'package:wheels_kart/common/utils/routes.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/bloc/search/search%20car%20make/search_car_make_bloc.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/model/car_make_model.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/model/evaluation_data_model.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/model/inspection_data_model.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/screens/inspect%20car/fill%20basic%20details/2_select_and_search_manufacturing_year_selection.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/widgets/ev_app_custom_widgets.dart';
import 'package:wheels_kart/common/components/app_empty_text.dart';
import 'package:wheels_kart/common/components/app_margin.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/widgets/ev_app_search_field.dart';

class EvSelectAndSearchCarMakes extends StatefulWidget {
  List<CarMakeModel> listofCarMake;
  String inspectuionId;
  final InspectionModel? prefillInspection;
  EvSelectAndSearchCarMakes({
    super.key,
    required this.prefillInspection,
    required this.listofCarMake,
    required this.inspectuionId,
  });

  @override
  State<EvSelectAndSearchCarMakes> createState() =>
      _EvSelectAndSearchCarMakesState();
}

class _EvSelectAndSearchCarMakesState extends State<EvSelectAndSearchCarMakes> {
  @override
  void initState() {
    super.initState();
    context.read<EvSearchCarMakeBloc>().add(
      OnSearchCarMakeEvent(
        query: '',
        initialListOfCarMake: widget.listofCarMake,
      ),
    );
    if (widget.prefillInspection != null) {
      context.read<EvSearchCarMakeBloc>().add(
        OnSelectCarMake(
          selectedMakeId:
              widget.prefillInspection!.makeId.isNotEmpty
                  ? widget.prefillInspection!.makeId
                  : null,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        shrinkWrap: true,
        slivers: [
          SliverAppBar(
            surfaceTintColor: Colors.transparent,
            shadowColor: Colors.transparent,
            backgroundColor: EvAppColors.DEFAULT_BLUE_DARK,
            foregroundColor: Colors.transparent,
            leading: evCustomBackButton(context, color: EvAppColors.white),
            floating: true,
            pinned: false,
            snap: true,
            title: Text(
              'Select car brand',
              style: EvAppStyle.style(
                context: context,
                fontWeight: FontWeight.w500,
                color: EvAppColors.white,
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
                  hintText: 'Search car brand',
                  onChanged: (value) {
                    context.read<EvSearchCarMakeBloc>().add(
                      OnSearchCarMakeEvent(
                        query: value,
                        initialListOfCarMake: widget.listofCarMake,
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
          SliverList(
            delegate: SliverChildBuilderDelegate(
              childCount: 1,
              (context, index) => AppMargin(
                child: BlocConsumer<EvSearchCarMakeBloc, EvSearchCarMakeState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    switch (state) {
                      // case SearchCarMakeInitialState():
                      //   {
                      //     return _buildGrid(widget.listofCarMake);
                      //   }
                      case SearchListHasDataState():
                        {
                          return _buildGrid(state.searchResult, state);
                        }

                      case SearchListIsEmptyState():
                        {
                          return AppEmptyText(
                            text: state.emptyMessage,
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
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid(List<CarMakeModel> data, SearchListHasDataState state) {
    return data.isEmpty
        ? AppEmptyText(text: 'Cars Not Found !', neddMorhieght: true)
        : GridView.builder(
          padding: const EdgeInsets.only(
            bottom: AppDimensions.paddingSize5,
            top: 10,
          ),
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: data.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          itemBuilder: (context, index) {
            return InkWell(
              overlayColor: const WidgetStatePropertyAll(
                EvAppColors.kAppSecondaryColor,
              ),
              onTap: () {
                context.read<EvSearchCarMakeBloc>().add(
                  OnSelectCarMake(selectedMakeId: data[index].makeId),
                );
                Navigator.of(context).push(
                  AppRoutes.createRoute(
                    EvSelectAndSeachManufacturingYear(
                      prefillInspection: widget.prefillInspection,
                      evaluationDataEntryModel: EvaluationDataEntryModel(
                        inspectionId: widget.inspectuionId,
                        carMake: data[index].makeName,
                        makeId: data[index].makeId,
                      ),
                    ),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 5,
                      spreadRadius: 1,
                      color: Colors.black.withAlpha(50),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(12),
                  color: EvAppColors.white,
                  border:
                      data[index].makeId == state.selectedCarMakeId
                          ? Border.all(color: EvAppColors.DEFAULT_BLUE_DARK)
                          : null,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: w(context),
                        height: h(context) * .05,
                        child: Center(
                          child: CachedNetworkImage(
                            errorListener: (value) {
                              // log(value.toString());
                            },
                            errorWidget:
                                (context, path, error) =>
                                    const AppImageNotFoundText(),
                            imageUrl: data[index].logo,
                          ),
                        ),
                      ),
                      Text(
                        data[index].makeName,
                        style: EvAppStyle.style(
                          context: context,
                          fontWeight: FontWeight.bold,
                          letterSpacing: .5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
  }
}
