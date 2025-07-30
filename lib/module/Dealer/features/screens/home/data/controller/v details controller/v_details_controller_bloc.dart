import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:wheels_kart/common/components/app_spacer.dart';
import 'package:wheels_kart/module/Dealer/core/components/v_loading.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_api_const.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_colors.dart';
import 'package:wheels_kart/module/Dealer/core/v_style.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/controller/ocb%20controller/v_ocb_controller_bloc.dart';
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
          final datas = VCarDetailModel.fromJson(data as Map<String, dynamic>);
          List<bool> enalbes = [true];
          final bools = datas.sections.map((e) => true).toList();
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
        } else {
          emit(VDetailsControllerErrorState(error: response['message']));
        }
      } else {
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
      final currentState = state;
      if (currentState is VDetailsControllerSuccessState) {
        List<Map<String, dynamic>> images = [];
        if (event.imageTabIndex == 0) {
          for (var image in currentState.detail.images) {
            images.add({"image": image.url, "comment": image.name});
          }
        } else {
          final section = currentState.detail.sections[event.imageTabIndex - 1];
          for (var entry in section.entries) {
            for (var image in entry.responseImages) {
              images.add({"image": image, "comment": entry.comment});
            }
          }
        }
        emit(
          currentState.coptyWith(
            currentImageTabIndex: event.imageTabIndex,
            currentTabImages: images,
          ),
        );
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
          _timer?.cancel();
          emit(currentState.coptyWith(endTime: "00:00:00"));
        }
      }
    });
  }

  // WEB SOCKET

  void _connectWebSocket(
    ConnectWebSocket event,
    Emitter<VDetailsControllerState> emit,
  ) {
    channel = WebSocketChannel.connect(Uri.parse(VApiConst.socket));

    _subscription = channel.stream.listen((data) {
      log("triggered ----------------");
      String decoded = utf8.decode(data);
      final jsonData = jsonDecode(decoded);
      log("Converted ----------------");

      add(UpdatePrice(newBid: LiveBidModel.fromJson(jsonData)));
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    channel.sink.close();
    return super.close();
  }

  //. WHATSAPP BID

  static Future<void> showDiologueForBidWhatsapp({
    required BuildContext context,
    required String evaluationId,
    required String regNumber,
    required String model,
    required String manufactureYear,
    required String kmDrive,
    required String noOfOwners,
    required String currentBid,
    required String image,
  }) async {
    HapticFeedback.mediumImpact();

    final yourBid = int.parse(currentBid.isEmpty?"0":currentBid) + 2000;

    final message = '''
$image
*Vehicle Bid Details:*
• Evaluation ID: $evaluationId
• Registration No: $regNumber
• Model: $model
• Year: $manufactureYear
• KMs Driven: $kmDrive
• No. of Owners: $noOfOwners
• Current Bid: ₹$currentBid
• Your Bid: ₹$yourBid
''';

    final encodedMessage = Uri.encodeComponent(message);
    final Uri url = Uri.parse(
      'https://wa.me/919964955575?text=$encodedMessage',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.5),
      builder:
          (context) => AnimatedPadding(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                color: VColors.WHITE,
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Place Your Bid Confirmation",
                      style: VStyle.style(
                        context: context,
                        fontWeight: FontWeight.bold,
                        size: 16,
                      ),
                    ),
                    AppSpacer(heightPortion: .015),
                    Text(
                      "You are about to place a bid for this vehicle.",
                      style: VStyle.style(context: context),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "• Current Bid: ₹$currentBid",
                      style: VStyle.style(
                        context: context,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "• Your Bid: ₹$yourBid",
                      style: VStyle.style(
                        context: context,
                        fontWeight: FontWeight.bold,
                        color: VColors.GREENHARD,
                      ),
                    ),
                    AppSpacer(heightPortion: .02),
                    Text(
                      "Once you confirm, you’ll be redirected to WhatsApp to complete your bidding process.",
                      style: VStyle.style(context: context, size: 13),
                    ),
                    AppSpacer(heightPortion: .02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Flexible(
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "Cancel",
                              style: VStyle.style(
                                context: context,
                                color: VColors.GREENHARD,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: InkWell(
                            onTap: () async {
                              if (!await launchUrl(
                                url,
                                mode: LaunchMode.externalApplication,
                              )) {
                                throw 'Could not launch WhatsApp chat';
                              }
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 24,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: VColors.GREENHARD,
                              ),
                              child: Text(
                                "Yes, Place Bid",
                                style: VStyle.style(
                                  context: context,
                                  fontWeight: FontWeight.bold,
                                  color: VColors.WHITE,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }

  // BUY BID

  static void showBuySheet(
    BuildContext context,
    String currentBid,
    String inspectionId,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.5),
      builder:
          (context) => AnimatedPadding(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                color: VColors.WHITE,
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Confirm Purchase",
                      style: VStyle.style(
                        context: context,
                        fontWeight: FontWeight.bold,
                        size: 18,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "You're about to buy this vehicle.",
                      style: VStyle.style(context: context, size: 14),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Current Price: ₹$currentBid",
                      style: VStyle.style(
                        context: context,
                        size: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Once you confirm, our team will contact you to complete the purchase process outside the app. Make sure you're ready to proceed.",
                      style: VStyle.style(
                        context: context,
                        size: 13,
                        color: Colors.grey[700],
                      ),
                    ),
                    AppSpacer(heightPortion: .03),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Flexible(
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "Cancel",
                              style: VStyle.style(
                                context: context,
                                fontWeight: FontWeight.bold,
                                color: VColors.PRIMARY,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Flexible(
                          child: InkWell(
                            onTap: () async {
                              context.read<VOcbControllerBloc>().add(
                                OnBuyOCB(
                                  inspectionId: inspectionId,
                                  context: context,
                                ),
                              );
                            },
                            child: Container(
                              width: 200,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: VColors.GREENHARD,
                              ),
                              child: BlocBuilder<
                                VOcbControllerBloc,
                                VOcbControllerState
                              >(
                                builder: (context, state) {
                                  return state is VOcbControllerSuccessState &&
                                          state.loadingTheOCBButton
                                      ? VLoadingIndicator()
                                      : Text(
                                        "Yes, Confirm & Proceed",
                                        style: VStyle.style(
                                          context: context,
                                          fontWeight: FontWeight.bold,
                                          color: VColors.WHITE,
                                        ),
                                      );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }
}
