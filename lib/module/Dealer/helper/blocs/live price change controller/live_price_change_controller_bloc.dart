import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

part 'live_price_change_controller_event.dart';
part 'live_price_change_controller_state.dart';

class LivePriceChangeControllerBloc extends Bloc<LivePriceChangeControllerEvent, LivePriceChangeControllerState> {
  late WebSocketChannel channel;
  StreamSubscription? _subscription;
  LivePriceChangeControllerBloc() : super(LivePriceChangeControllerInitial()) {

    
    on<ConnectWebSocket>(_connectWebSocket);

    
    on<UpdatePrice>((event, emit) {
      emit(PriceUpdated(event.price));
    });
  }



  void _connectWebSocket(
    ConnectWebSocket event,
    Emitter<LivePriceChangeControllerState> emit,
  ) {
    channel = WebSocketChannel.connect(Uri.parse('ws://localhost:3000'));

    _subscription = channel.stream.listen((data) {
      add(UpdatePrice(data));
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    channel.sink.close();
    return super.close();
  }
}
