import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_colors.dart';
import 'package:wheels_kart/module/Dealer/core/v_style.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/controller/filter_auction_and_ocb/filter_acution_and_ocb_cubit.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/screens/widgets/filter/build_filter_sheet.dart';

class FilterAndSortWidget extends StatefulWidget {
  final Function(Map<FilterCategory, List<dynamic>>, String)?
  onFiltersAndSortApplied;

  const FilterAndSortWidget({Key? key, this.onFiltersAndSortApplied})
    : super(key: key);

  @override
  _FilterAndSortWidgetState createState() => _FilterAndSortWidgetState();
}

class _FilterAndSortWidgetState extends State<FilterAndSortWidget> {
  // Map<FilterCategory, List<String>> appliedFilters = {};

  double w(BuildContext context) => MediaQuery.of(context).size.width;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      scrollDirection: Axis.horizontal,
      child: BlocBuilder<FilterAcutionAndOcbCubit, FilterAcutionAndOcbState>(
        builder: (context, state) {
          return Row(
            children: [
              _buildActionButton(
                appliedFIlterCount:
                    context
                        .read<FilterAcutionAndOcbCubit>()
                        .getAppliedFilterCount(),
                "Filters",
                Icons.filter_alt_outlined,
                () {
                  _showFilterBottomSheet(
                    state.selectedFilters ?? {},
                    state.selectedSort ?? "",
                  );
                },
              ),
              _buildActionButton("Sort", Icons.sort, () {
                _showSortBottomSheet(
                  state.selectedFilters ?? {},
                  state.selectedSort ?? "",
                );
              }),
              // _buildActionButton("Spinny Prime", Icons.star_outline, () {}),
              // _buildActionButton(
              //   "No Transit Cost",
              //   Icons.local_shipping_outlined,
              //   () {},
              // ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildActionButton(
    String title,
    IconData icon,
    void Function()? onTap, {
    int? appliedFIlterCount,
  }) => InkWell(
    onTap: onTap,
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          margin: EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: VColors.WHITE.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: VColors.WHITE),
              SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: VColors.WHITE,
                ),
              ),
              SizedBox(width: 6),
            ],
          ),
        ),
        if (appliedFIlterCount != null)
          Positioned(
            top: -7,
            right: 2,
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: VColors.ACCENT,
                shape: BoxShape.circle,
              ),
              child: Text(
                appliedFIlterCount.toString(),
                style: VStyle.poppins(color: VColors.WHITE, context: context),
              ),
            ),
          ),
      ],
    ),
  );

  void _showSortBottomSheet(
    Map<FilterCategory, List<dynamic>> appliedFilters,
    String selctedSort,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SafeArea(
          top: false,
          bottom: Platform.isAndroid,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Sort by",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(Icons.close, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),

                // Sort Options
                Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.6,
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: FilterAcutionAndOcbCubit.sortOptions.length,
                    itemBuilder: (context, index) {
                      String option =
                          FilterAcutionAndOcbCubit.sortOptions[index];
                      bool isSelected = selctedSort == option;

                      return InkWell(
                        onTap: () {
                          context.read<FilterAcutionAndOcbCubit>().onChangeSort(
                            option,
                          );
                          widget.onFiltersAndSortApplied?.call(
                            appliedFilters,
                            option,
                          );
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 15,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color:
                                        isSelected
                                            ? Colors.blue
                                            : Colors.grey.shade400,
                                    width: 2,
                                  ),
                                  color:
                                      isSelected
                                          ? Colors.blue
                                          : Colors.transparent,
                                ),
                                child:
                                    isSelected
                                        ? Center(
                                          child: Container(
                                            width: 8,
                                            height: 8,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white,
                                            ),
                                          ),
                                        )
                                        : null,
                              ),
                              SizedBox(width: 15),
                              Text(
                                option,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight:
                                      isSelected
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                  color:
                                      isSelected
                                          ? Colors.black
                                          : Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showFilterBottomSheet(
    Map<FilterCategory, List<dynamic>> appliedFilters,
    String selctedSort,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return FilterBottomSheet(
          onFiltersApplied: (filters) {
            // setState(() {
            //   appliedFilters = filters;
            // });
            widget.onFiltersAndSortApplied?.call(filters, selctedSort);
          },
          initialFilters: appliedFilters,
        );
      },
    );
  }
}
