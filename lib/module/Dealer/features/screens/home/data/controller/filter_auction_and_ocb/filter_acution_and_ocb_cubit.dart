import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/model/v_car_model.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/repo/fetch_city_repo.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/repo/v_dashboard_repo.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/repo/v_fetch_ocb_list_repo.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/model/city_model.dart';

part 'filter_acution_and_ocb_state.dart';

class FilterAcutionAndOcbCubit extends Cubit<FilterAcutionAndOcbState> {
  FilterAcutionAndOcbCubit()
    : super(FilterAcutionAndOcbInitial(filterData: {}));

  // FILTER ------------

  List<VCarModel> _listOfAuctions = [];
  List<VCarModel> _listOfOCB = [];
  List<CityModel> _city = [];

  void initWithFilterData(BuildContext context) async {
    emit(FilterAcutionAndOcbIntializingState());
    _listOfAuctions = [];
    _listOfOCB = [];
    _city = [];
    final autionResponse = await VAuctionData.getAuctionData(context);
    final ocbResponse = await VFetchOcbListRepo.getOcbList(context);
    final cityResponse = await VFetchCitiesRepo.getCityList(context);

    if (autionResponse.isNotEmpty && autionResponse['error'] == false) {
      final data = autionResponse['data'] as List;
      _listOfAuctions = data.map((e) => VCarModel.fromJson(e)).toList();
    }
    if (ocbResponse.isNotEmpty && ocbResponse['error'] == false) {
      final data = ocbResponse['data'] as List;
      _listOfOCB = data.map((e) => VCarModel.fromJson(e)).toList();
    }
    if (cityResponse.isNotEmpty && cityResponse['error'] == false) {
      log(cityResponse.toString());
      final data = cityResponse['data'] as List;
      _city = data.map((e) => CityModel.fromJson(e)).toList();
    } else {
      log(cityResponse.toString());
    }

    log(
      "Cars for filtering : OCB ${_listOfOCB.length}. Auction ${_listOfAuctions.length}. City ${_city.length}",
    );
    emit(
      FilterAcutionAndOcbInitial(
        filterData: {
          "Make & Model": [],
          "City": _city.map((e) => e.cityName).toList(),
          "Make Year": [
            "2020-2023",
            "2015-2019",
            "2010-2014",
            "2005-2009",
            "Before 2005",
          ],
          "Km Driven": [
            "0-10000",
            "10000-25000",
            "25000-50000",
            "50000-75000",
            "75000+",
          ],
          "Fuel Type": ["Petrol", "Diesel", "CNG", "Electric", "Hybrid"],
          "Owner": ["1st Owner", "2nd Owner", "3rd Owner", "4th+ Owner"],
          "Transmission": ["Manual", "Automatic", "CVT"],
          "Price": [
            "Under 1 Lakh",
            "1-3 Lakh",
            "3-5 Lakh",
            "5-10 Lakh",
            "10+ Lakh",
          ],
        },
      ),
    );
  }

  void onChangeFilter(String filter) {
    final currentState = state;
    if (currentState is FilterAcutionAndOcbInitial) {
      emit(currentState.copyWith(currentFilterCategory: filter));
    }
  }

  // SORT ------------
}
