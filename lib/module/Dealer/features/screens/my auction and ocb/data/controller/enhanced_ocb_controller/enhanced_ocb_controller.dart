import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/model/v_car_detail_model.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/repo/v_fetch_owned_car_detail_repo.dart';
import 'package:wheels_kart/module/Dealer/features/screens/my%20auction%20and%20ocb/data/models/my_ocb_model.dart';
import 'package:wheels_kart/module/Dealer/features/screens/my%20auction%20and%20ocb/data/repo/v_get_my_ocbs_repo.dart';
import 'package:wheels_kart/module/Dealer/features/screens/my%20auction%20and%20ocb/data/controller/enhanced_ocb_controller/ocb_details_cache.dart';

part 'enhanced_ocb_controller_event.dart';
part 'enhanced_ocb_controller_state.dart';

class EnhancedOcbController extends Bloc<EnhancedOcbEvent, EnhancedOcbState> {
  EnhancedOcbController() : super(EnhancedOcbInitialState()) {
    on<OnFetchOcbWithOwnedDetails>(_onFetchOcbWithOwnedDetails);
    on<OnRefreshOcbWithOwnedDetails>(_onRefreshOcbWithOwnedDetails);
  }

  Future<void> _onFetchOcbWithOwnedDetails(
    OnFetchOcbWithOwnedDetails event,
    Emitter<EnhancedOcbState> emit,
  ) async {
    emit(EnhancedOcbLoadingState());
    
    try {
      // Get OCB list
      final ocbResponse = await VGetMyOcbsRepo.ongetMyOCB(event.context);
      
      if (ocbResponse['error'] == true) {
        emit(EnhancedOcbErrorState(error: ocbResponse['message'] ?? 'Failed to fetch OCB data'));
        return;
      }
      
      final ocbList = (ocbResponse['data'] as List)
          .map((e) => MyOcbModel.fromJson(e))
          .toList();
      
      log('Enhanced OCB: Fetched ${ocbList.length} OCB items');
      
      // Clear expired cache entries
      OcbDetailsCache.clearExpiredCache();
      
      // Get inspection IDs for preloading
      final inspectionIds = ocbList.map((ocb) => ocb.inspectionId).toList();
      
      // Preload owned details using cache
      final ownedDetailsList = await OcbDetailsCache.preloadOwnedDetails(
        event.context, 
        inspectionIds,
      );
      
      emit(EnhancedOcbSuccessState(
        ocbList: ocbList,
        ownedDetailsList: ownedDetailsList,
      ));
      
      log('Enhanced OCB: Successfully loaded ${ocbList.length} OCB items with owned details');
    } catch (e) {
      log('Enhanced OCB: Error in _onFetchOcbWithOwnedDetails: $e');
      emit(EnhancedOcbErrorState(error: e.toString()));
    }
  }

  Future<void> _onRefreshOcbWithOwnedDetails(
    OnRefreshOcbWithOwnedDetails event,
    Emitter<EnhancedOcbState> emit,
  ) async {
    // Same logic as fetch, but could add refresh-specific behavior
    await _onFetchOcbWithOwnedDetails(
      OnFetchOcbWithOwnedDetails(context: event.context),
      emit,
    );
  }
}
