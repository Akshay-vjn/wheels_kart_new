import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wheels_kart/module/Dealer/core/components/v_loading.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_colors.dart';
import 'package:wheels_kart/module/Dealer/core/v_style.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/controller/filter_auction_and_ocb/filter_acution_and_ocb_cubit.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/model/v_make_and_model_filter_model.dart';

class FilterBottomSheet extends StatefulWidget {
  final Function(Map<FilterCategory, List<String>>)? onFiltersApplied;
  final Map<FilterCategory, List<String>> initialFilters;

  const FilterBottomSheet({
    super.key,
    this.onFiltersApplied,
    this.initialFilters = const {},
  });

  @override
  _FilterBottomSheetState createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  Map<FilterCategory, List<String>> selectedFilters = {};

  @override
  void initState() {
    super.initState();
    // Initialize selectedFilters from widget.initialFilters
    widget.initialFilters.forEach((key, value) {
      // if (value is List<String>) {
      selectedFilters[key] = List<String>.from(value);
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.arrow_back_ios, color: VColors.SECONDARY),
                ),
                SizedBox(width: 15),
                Text(
                  "All Filters",
                  style: VStyle.poppins(
                    context: context,
                    size: 18,
                    fontWeight: FontWeight.w600,
                    color: VColors.SECONDARY,
                  ),
                ),
              ],
            ),
          ),

          // Content Area
          Expanded(
            child: BlocBuilder<
              FilterAcutionAndOcbCubit,
              FilterAcutionAndOcbState
            >(
              builder: (context, state) {
                switch (state) {
                  case FilterAcutionAndOcbInitial():
                    {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left Sidebar - Filter Categories
                          Container(
                            width: MediaQuery.of(context).size.width * 0.35,
                            color: Colors.grey.shade50,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: ListView(
                                    children:
                                        state.filterData!.keys.map((category) {
                                          bool isSelected =
                                              state.currentFilterCategory ==
                                              category;
                                          return Container(
                                            decoration: BoxDecoration(
                                              color:
                                                  isSelected
                                                      ? Colors.white
                                                      : Colors.transparent,
                                              border: Border(
                                                right: BorderSide(
                                                  color:
                                                      isSelected
                                                          ? VColors.SECONDARY
                                                          : Colors.transparent,
                                                  width: 3,
                                                ),
                                              ),
                                            ),
                                            child: ListTile(
                                              dense: true,
                                              title: Text(
                                                FilterAcutionAndOcbCubit.tryToString(
                                                  category,
                                                ),
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight:
                                                      isSelected
                                                          ? FontWeight.w600
                                                          : FontWeight.w500,
                                                  color: VColors.SECONDARY,
                                                ),
                                              ),
                                              onTap: () {
                                                context
                                                    .read<
                                                      FilterAcutionAndOcbCubit
                                                    >()
                                                    .onChangeFilter(category);
                                              },
                                            ),
                                          );
                                        }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Right Content Area
                          Expanded(
                            child: Container(
                              color: Colors.white,
                              child:
                                  state.currentFilterCategory ==
                                          FilterCategory.MakeAndMode
                                      ? _buildMakeModelContent()
                                      : _buildGenericFilterContent(),
                            ),
                          ),
                        ],
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

          // Bottom Action Bar
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              children: [
                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     // Text(
                //     //   "$carsFound",
                //     //   style: TextStyle(
                //     //     fontSize: 18,
                //     //     fontWeight: FontWeight.bold,
                //     //     color: Colors.black87,
                //     //   ),
                //     // ),
                //     Text(
                //       "Cars Found",
                //       style: TextStyle(
                //         fontSize: 12,
                //         color: Colors.grey.shade600,
                //       ),
                //     ),
                //   ],
                // ),
                // SizedBox(width: 20),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              selectedFilters.clear();
                            });

                            context
                                .read<FilterAcutionAndOcbCubit>()
                                .clearFilter();
                          },
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            side: BorderSide(color: Colors.grey.shade400),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            "CLEAR ALL",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () {
                            widget.onFiltersApplied?.call(selectedFilters);
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade600,
                            padding: EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            "APPLY",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMakeModelContent() {
    return BlocBuilder<FilterAcutionAndOcbCubit, FilterAcutionAndOcbState>(
      builder: (context, state) {
        switch (state) {
          case FilterAcutionAndOcbInitial():
            {
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Popular Makes Section
                    SizedBox(height: 10),
                    Text(
                      "POPULAR MAKES",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 10),

                    ...state.filterData!.entries.first.value.map((e) {
                      final make = MakeAndModelForFilterModel.fromJson(
                        e.toJson(),
                      );
                      return _buildMakExpansionTile(
                        make.makeName,
                        state.currentFilterCategory!,
                        make.models.map((e) => e.modelName).toList(),
                      );
                    }),

                    // Other Makes Section
                  ],
                ),
              );
            }
          default:
            return SizedBox();
        }
      },
    );
  }

  Widget _buildGenericFilterContent() {
    return BlocBuilder<FilterAcutionAndOcbCubit, FilterAcutionAndOcbState>(
      builder: (context, state) {
        switch (state) {
          case FilterAcutionAndOcbInitial():
            {
              List<dynamic> options =
                  state.filterData![state.currentFilterCategory] ?? [];

              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                itemCount: options.length,
                itemBuilder: (context, index) {
                  return _buildCheckboxItem(
                    options[index],
                    state.currentFilterCategory!,
                  );
                },
              );
            }
          default:
            {
              return SizedBox();
            }
        }
      },
    );
  }

  Widget _buildCheckboxItem(String option, FilterCategory category) {
    String convertedOption = option;
    if (FilterCategory.Price == category) {
      convertedOption = _mapPriceLabelToFilter(option);
    }
    if (FilterCategory.KmDriven == category) {
      convertedOption = _mapKmLabelToFilter(option);
    }
    if (FilterCategory.MakeYear == category) {
      convertedOption = _mapMakeYearLabelToFilter(option);
    }
    bool isSelected =
        selectedFilters[category]?.contains(convertedOption) ?? false;

    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _onChooseOption(convertedOption, category, isSelected),
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected ? Colors.blue : Colors.grey.shade400,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(3),
                color: isSelected ? Colors.blue : Colors.transparent,
              ),
              child:
                  isSelected
                      ? Icon(Icons.check, size: 14, color: Colors.white)
                      : null,
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Text(
              option,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.grey.shade800,
              ),
            ),
          ),
          // Icon(
          //   Icons.keyboard_arrow_down,
          //   color: Colors.grey.shade600,
          //   size: 20,
          // ),
        ],
      ),
    );
  }

  Widget _buildMakExpansionTile(
    String option,
    FilterCategory selctedCategory,
    List<String> options,
  ) {
    bool isSelected =
        selectedFilters[selctedCategory]?.contains(option) ?? false;

    return ExpansionTile(
      shape: BoxBorder.all(width: 0),
      childrenPadding: EdgeInsets.symmetric(horizontal: 10),
      backgroundColor: VColors.GREYHARD.withAlpha(100),
      tilePadding: EdgeInsets.symmetric(horizontal: 10),
      leading: GestureDetector(
        onTap: () => _onChooseOption(option, selctedCategory, isSelected),
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? Colors.blue : Colors.grey.shade400,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(3),
            color: isSelected ? Colors.blue : Colors.transparent,
          ),
          child:
              isSelected
                  ? Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
        ),
      ),
      title: Text(
        option,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Colors.grey.shade800,
        ),
      ),
      enabled: options.isNotEmpty,
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      children:
          options.isEmpty
              ? []
              : [
                Text(
                  "POPULAR MODELS",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 10),
                ...options
                    .map(
                      (model) => Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: _buildCheckboxItem(model, selctedCategory),
                      ),
                    )
                    .toList(),
              ],
    );
  }

  void _onChooseOption(
    String option,
    FilterCategory selctedCategory,
    bool isSelected,
  ) {
    setState(() {
      if (!selectedFilters.containsKey(selctedCategory)) {
        selectedFilters[selctedCategory] = [];
      }

      if (isSelected) {
        selectedFilters[selctedCategory]!.remove(option);
        if (selectedFilters[selctedCategory]!.isEmpty) {
          selectedFilters.remove(selctedCategory);
        }
      } else {
        selectedFilters[selctedCategory]!.add(option);
      }
    });
  }

  // Helper

  int? _extractFirstNumber(String s) {
    final match = RegExp(r'(\d{2,})').firstMatch(s);
    if (match == null) return null;
    return int.tryParse(match.group(1)!);
  }

  String _mapPriceLabelToFilter(String label) {
    final s = label.trim().toLowerCase();
    int lakh(int n) => n * 100000;

    if (s.contains('under')) {
      final d = _extractFirstNumber(s);
      if (d != null) return '<=${lakh(d)}';
    }

    if (s.contains('+')) {
      final d = _extractFirstNumber(s);
      if (d != null) return '>=${lakh(d)}';
    }

    if (s.contains('-')) {
      final m = RegExp(r'(\d+)\s*-\s*(\d+)').firstMatch(s);
      if (m != null) {
        final a = int.parse(m.group(1)!);
        final b = int.parse(m.group(2)!);
        return '${lakh(a)}-${lakh(b)}';
      }
    }

    final d = _extractFirstNumber(s);
    if (d != null) return '${lakh(d)}-${lakh(d)}';
    return label;
  }

  String _mapKmLabelToFilter(String label) {
    final s = label.trim().toLowerCase();
    if (s.contains('+')) {
      final n = _extractFirstNumber(s);
      if (n != null) return '>=$n';
    }
    if (s.contains('-')) return s; // already a range like "0-10000"
    final n = _extractFirstNumber(s);
    if (n != null) return '$n';
    return label;
  }

  String _mapMakeYearLabelToFilter(String label) {
    final s = label.trim().toLowerCase();
    if (s.startsWith('before')) {
      final n = _extractFirstNumber(s);
      if (n != null) return '<=$n';
    }
    if (s.contains('-')) return s; // "2015-2019"
    final n = _extractFirstNumber(s);
    if (n != null) return '$n';
    return label;
  }
}
