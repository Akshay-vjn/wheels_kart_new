import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wheels_kart/module/Dealer/core/components/v_loading.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_colors.dart';
import 'package:wheels_kart/module/Dealer/core/v_style.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/controller/filter_auction_and_ocb/filter_acution_and_ocb_cubit.dart';

class FilterBottomSheet extends StatefulWidget {
  final Function(Map<String, dynamic>)? onFiltersApplied;
  final Map<String, dynamic> initialFilters;

  const FilterBottomSheet({
    super.key,
    this.onFiltersApplied,
    this.initialFilters = const {},
  });

  @override
  _FilterBottomSheetState createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  Map<String, List<String>> selectedFilters = {};
  int carsFound = 319;
  // String selectedCategory = "Make & Model";

  // Map<String, List<String>> filterData = {
  //   "Make & Model": [
  //     "Maruti Suzuki",
  //     "Hyundai",
  //     "Tata",
  //     "Honda",
  //     "Mahindra",
  //     "Renault",
  //     "Toyota",
  //     "Ford",
  //   ],
  //   "Body Type": ["Hatchback", "Sedan", "SUV", "MUV", "Coupe", "Convertible"],
  //   "RTO cities": [
  //     "Delhi",
  //     "Mumbai",
  //     "Bangalore",
  //     "Chennai",
  //     "Pune",
  //     "Kolkata",
  //   ],
  //   "Make Year": [
  //     "2020-2023",
  //     "2015-2019",
  //     "2010-2014",
  //     "2005-2009",
  //     "Before 2005",
  //   ],
  //   "Km Driven": [
  //     "0-10000",
  //     "10000-25000",
  //     "25000-50000",
  //     "50000-75000",
  //     "75000+",
  //   ],
  //   "Fuel Type": ["Petrol", "Diesel", "CNG", "Electric", "Hybrid"],
  //   "Owner": ["1st Owner", "2nd Owner", "3rd Owner", "4th+ Owner"],
  //   "Transmission": ["Manual", "Automatic", "CVT"],
  //   "Price": ["Under 1 Lakh", "1-3 Lakh", "3-5 Lakh", "5-10 Lakh", "10+ Lakh"],
  // };

  List<String> get otherMakes => ["Renault", "Toyota", "Ford"];

  @override
  void initState() {
    super.initState();
    // Initialize selectedFilters from widget.initialFilters
    widget.initialFilters.forEach((key, value) {
      if (value is List<String>) {
        selectedFilters[key] = List<String>.from(value);
      }
    });

    context.read<FilterAcutionAndOcbCubit>().initWithFilterData(context);
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
                                                category,
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
                                  state.currentFilterCategory == "Make & Model"
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "$carsFound",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      "Cars Found",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 20),
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
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Popular Makes Section
          Text(
            "POPULAR MAKES",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
              letterSpacing: 0.5,
            ),
          ),
          // SizedBox(height: 10),
          // ...popularMakes.map(
          //   (make) => _buildCheckboxItem(make, selectedCategory),
          // ),

          // Other Makes Section
        ],
      ),
    );
  }

  Widget _buildGenericFilterContent() {
    return BlocBuilder<FilterAcutionAndOcbCubit, FilterAcutionAndOcbState>(
      builder: (context, state) {
        switch (state) {
          case FilterAcutionAndOcbInitial():
            {
              List<String> options =
                  state.filterData![state.currentFilterCategory] ?? [];

              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                itemCount: options.length,
                itemBuilder: (context, index) {
                  return _buildCheckboxItem(
                    options[index],
                    state.currentFilterCategory ?? "",
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

  Widget _buildCheckboxItem(String option, String category) {
    bool isSelected = selectedFilters[category]?.contains(option) ?? false;

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                if (!selectedFilters.containsKey(category)) {
                  selectedFilters[category] = [];
                }

                if (isSelected) {
                  selectedFilters[category]!.remove(option);
                  if (selectedFilters[category]!.isEmpty) {
                    selectedFilters.remove(category);
                  }
                } else {
                  selectedFilters[category]!.add(option);
                }
              });
            },
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
          Icon(
            Icons.keyboard_arrow_down,
            color: Colors.grey.shade600,
            size: 20,
          ),
        ],
      ),
    );
  }
}
