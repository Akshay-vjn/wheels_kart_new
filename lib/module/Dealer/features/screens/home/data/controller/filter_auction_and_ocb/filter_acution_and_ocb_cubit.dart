import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/model/v_car_model.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/model/v_make_and_model_filter_model.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/repo/fetch_city_repo.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/repo/fetch_make_and_model_for_filter_repo.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/repo/v_dashboard_repo.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/repo/v_fetch_ocb_list_repo.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/model/city_model.dart';

part 'filter_acution_and_ocb_state.dart';

enum FilterCategory {
  MakeAndMode,
  City,
  MakeYear,
  KmDriven,
  FuelType,
  // Owner,
  // Transmission,
  Price,
}

class FilterAcutionAndOcbCubit extends Cubit<FilterAcutionAndOcbState> {
  FilterAcutionAndOcbCubit()
    : super(FilterAcutionAndOcbInitial(filterData: {}));

  // FILTER ------------

  List<VCarModel> _listOfAuctions = [];
  List<VCarModel> _listOfOCB = [];
  List<CityModel> _city = [];
  List<MakeAndModelForFilterModel> _makeAndModelList = [];

  final List<String> _price = [
    "Under 1 Lakh",
    "1-3 Lakh",
    "3-5 Lakh",
    "5-10 Lakh",
    "10+ Lakh",
  ];
  // final List<String> _owner = [
  //   "1st Owner",
  //   "2nd Owner",
  //   "3rd Owner",
  //   "4th+ Owner",
  // ];

  final List<String> _fuelType = [
    "Petrol",
    "Diesel",
    "CNG",
    "Electric",
    "Hybrid",
  ];

  final List<String> _kmDriven = [
    "0-10000",
    "10000-25000",
    "25000-50000",
    "50000-75000",
    "75000+",
  ];

  final List<String> _makeYear = [
    "2020-${DateTime.now().year}",
    "2015-2019",
    "2010-2014",
    "2005-2009",
    "Before 2005",
  ];
  // final List<String> _transmission = ["Manual", "Automatic", "CVT"];
  void initWithFilterData(BuildContext context) async {
    emit(FilterAcutionAndOcbIntializingState());
    _listOfAuctions = [];
    _listOfOCB = [];
    _city = [];
    final autionResponse = await VAuctionData.getAuctionData(context);
    final ocbResponse = await VFetchOcbListRepo.getOcbList(context);
    final cityResponse = await VFetchCitiesRepo.getCityList(context);
    final makeAndModelResponse =
        await FetchMakeAndModelForFilterRepo.getFetchMakeAndModel(context);

    if (autionResponse.isNotEmpty && autionResponse['error'] == false) {
      final data = autionResponse['data'] as List;
      _listOfAuctions = data.map((e) => VCarModel.fromJson(e)).toList();
    }
    if (ocbResponse.isNotEmpty && ocbResponse['error'] == false) {
      final data = ocbResponse['data'] as List;
      _listOfOCB = data.map((e) => VCarModel.fromJson(e)).toList();
    }
    if (cityResponse.isNotEmpty && cityResponse['error'] == false) {
      final data = cityResponse['data'] as List;
      _city = data.map((e) => CityModel.fromJson(e)).toList();
    }
    if (makeAndModelResponse.isNotEmpty &&
        makeAndModelResponse['error'] == false) {
      final data = makeAndModelResponse['data'] as List;
      _makeAndModelList =
          data.map((e) => MakeAndModelForFilterModel.fromJson(e)).toList();
    }

    log(
      "Cars for filtering : OCB ${_listOfOCB.length}. Auction ${_listOfAuctions.length}. City ${_city.length}. Make and Model ${_makeAndModelList.length}",
    );
    emit(
      FilterAcutionAndOcbInitial(
        currentFilterCategory: FilterCategory.MakeAndMode,
        selectedSort: sortOptions[0],
        filterData: {
          FilterCategory.MakeAndMode: _makeAndModelList,
          FilterCategory.City: _city.map((e) => e.cityName).toList(),
          FilterCategory.MakeYear: _makeYear,
          FilterCategory.KmDriven: _kmDriven,
          FilterCategory.FuelType: _fuelType,
          // FilterCategory.Owner: _owner,
          // FilterCategory.Transmission: _transmission,
          FilterCategory.Price: _price,
        },
      ),
    );
  }

  void onChangeFilter(FilterCategory filter) {
    final currentState = state;
    if (currentState is FilterAcutionAndOcbInitial) {
      emit(currentState.copyWith(currentFilterCategory: filter));
    }
  }

  int? getAppliedFilterCount() {
    if (state.selectedFilters == null || state.selectedFilters!.isEmpty) {
      return null;
    }
    int total = 0;
    state.selectedFilters!.forEach((key, values) {
      total++;
    });
    return total;
  }

  void clearFilter() {
    final currentState = state;
    if (currentState is FilterAcutionAndOcbInitial) {
      emit(
        currentState.copyWith(
          selectedFilters: {},
          selectedSort: sortOptions[0],
          currentFilterCategory: FilterCategory.MakeAndMode,
        ),
      );
    }
  }

  static String tryToString(FilterCategory category) {
    switch (category) {
      case FilterCategory.MakeAndMode:
        return "Make & Model";

      case FilterCategory.City:
        return "City";
      case FilterCategory.MakeYear:
        return "Make Year";
      case FilterCategory.KmDriven:
        return "Km Driven";
      case FilterCategory.FuelType:
        return "Fuel Type";
      // case FilterCategory.Owner:
      //   return "Owner";
      // case FilterCategory.Transmission:
      //   return "Transmission";
      case FilterCategory.Price:
        return "Price";
    }
  }

  // SORT ------------

  static List<String> sortOptions = [
    "Ending Soonest (Default)",
    "Price - Low to High",
    "Price - High to Low",
    "Year - Old to New",
    "Year - New to Old",
  ];

  void onChangeSort(String sort) {
    final currentState = state;
    if (currentState is FilterAcutionAndOcbInitial) {
      emit(currentState.copyWith(selectedSort: sort));
    }
  }

  //APPLY FILTER and SORT

  void onApplyFilterAndSort(
    Map<FilterCategory, List<dynamic>> selectedFilters,
    String selectedSort,
  ) {
    final currentState = state;
    if (currentState is FilterAcutionAndOcbInitial) {
      emit(currentState.copyWith(selectedFilters: selectedFilters));
    }
  }

  // SEARACH
}
