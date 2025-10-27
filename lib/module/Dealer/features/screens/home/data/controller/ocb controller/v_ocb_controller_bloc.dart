import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_api_const.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/controller/filter_auction_and_ocb/filter_acution_and_ocb_cubit.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/model/v_car_model.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/model/v_live_bid_model.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/repo/v_fetch_ocb_list_repo.dart';

part 'v_ocb_controller_event.dart';
part 'v_ocb_controller_state.dart';

class VOcbControllerBloc
    extends Bloc<VOcbControllerEvent, VOcbControllerState> {
  late WebSocketChannel channel;
  StreamSubscription? _subscription;
  VOcbControllerBloc() : super(VOcbControlllerInitialState()) {
    on<OnFechOncList>((event, emit) async {
      emit(VOcbControlllerLoadingState());
      final response = await VFetchOcbListRepo.getOcbList(event.context);
      if (response.isNotEmpty) {
        if (response['error'] == false) {
          final data = response['data'] as List;
          final list = data.map((e) => VCarModel.fromJson(e)).toList();

          emit(
            VOcbControllerSuccessState(
              listOfAllOCBFromServer: list,
              sortedAndFilterdOCBList: list,
              enableRefreshButton: false,
            ),
          );
        } else {
          emit(VOcbControllerErrorState(errorMesage: response['message']));
        }
      }
    });
    on<ConnectWebSocket>(_connectWebSocket);

    on<UpdatePrice>((event, emit) async {
      final cuuremtSate = state;
      List<VCarModel> updatedList = [];

      if (cuuremtSate is VOcbControllerSuccessState) {
        if (event.newBid.trigger != null && event.newBid.trigger == "ocb new") {
          debugPrint("--------New OCB Listed");

          final response = await VFetchOcbListRepo.getOcbList(event.context);
          if (response.isNotEmpty) {
            if (response['error'] == false) {
              final data = response['data'] as List;
              final list = data.map((e) => VCarModel.fromJson(e)).toList();

              emit(
                VOcbControllerSuccessState(
                  listOfAllOCBFromServer: list,
                  sortedAndFilterdOCBList: list,
                  enableRefreshButton: false,
                ),
              );
            } else {
              emit(VOcbControllerErrorState(errorMesage: response['message']));
            }
          }
        } else {
          debugPrint("--------Auction Updated");
          for (var car in cuuremtSate.sortedAndFilterdOCBList) {
            if (car.evaluationId == event.newBid.evaluationId) {
              final bid = event.newBid;

              final reversed = bid.vendorBids.toList();

              car.bidStatus = bid.bidStatus;
              car.soldName = bid.soldName;
              car.soldTo = bid.soldTo;
              car.currentBid = bid.currentBid;
              car.bidClosingTime = bid.bidClosingTime;
              car.vendorIds = reversed.map((e) => e.vendorId).toList();
              
              // Only add to list if OCB is still available (not sold/confirmed)
              if (car.bidStatus == "Open" && car.bidClosingTime?.isAfter(DateTime.now()) == true) {
                updatedList.add(car);
                debugPrint("✅ OCB ${car.evaluationId} remains available");
              } else {
                debugPrint("🗑️ OCB ${car.evaluationId} sold/expired - removing from list");
              }
            } else {
              updatedList.add(car);
            }
          }
          
          // Filter out any sold/expired OCBs from the full server list as well
          final filteredServerList = cuuremtSate.listOfAllOCBFromServer
              .where((car) => car.evaluationId == event.newBid.evaluationId 
                  ? (car.bidStatus == "Open" && car.bidClosingTime?.isAfter(DateTime.now()) == true)
                  : true)
              .toList();
          
          emit(
            VOcbControllerSuccessState(
              listOfAllOCBFromServer: filteredServerList,
              sortedAndFilterdOCBList: updatedList,
              enableRefreshButton: cuuremtSate.enableRefreshButton,
            ),
          );
          debugPrint("✅ OCB list updated - ${updatedList.length} available OCBs");
        }
      }
    });

    on<OnApplyFilterAndSortInOCB>((event, emit) {
      final currentState = state;

      if (currentState is! VOcbControllerSuccessState) {
        // If not success, you may want to queue the filter (see note below).
        debugPrint(
          'OnApplyFilterAndSort: bloc not in Success state, ignoring for now.',
        );
        return;
      }

      debugPrint(
        'OnApplyFilterAndSort: received filters=${event.filterBy}, sort=${event.sortBy}',
      );

      final filters = event.filterBy;
      final sort = event.sortBy;

      // Base list to filter from: always start from the full server list so
      // filters are applied consistently (AND semantics across categories).
      final List<VCarModel> baseList = List<VCarModel>.from(
        currentState.listOfAllOCBFromServer,
      );

      // If filters is null or empty => reset filtered list to full list (optionally apply sort)
      if (filters == null || filters.isEmpty) {
        List<VCarModel> result = List<VCarModel>.from(baseList);

        if (sort != null && sort.isNotEmpty) {
          result = _onSort(result, sort);
        }

        // Only emit if different (cheap identity check)
        if (!_listEqualsById(result, currentState.sortedAndFilterdOCBList)) {
          emit(currentState.copyWith(sortedAndFilterdOCBList: result));
        }
        return;
      }

      // Apply filters (returns a new list)
      List<VCarModel> filtered = _onFilter(baseList, filters);

      // Apply sort on filtered results if requested
      if (sort != null && sort.isNotEmpty) {
        filtered = _onSort(filtered, sort);
      }

      debugPrint('OnApplyFilterAndSort: filteredCount=${filtered.length}');

      // Emit new success state with filtered list
      if (!_listEqualsById(filtered, currentState.sortedAndFilterdOCBList)) {
        emit(currentState.copyWith(sortedAndFilterdOCBList: filtered));
      } else {
        debugPrint(
          'OnApplyFilterAndSort: filtered list identical to current, skipping emit.',
        );
      }
    });

    on<OnSearchOCB>((event, emit) {
      final currentState = state;
      final query = event.query.toLowerCase().trim();

      if (currentState is VOcbControllerSuccessState) {
        if (query.isEmpty) {
          // If search box cleared → reset to full list
          emit(
            currentState.copyWith(
              sortedAndFilterdOCBList: List<VCarModel>.from(
                currentState.listOfAllOCBFromServer,
              ),
            ),
          );
          return;
        }

        final searchedResult =
            currentState.listOfAllOCBFromServer.where((element) {
              final brand = element.brandName.trim().toLowerCase();
              final model = element.modelName.trim().toLowerCase();
              final year = element.manufacturingYear.trim().toLowerCase();
              final fuel = element.fuelType.trim().toLowerCase();

              return brand.contains(query) ||
                  model.contains(query) ||
                  year.contains(query) ||
                  fuel.contains(query);
            }).toList();

        emit(currentState.copyWith(sortedAndFilterdOCBList: searchedResult));
      } else {
        debugPrint("OnSearchAuction: state is not Success, ignoring");
      }
    });
  }

  Timer? _heartbeatTimer;

  void _connectWebSocket(
    ConnectWebSocket event,
    Emitter<VOcbControllerState> emit,
  ) {
    channel = WebSocketChannel.connect(Uri.parse(VApiConst.socket));

    // Start ping-pong mechanism
    _startPingPong();

    _subscription = channel.stream.listen(
      (data) {
        debugPrint("triggered ----------------");

        try {
          final decoded = (data is String) ? data : utf8.decode(data);
          final jsonData = jsonDecode(decoded);
          debugPrint("Converted ----------------");

          add(
            UpdatePrice(
              newBid: LiveBidModel.fromJson(jsonData),
              context: event.context,
            ),
          );
        } catch (e) {
          debugPrint("Error decoding WebSocket data: $e");
        }
      },
      onError: (error) {
        debugPrint("WebSocket error: $error");
        _reconnect(event);
      },
      onDone: () {
        debugPrint("WebSocket closed. Reconnecting...");
        _reconnect(event);
      },
      cancelOnError: true,
    );
  }

  void _reconnect(ConnectWebSocket event) {
    _subscription?.cancel();
    Future.delayed(Duration(seconds: 3), () {
      add(ConnectWebSocket(context: event.context));
    });
  }

  void _startPingPong() {
    _heartbeatTimer?.cancel();
    
    _heartbeatTimer = Timer.periodic(Duration(seconds: 5), (_) {
      if (isClosed) {
        _heartbeatTimer?.cancel();
        return;
      }
      
      try {
        channel.sink.add(jsonEncode({"type": "ping"}));
      } catch (e) {
        debugPrint("Ping failed: $e");
      }
    });
  }

  @override
  Future<void> close() {
    debugPrint("------------Closing Bloc and WebSocket. ------------ OCB Bloc");
    _heartbeatTimer?.cancel();
    _subscription?.cancel();
    channel.sink.close();
    return super.close();
  }

  // SORTING
  List<VCarModel> _onSort(List<VCarModel> result, String sort) {
    final options = FilterAcutionAndOcbCubit.sortOptions;
    final List<VCarModel> copy = List<VCarModel>.from(result);

    if (sort == options[0]) {
      // "Ending Soonest (Default)" -> sort by bidClosingTime ascending
      // copy.sort((a, b) {
      //   final at = a.bidClosingTime?.millisecondsSinceEpoch ?? 0;
      //   final bt = b.bidClosingTime?.millisecondsSinceEpoch ?? 0;
      //   return at.compareTo(bt);
      // });
      return copy;
    } else if (sort == options[1]) {
      // "Price - Low to High"
      copy.sort(
        (a, b) => (_parseIntSafe(a.currentBid ?? '') ?? 0).compareTo(
          _parseIntSafe(b.currentBid ?? '') ?? 0,
        ),
      );
    } else if (sort == options[2]) {
      // "Price - High to Low"
      copy.sort(
        (a, b) => (_parseIntSafe(b.currentBid ?? '') ?? 0).compareTo(
          _parseIntSafe(a.currentBid ?? '') ?? 0,
        ),
      );
    } else if (sort == options[3]) {
      // "Year - Old to New"
      copy.sort(
        (a, b) => (_parseIntSafe(a.manufacturingYear) ?? 0).compareTo(
          _parseIntSafe(b.manufacturingYear) ?? 0,
        ),
      );
    } else if (sort == options[4]) {
      // "Year - New to Old"
      copy.sort(
        (a, b) => (_parseIntSafe(b.manufacturingYear) ?? 0).compareTo(
          _parseIntSafe(a.manufacturingYear) ?? 0,
        ),
      );
    }

    return copy;
  }

  // FILTER

  bool _listEqualsById(List<VCarModel> a, List<VCarModel> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i].inspectionId != b[i].inspectionId) return false;
    }
    return true;
  }

  List<VCarModel> _onFilter(
    List<VCarModel> result,
    Map<FilterCategory, List<dynamic>> filters,
  ) {
    List<VCarModel> current = List<VCarModel>.from(result);

    filters.forEach((key, values) {
      if (values.isEmpty) return;

      switch (key) {
        case FilterCategory.MakeAndMode:
          final selected = values.map((v) => v.toLowerCase()).toSet();
          current =
              current
                  .where(
                    (e) =>
                        selected.contains(e.brandName.toLowerCase()) ||
                        selected.contains(e.modelName.toLowerCase()),
                  )
                  .toList();
          break;

        case FilterCategory.City:
          final selected = values.map((v) => v.toLowerCase()).toSet();
          current =
              current
                  .where((e) => selected.contains(e.city.toLowerCase()))
                  .toList();
          break;

        case FilterCategory.MakeYear:
          current =
              current.where((e) {
                final int year = _parseIntSafe(e.manufacturingYear) ?? 0;
                return values.any((v) => _matchesNumberOrRange(year, v));
              }).toList();
          break;

        case FilterCategory.KmDriven:
          current =
              current.where((e) {
                final int? km = _parseIntSafe(_removeKmSuffix(e.kmsDriven));
                if (km == null) return false;
                return values.any((v) => _matchesNumberOrRange(km, v));
              }).toList();
          break;

        case FilterCategory.FuelType:
          final selected = values.map((v) => v.toLowerCase()).toSet();
          current =
              current
                  .where((e) => selected.contains(e.fuelType.toLowerCase()))
                  .toList();
          break;

        // case FilterCategory.Owner:
        //   current =
        //       current.where((e) {
        //         final int? owners =
        //             e.ownerCount; // adjust if field name differs
        //         if (owners == null) return false;
        //         return values.any((v) => _matchesNumberOrRange(owners, v));
        //       }).toList();
        //   break;

        // case FilterCategory.Transmission:
        //   final selected = values.map((v) => v.toLowerCase()).toSet();
        //   current =
        //       current
        //           .where((e) => selected.contains(e.transmission.toLowerCase()))
        //           .toList();
        //   break;

        case FilterCategory.Price:
          current =
              current.where((e) {
                final int price = _parseIntSafe(e.currentBid ?? '') ?? 0;
                return values.any((v) => _matchesNumberOrRange(price, v));
              }).toList();
          break;
      }
    });

    return current;
  }

  int? _parseIntSafe(String? s) {
    if (s == null) return null;
    final cleaned = s.replaceAll(
      RegExp(r'[^0-9\-]'),
      '',
    ); // keep digits and minus
    if (cleaned.isEmpty) return null;
    return int.tryParse(cleaned);
  }

  /// Remove km/kms suffix and trailing punctuation, returns cleaned string
  String _removeKmSuffix(String s) {
    var trimmed = s.trim();

    // drop trailing punctuation (comma, period)
    while (trimmed.isNotEmpty &&
        (trimmed.endsWith(',') ||
            trimmed.endsWith('.') ||
            trimmed.endsWith(';'))) {
      trimmed = trimmed.substring(0, trimmed.length - 1).trim();
    }

    final lower = trimmed.toLowerCase();
    if (lower.endsWith('kms')) {
      return trimmed.substring(0, trimmed.length - 3).trim();
    } else if (lower.endsWith('km')) {
      return trimmed.substring(0, trimmed.length - 2).trim();
    }
    return trimmed;
  }

  /// Matches a numeric value against filter string forms:
  /// - inequalities: "<=n", ">=n", "<n", ">n"
  /// - ranges: "a-b"
  /// - exact number: "n"
  bool _matchesNumberOrRange(int value, String filter) {
    final s = filter.trim();

    if (s.isEmpty) return false;

    final lower = s.toLowerCase();

    // handle "before yyyy" or "before n" as "<=n"
    if (lower.startsWith('before')) {
      final n = _extractFirstNumber(s);
      if (n == null) return false;
      return value <= n;
    }

    // inequalities
    if (s.startsWith('<=')) {
      final n = _parseIntSafe(s.substring(2));
      return n != null ? value <= n : false;
    }
    if (s.startsWith('>=')) {
      final n = _parseIntSafe(s.substring(2));
      return n != null ? value >= n : false;
    }
    if (s.startsWith('<')) {
      final n = _parseIntSafe(s.substring(1));
      return n != null ? value < n : false;
    }
    if (s.startsWith('>')) {
      final n = _parseIntSafe(s.substring(1));
      return n != null ? value > n : false;
    }

    // hyphen-range "start-end"
    if (s.contains('-')) {
      final parts =
          s.split('-').map((p) => p.trim()).where((p) => p.isNotEmpty).toList();
      if (parts.length == 2) {
        final a = _parseIntSafe(parts[0]);
        final b = _parseIntSafe(parts[1]);
        if (a == null || b == null) return false;
        final low = min(a, b);
        final high = max(a, b);
        return value >= low && value <= high;
      }
      return false;
    }

    // exact number
    final n = _parseIntSafe(s);
    if (n != null) return value == n;

    return false;
  }

  /// Extract first number (2-4 digits or more) from a string. Returns null if none.
  int? _extractFirstNumber(String s) {
    final match = RegExp(r'(\d{2,})').firstMatch(s);
    if (match == null) return null;
    return int.tryParse(match.group(1)!);
  }
}
