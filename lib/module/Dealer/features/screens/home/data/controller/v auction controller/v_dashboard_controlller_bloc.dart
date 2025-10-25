import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_api_const.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/controller/filter_auction_and_ocb/filter_acution_and_ocb_cubit.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/model/v_car_model.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/model/v_live_bid_model.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/repo/v_dashboard_repo.dart';

part 'v_dashboard_controlller_event.dart';
part 'v_dashboard_controlller_state.dart';

class VAuctionControlllerBloc
    extends Bloc<VAuctionControlllerEvent, VAuctionControlllerState> {
  late WebSocketChannel channel;
  StreamSubscription? _subscription;

  VAuctionControlllerBloc() : super(VAuctionControlllerInitialState()) {
    on<OnFetchVendorAuctionApi>((event, emit) async {
      emit(VAuctionControlllerLoadingState());
      final response = await VAuctionData.getAuctionData(event.context);
      if (response.isNotEmpty) {
        if (response['error'] == false) {
          List<VCarModel> finallist = [];
          
          // Check if the response has the new format with 'live' and 'closed' keys
          if (response.containsKey('live') && response.containsKey('closed')) {
            // New API format: use live or closed array based on tab
            if (event.tab == "Auction") {
              final liveData = response['live'] as List;
              finallist = liveData.map((e) => VCarModel.fromJson(e)).toList();
            } else {
              final closedData = response['closed'] as List;
              finallist = closedData.map((e) => VCarModel.fromJson(e)).toList();
            }
          } 
          // Old API format: filter by date
          else if (response.containsKey('data')) {
            final data = response['data'] as List;
            final list = data.map((e) => VCarModel.fromJson(e)).toList();
            if (event.tab == "Auction") {
              finallist =
                  list.where((element) {
                    final now = DateTime.now();
                    final time = element.bidClosingTime;
                    return now.isBefore(time ?? DateTime.now());
                  }).toList();
            } else {
              finallist =
                  list.where((element) {
                    final now = DateTime.now();
                    final time = element.bidClosingTime;
                    return now.isAfter(time ?? DateTime.now());
                  }).toList();
            }
          }

          emit(
            VAuctionControllerSuccessState(
              filterdAutionList: finallist,
              listOfAllLiveAuctionFromServer: finallist,
              enableRefreshButton: false,
            ),
          );
        } else {
          emit(VVAuctionControllerErrorState(errorMesage: response['message']));
        }
      }
    });

    // WEB SOCKET

    on<ConnectWebSocket>(_connectWebSocket);

    on<UpdatePrice>((event, emit) async {
      final cuuremtSate = state;
      List<VCarModel> updatedList = [];

      if (cuuremtSate is VAuctionControllerSuccessState) {
        if (event.newBid.trigger != null && event.newBid.trigger == "new") {
          debugPrint("🆕 [WebSocket] New Auction Listed - Auto-fetching data...");

          try {
            // Automatically fetch new auction data
            final response = await VAuctionData.getAuctionData(event.context);
            
            if (response.isNotEmpty && response['error'] == false) {
              List<VCarModel> finallist = [];
              
              // Check if the response has the new format with 'live' and 'closed' keys
              if (response.containsKey('live') && response.containsKey('closed')) {
                // New API format: use live array
                final liveData = response['live'] as List;
                finallist = liveData.map((e) => VCarModel.fromJson(e)).toList();
              } 
              // Old API format: filter by date
              else if (response.containsKey('data')) {
                final data = response['data'] as List;
                final list = data.map((e) => VCarModel.fromJson(e)).toList();
                finallist = list.where((element) {
                  final now = DateTime.now();
                  final time = element.bidClosingTime;
                  return now.isBefore(time ?? DateTime.now());
                }).toList();
              }

              debugPrint("✅ [WebSocket] New auction fetched - Total live auctions: ${finallist.length}");
              
              emit(
                VAuctionControllerSuccessState(
                  filterdAutionList: finallist,
                  listOfAllLiveAuctionFromServer: finallist,
                  enableRefreshButton: false,
                ),
              );
            } else {
              debugPrint("⚠️ [WebSocket] Failed to fetch new auction - Showing refresh button");
              // Fallback: show refresh button if auto-fetch fails
              emit(
                VAuctionControllerSuccessState(
                  filterdAutionList: cuuremtSate.listOfAllLiveAuctionFromServer,
                  listOfAllLiveAuctionFromServer:
                      cuuremtSate.listOfAllLiveAuctionFromServer,
                  enableRefreshButton: true,
                ),
              );
            }
          } catch (e) {
            debugPrint("❌ [WebSocket] Error auto-fetching new auction: $e");
            // Fallback: show refresh button if error occurs
            emit(
              VAuctionControllerSuccessState(
                filterdAutionList: cuuremtSate.listOfAllLiveAuctionFromServer,
                listOfAllLiveAuctionFromServer:
                    cuuremtSate.listOfAllLiveAuctionFromServer,
                enableRefreshButton: true,
              ),
            );
          }
        } else {
          debugPrint("🔄 [WebSocket] Auction Updated - EvaluationId: ${event.newBid.evaluationId}");
          bool foundAuction = false;
          
          for (var car in cuuremtSate.listOfAllLiveAuctionFromServer) {
            if (car.evaluationId == event.newBid.evaluationId) {
              foundAuction = true;
              final bid = event.newBid;
              final reversed = bid.vendorBids.toList();

              debugPrint("✅ [WebSocket] Updating auction ${car.evaluationId}:");
              debugPrint("   - Old bid: ${car.currentBid} -> New bid: ${bid.currentBid}");
              debugPrint("   - Old status: ${car.bidStatus} -> New status: ${bid.bidStatus}");
              debugPrint("   - Vendor count: ${reversed.length}");

              car.bidStatus = bid.bidStatus;
              car.soldName = bid.soldName;
              car.soldTo = bid.soldTo;
              car.currentBid = bid.currentBid;
              car.bidClosingTime = bid.bidClosingTime;
              car.vendorIds = reversed.map((e) => e.vendorId).toList();

              // Only add to list if auction is still live (not sold/closed)
              if (car.bidStatus == "Open" && car.bidClosingTime?.isAfter(DateTime.now()) == true) {
                updatedList.add(car);
                debugPrint("✅ Auction ${car.evaluationId} remains live");
              } else {
                debugPrint("🗑️ Auction ${car.evaluationId} sold/closed - removing from list");
              }
            } else {
              updatedList.add(car);
            }
          }
          
          if (!foundAuction) {
            debugPrint("⚠️ [WebSocket] Auction ${event.newBid.evaluationId} not found in current list");
          }
          
          emit(
            VAuctionControllerSuccessState(
              filterdAutionList: updatedList,
              listOfAllLiveAuctionFromServer: updatedList,
              enableRefreshButton: cuuremtSate.enableRefreshButton,
            ),
          );
          debugPrint("✅ [WebSocket] Update completed successfully");
        }
      } else {
        debugPrint("⚠️ [WebSocket] Cannot update - Bloc not in Success state");
      }
    });

    // FILTER

    on<OnApplyFilterAndSortInAuction>((event, emit) {
      final currentState = state;

      if (currentState is! VAuctionControllerSuccessState) {
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
        currentState.listOfAllLiveAuctionFromServer,
      );

      // If filters is null or empty => reset filtered list to full list (optionally apply sort)
      if (filters == null || filters.isEmpty) {
        List<VCarModel> result = List<VCarModel>.from(baseList);

        if (sort != null && sort.isNotEmpty) {
          result = _onSort(result, sort);
        }

        // Only emit if different (cheap identity check)
        if (!_listEqualsById(result, currentState.filterdAutionList)) {
          emit(currentState.copyWith(filterdAutionList: result));
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
      if (!_listEqualsById(filtered, currentState.filterdAutionList)) {
        emit(currentState.copyWith(filterdAutionList: filtered));
      } else {
        debugPrint(
          'OnApplyFilterAndSort: filtered list identical to current, skipping emit.',
        );
      }
    });

    // Search

    on<OnSearchAuction>((event, emit) {
      final currentState = state;
      final query = event.query.toLowerCase().trim();

      if (currentState is VAuctionControllerSuccessState) {
        if (query.isEmpty) {
          // If search box cleared → reset to full list
          emit(
            currentState.copyWith(
              filterdAutionList: List<VCarModel>.from(
                currentState.listOfAllLiveAuctionFromServer,
              ),
            ),
          );
          return;
        }

        final searchedResult =
            currentState.listOfAllLiveAuctionFromServer.where((element) {
              final brand = element.brandName.trim().toLowerCase();
              final model = element.modelName.trim().toLowerCase();
              final year = element.manufacturingYear.trim().toLowerCase();
              final fuel = element.fuelType.trim().toLowerCase();

              return brand.contains(query) ||
                  model.contains(query) ||
                  year.contains(query) ||
                  fuel.contains(query);
            }).toList();

        emit(currentState.copyWith(filterdAutionList: searchedResult));
      } else {
        debugPrint("OnSearchAuction: state is not Success, ignoring");
      }
    });

    // Remove Expired Auction

    on<RemoveExpiredAuction>((event, emit) {
      final currentState = state;

      if (currentState is VAuctionControllerSuccessState) {
        debugPrint("🗑️ [Auction] Removing expired auction: ${event.inspectionId}");
        
        // Remove from both the filtered list and the full list
        final updatedFilteredList = currentState.filterdAutionList
            .where((vehicle) => vehicle.inspectionId != event.inspectionId)
            .toList();
        
        final updatedFullList = currentState.listOfAllLiveAuctionFromServer
            .where((vehicle) => vehicle.inspectionId != event.inspectionId)
            .toList();

        debugPrint("✅ [Auction] Expired auction removed. Remaining count: ${updatedFilteredList.length}");

        emit(
          VAuctionControllerSuccessState(
            filterdAutionList: updatedFilteredList,
            listOfAllLiveAuctionFromServer: updatedFullList,
            enableRefreshButton: currentState.enableRefreshButton,
          ),
        );
      } else {
        debugPrint("⚠️ [Auction] Cannot remove - Bloc not in Success state");
      }
    });
  }

  Timer? _heartbeatTimer;
  Timer? _pongTimeoutTimer;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 5;
  bool _isPongReceived = true;
  DateTime? _lastPingTime;
  static const int _pingInterval = 30; // seconds
  static const int _pongTimeout = 10; // seconds

  void _connectWebSocket(
    ConnectWebSocket event,
    Emitter<VAuctionControlllerState> emit,
  ) {
    try {
      debugPrint("🔌 [WebSocket] Connecting to: ${VApiConst.socket}");
      channel = WebSocketChannel.connect(Uri.parse(VApiConst.socket));
      debugPrint("✅ [WebSocket] Connection initiated successfully");

      // Start ping-pong mechanism
      _startPingPong();

      _subscription = channel.stream.listen(
        (data) {
          // Check if bloc is still active before processing
          if (isClosed) {
            debugPrint("⚠️ [WebSocket] Bloc is closed, ignoring incoming data");
            return;
          }

          debugPrint("📥 [WebSocket] Data received");

          try {
            final decoded = (data is String) ? data : utf8.decode(data);
            debugPrint("📝 [WebSocket] Decoded data: $decoded");
            
            final jsonData = jsonDecode(decoded);
            debugPrint("✅ [WebSocket] JSON parsed successfully");
            debugPrint("📊 [WebSocket] Parsed data: $jsonData");

            // Handle ping-pong responses
            if (jsonData['type'] == 'pong') {
              _handlePongResponse();
              return; // Don't process as bid update
            }

            // Reset reconnect attempts on successful message
            _reconnectAttempts = 0;

            // Only add event if bloc is not closed
            if (!isClosed) {
              add(
                UpdatePrice(
                  newBid: LiveBidModel.fromJson(jsonData),
                  context: event.context,
                ),
              );
              debugPrint("🔄 [WebSocket] UpdatePrice event dispatched");
            } else {
              debugPrint("⚠️ [WebSocket] Bloc closed, event not dispatched");
            }
          } catch (e, stackTrace) {
            debugPrint("❌ [WebSocket] Error decoding data: $e");
            debugPrint("📋 [WebSocket] Stack trace: $stackTrace");
          }
        },
        onError: (error, stackTrace) {
          if (!isClosed) {
            debugPrint("❌ [WebSocket] Connection error: $error");
            debugPrint("📋 [WebSocket] Error stack trace: $stackTrace");
            _reconnect(event);
          }
        },
        onDone: () {
          if (!isClosed) {
            debugPrint("🔌 [WebSocket] Connection closed");
            _reconnect(event);
          }
        },
        cancelOnError: true,
      );
      
      debugPrint("👂 [WebSocket] Listening for messages...");
    } catch (e, stackTrace) {
      debugPrint("❌ [WebSocket] Failed to connect: $e");
      debugPrint("📋 [WebSocket] Stack trace: $stackTrace");
      _reconnect(event);
    }
  }

  void _reconnect(ConnectWebSocket event) {
    _subscription?.cancel();
    _reconnectAttempts++;
    
    // Don't reconnect if bloc is closed
    if (isClosed) {
      debugPrint("⚠️ [WebSocket] Bloc is closed, skipping reconnection");
      return;
    }
    
    if (_reconnectAttempts > _maxReconnectAttempts) {
      debugPrint("⚠️ [WebSocket] Max reconnection attempts ($_maxReconnectAttempts) reached. Stopping reconnection.");
      return;
    }
    
    final delay = Duration(seconds: 3 * _reconnectAttempts); // Exponential backoff
    debugPrint("🔄 [WebSocket] Reconnecting in ${delay.inSeconds} seconds (Attempt $_reconnectAttempts/$_maxReconnectAttempts)...");
    
    Future.delayed(delay, () {
      // Check again before reconnecting
      if (!isClosed) {
        debugPrint("🔄 [WebSocket] Attempting reconnection...");
        add(ConnectWebSocket(context: event.context));
      } else {
        debugPrint("⚠️ [WebSocket] Bloc closed during delay, skipping reconnection");
      }
    });
  }

  void _startPingPong() {
    _heartbeatTimer?.cancel();
    _pongTimeoutTimer?.cancel();
    _isPongReceived = true;
    
    _heartbeatTimer = Timer.periodic(Duration(seconds: _pingInterval), (_) {
      if (isClosed) {
        debugPrint("⚠️ [WebSocket] Bloc closed, stopping ping-pong");
        _heartbeatTimer?.cancel();
        _pongTimeoutTimer?.cancel();
        return;
      }
      
      _sendPing();
    });
  }

  void _sendPing() {
    try {
      final pingMessage = jsonEncode({
        "type": "ping",
        "timestamp": DateTime.now().millisecondsSinceEpoch,
      });
      
      channel.sink.add(pingMessage);
      _lastPingTime = DateTime.now();
      _isPongReceived = false;
      
      debugPrint("💓 [WebSocket] Ping sent: $pingMessage");
      
      // Start pong timeout timer
      _pongTimeoutTimer?.cancel();
      _pongTimeoutTimer = Timer(Duration(seconds: _pongTimeout), () {
        if (!_isPongReceived && !isClosed) {
          debugPrint("⏰ [WebSocket] Pong timeout - reconnecting...");
          // Note: We can't reconnect without context, so we'll just log the issue
          debugPrint("⚠️ [WebSocket] Pong timeout detected but no context available for reconnection");
        }
      });
      
    } catch (e) {
      debugPrint("❌ [WebSocket] Ping failed: $e");
      if (!isClosed) {
        // Note: We can't reconnect without context, so we'll just log the issue
        debugPrint("⚠️ [WebSocket] Ping failed but no context available for reconnection");
      }
    }
  }

  void _handlePongResponse() {
    _isPongReceived = true;
    _pongTimeoutTimer?.cancel();
    
    final responseTime = DateTime.now().difference(_lastPingTime ?? DateTime.now());
    debugPrint("🏓 [WebSocket] Pong received - Response time: ${responseTime.inMilliseconds}ms");
  }

  @override
  Future<void> close() {
    debugPrint("🔴 [WebSocket] Closing Bloc and WebSocket connection");
    _heartbeatTimer?.cancel();
    _pongTimeoutTimer?.cancel();
    _subscription?.cancel();
    try {
      channel.sink.close();
      debugPrint("✅ [WebSocket] Connection closed successfully");
    } catch (e) {
      debugPrint("⚠️ [WebSocket] Error closing connection: $e");
    }
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

  /// --- UI label -> filter mappers (use these to convert selected labels to numeric filters) ---
}
