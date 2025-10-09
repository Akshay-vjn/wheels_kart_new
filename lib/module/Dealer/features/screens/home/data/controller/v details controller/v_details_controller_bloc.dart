import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_api_const.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/model/v_car_detail_model.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/model/v_live_bid_model.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/repo/v_fetch_car_detail_repo.dart';
part 'v_details_controller_event.dart';
part 'v_details_controller_state.dart';

class VDetailsControllerBloc
    extends Bloc<VDetailsControllerEvent, VDetailsControllerState> {
  late WebSocketChannel channel;
  StreamSubscription? _subscription;
  Timer? _timer;

  VDetailsControllerBloc() : super(VDetailsControllerInitialState()) {
    on<OnFetchDetails>((event, emit) async {
      emit(VDetailsControllerLoadingState());

      final response = await VFetchCarDetailRepo.onGetCarDetails(
        event.context,
        // "55"
        event.inspectionId,
      );

      if (response.isNotEmpty) {
        if (response['error'] == false) {
          final data = response['data'] as Map;
          final mainData = VCarDetailModel.fromJson(
            data as Map<String, dynamic>,
          );

          mainData.sections.forEach((section) {
            section.entries.sort((a, b) {
              final aAns = (a.answer).trim().toUpperCase();
              final bAns = (b.answer).trim().toUpperCase();

              // "Good" = answer is NOT "NOT OK" AND NOT "NO"
              final aGood = aAns != 'NOT OK' && aAns != 'NO';
              final bGood = bAns != 'NOT OK' && bAns != 'NO';

              if (aGood && !bGood) return -1;
              if (!aGood && bGood) return 1;
              return 0; // keep relative order (non-deterministic because Dart sort is not stable)
            });
          });
          final datas = mainData;
          List<bool> enalbes = [true, false];
          final bools = datas.sections.map((e) => false).toList();
          emit(
            VDetailsControllerSuccessState(
              enables: [...enalbes, ...bools],
              detail: datas,
            ),
          );
          _timer?.cancel(); // Cancel any existing timer
          _timer = Timer.periodic(Duration(seconds: 1), (_) {
            add(RunTimer());
          });
          log(response['message']);
        } else {
          log("---------------------------${response['message']}");
          emit(VDetailsControllerErrorState(error: response['message']));
        }
      } else {
        log("---------------------------${response['message']}");
        log("Empty response");
        emit(VDetailsControllerErrorState(error: "Empty response"));
      }
    });

    on<OnChangeImageIndex>((event, emit) async {
      final currentState = state;
      if (currentState is VDetailsControllerSuccessState) {
        emit(currentState.coptyWith(currentImageIndex: event.newIndex));
      }
    });

    on<OnCollapesCard>((event, emit) async {
      final currentState = state;
      if (currentState is VDetailsControllerSuccessState) {
        if (currentState.enables[event.index] == false) {
          currentState.enables[event.index] = true;
        } else {
          currentState.enables[event.index] = false;
        }
        emit(currentState.coptyWith(enables: currentState.enables));
      }
    });

    on<OnChangeImageTab>((event, emit) async {
      try {
        final currentState = state;

        if (currentState is VDetailsControllerSuccessState) {
          List<Map<String, dynamic>> images = [];
          if (event.imageTabIndex == 0) {
            log(
              "-->>>>>>>>>>>>>>>>> Index (${currentState.detail.images.length})",
            );
            for (var image in currentState.detail.images) {
              images.add({"image": image.url, "comment": image.name});
            }
          } else {
            log("-->>>>>>>>>>>>>>>>> OTHER INDEX 1");
            final section =
                currentState.detail.sections[event.imageTabIndex - 1];
            for (var entry in section.entries) {
              for (var image in entry.responseImages) {
                images.add({"image": image, "comment": entry.options});
              }
            }
          }
          emit(
            currentState.coptyWith(
              currentImageTabIndex: event.imageTabIndex,
              currentTabImages: images,
            ),
          );
          log(
            "-->>>>>>>>>>>>>>>>> ${event.imageTabIndex}---- ${images.length}   ${state.toString()}<<<<<<<<<<<<<------_",
          );
        } else {
          log("--ELSE---------- catched Error while changin tab");
        }
      } catch (e) {
        log("------------- catched Error while changin tab ${e}");
      }
    });

    on<ConnectWebSocket>(_connectWebSocket);

    on<UpdatePrice>((event, emit) {
      final cuuremtSate = state;
      if (cuuremtSate is VDetailsControllerSuccessState) {
        log("--------Auction Updated");
        final carDetailModel = cuuremtSate.detail;
        if (carDetailModel.carDetails.evaluationId ==
            event.newBid.evaluationId) {
          carDetailModel.carDetails.currentBid = event.newBid.currentBid;
          carDetailModel.carDetails.bidClosingTime =
              event.newBid.bidClosingTime;

          emit(cuuremtSate.coptyWith(detail: carDetailModel));
        }
      }

      //000
      log("Updating Done------------");
    });
    on<RunTimer>((event, emit) {
      final currentState = state;
      if (currentState is VDetailsControllerSuccessState) {
        log("Timer running in Success State ........");
        final closingTIme = currentState.detail.carDetails.bidClosingTime;
        final now = DateTime.now();
        if (closingTIme != null) {
          final difference = closingTIme.difference(now);

          if (difference.isNegative) {
            _timer?.cancel();
            emit(currentState.coptyWith(endTime: "00:00:00"));
          } else {
            final hour = difference.inHours % 60;
            final min = difference.inMinutes % 60;
            final sec = difference.inSeconds % 60;

            // Format with leading zeros if needed
            final minStr = min.toString().padLeft(2, '0');
            final secStr = sec.toString().padLeft(2, '0');
            emit(currentState.coptyWith(endTime: "$hour:$minStr:$secStr"));
          }
        } else {
          log("Timer Cancledd  ........");
          _timer?.cancel();
          emit(currentState.coptyWith(endTime: "00:00:00"));
        }
      } else {
        log("Timer out of successState");
      }
    });
  }

  // WEB SOCKET

  // void _connectWebSocket(
  //   ConnectWebSocket event,
  //   Emitter<VDetailsControllerState> emit,
  // ) {
  //   channel = WebSocketChannel.connect(Uri.parse(VApiConst.socket));

  //   _subscription = channel.stream.listen((data) {
  //     log("triggered ----------------");
  //     String decoded = utf8.decode(data);
  //     final jsonData = jsonDecode(decoded);
  //     log("Converted ----------------");

  //     add(UpdatePrice(newBid: LiveBidModel.fromJson(jsonData)));
  //   });
  // }
  Timer? _heartbeatTimer;

  void _connectWebSocket(
    ConnectWebSocket event,
    Emitter<VDetailsControllerState> emit,
  ) {
    channel = WebSocketChannel.connect(Uri.parse(VApiConst.socket));

    // Send heartbeat every 30 seconds

    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(Duration(seconds: 30), (_) {
      try {
        channel.sink.add(jsonEncode({"type": "ping"}));
      } catch (e) {
        log("Ping failed: $e");
      }
    });

    _subscription = channel.stream.listen(
      (data) {
        log("triggered ----------------");

        try {
          final decoded = (data is String) ? data : utf8.decode(data);
          final jsonData = jsonDecode(decoded);
          log("Converted ----------------");

          add(UpdatePrice(newBid: LiveBidModel.fromJson(jsonData)));
        } catch (e) {
          log("Error decoding WebSocket data: $e");
        }
      },
      onError: (error) {
        log("WebSocket error: $error");
        _reconnect(event);
      },
      onDone: () {
        log("WebSocket closed. Reconnecting...");
        _reconnect(event);
      },
      cancelOnError: true,
    );
  }

  void _reconnect(ConnectWebSocket event) {
    _subscription?.cancel();
    Future.delayed(Duration(seconds: 3), () {
      add(ConnectWebSocket());
    });
  }

  @override
  Future<void> close() {
    log("------------Closing Bloc and WebSocket. ------------ Details Bloc");
    _timer?.cancel();
    _heartbeatTimer?.cancel();
    _subscription?.cancel();
    channel.sink.close();
    return super.close();
  }

  //. WHATSAPP BID

  // BUY BID

  // BlocProvider.value(
  //               value: context.read<VAuctionControlllerBloc>(),
  //               child:
}
