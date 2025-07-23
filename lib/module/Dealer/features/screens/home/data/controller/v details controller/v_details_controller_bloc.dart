import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:wheels_kart/common/components/app_margin.dart';
import 'package:wheels_kart/common/components/app_spacer.dart';
import 'package:wheels_kart/common/dimensions.dart';
import 'package:wheels_kart/common/utils/responsive_helper.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_colors.dart';
import 'package:wheels_kart/module/Dealer/core/v_style.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/model/v_car_detail_model.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/model/v_car_model.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/model/v_live_bid_model.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/repo/v_fetch_car_detail_repo.dart';
import 'package:wheels_kart/module/Dealer/features/widgets/v_custom_button.dart';

part 'v_details_controller_event.dart';
part 'v_details_controller_state.dart';

class VDetailsControllerBloc
    extends Bloc<VDetailsControllerEvent, VDetailsControllerState> {
  late WebSocketChannel channel;
  StreamSubscription? _subscription;
  VDetailsControllerBloc() : super(VDetailsControllerInitialState()) {
    on<OnFetchDetails>((event, emit) async {
      emit(VDetailsControllerLoadingState());

      final response = await VFetchCarDetailRepo.onGetCarDetails(
        event.context,
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
        log("Started ----------------");
        final carDetailModel = cuuremtSate.detail;
        if (carDetailModel.carDetails.evaluationId ==
            event.newBid.evaluationId) {
          carDetailModel.carDetails.currentBid = event.newBid.currentBid;
          emit(cuuremtSate.coptyWith(detail: carDetailModel));
        }
      }

      //000
      log("Stopped ----------------");
    });
  }

  // WEB SOCKET

  void _connectWebSocket(
    ConnectWebSocket event,
    Emitter<VDetailsControllerState> emit,
  ) {
    channel = WebSocketChannel.connect(Uri.parse('ws://82.112.238.223:8080'));

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

  static Future<void> openWhatsApp(
  // VCarDetailModel details,
  // String image,
  {
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

    final id = evaluationId;
    final vehicleRegNo = regNumber;
    final vehicleModel = model;
    final yearOfManufacture = manufactureYear;
    final kmDriven = kmDrive;
    final numberOfOwners = noOfOwners;
    final currentBidAmount = currentBid;
    final frontImage = image; // Assuming this is a URL
    final yourBid = int.parse(currentBid) + 2000;

    final message = '''
$frontImage
*Vehicle Details:*
• Evaluation ID: $id
• Registration No: $vehicleRegNo
• Model: $vehicleModel
• Year of Manufacture: $yearOfManufacture
• KMs Driven: $kmDriven
• No. of Owners: $numberOfOwners
• Current Bid: ₹$currentBidAmount
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
                      "You want to place your bid ?",
                      style: VStyle.style(
                        context: context,
                        fontWeight: FontWeight.bold,
                        size: 20,
                      ),
                    ),
                    Text("Cuurent Price : $currentBid"),
                    Text("Your bid : $yourBid"),
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
                              "No",
                              style: VStyle.style(
                                context: context,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: TextButton(
                            onPressed: () async {
                              if (!await launchUrl(
                                url,
                                mode: LaunchMode.externalApplication,
                              )) {
                                throw 'Could not launch WhatsApp chat';
                              }
                            },
                            child: Text("Yes"),
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
