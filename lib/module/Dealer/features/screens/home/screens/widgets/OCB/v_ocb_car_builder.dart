import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:wheels_kart/common/components/app_empty_text.dart';
import 'package:wheels_kart/common/controllers/auth%20cubit/auth_cubit.dart';
import 'package:wheels_kart/common/utils/responsive_helper.dart';
import 'package:wheels_kart/module/Dealer/core/components/v_loading.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/controller/ocb%20controller/v_ocb_controller_bloc.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/screens/widgets/OCB/v_ocb_car_card.dart';

class VOCBCarBuilder extends StatefulWidget {
  const VOCBCarBuilder({super.key});

  @override
  State<VOCBCarBuilder> createState() => _VOCBCarBuilderState();
}

class _VOCBCarBuilderState extends State<VOCBCarBuilder> {
  @override
  void initState() {
    // WEB SOCKET COONECTION
    context.read<VOcbControllerBloc>().add(ConnectWebSocket());
    _getMyId();
    super.initState();
  }

  String myId = "";
  Future<void> _getMyId() async {
    final userData = await context.read<AppAuthController>().getUserData;
    myId = userData.userId ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VOcbControllerBloc, VOcbControllerState>(
      builder: (context, state) {
        switch (state) {
          case VOcbControllerErrorState():
            {
              return Center(child: AppEmptyText(text: state.errorMesage));
            }
          case VOcbControllerSuccessState():
            {
              final carList = state.listOfCars;

              return RefreshIndicator.adaptive(
                onRefresh: () async {
                  return context.read<VOcbControllerBloc>().add(
                    OnFechOncList(context: context),
                  );
                },
                child: AnimationLimiter(
                  child: ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.only(top: 10),
                    itemCount: carList.length,
                    itemBuilder:
                        (context, index) =>
                            AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 375),
                              child: SlideAnimation(
                                verticalOffset: 50.0,
                                child: FadeInAnimation(
                                  child: VOcbCarCard(
                                    myId: myId,
                                    vehicle: carList[index],
                                  ),
                                ),
                              ),
                            ),
                  ),
                ),
              );
            }
          default:
            {
              return SizedBox(
                height: h(context) * .7,
                child: Center(child: VLoadingIndicator()),
              );
            }
        }
      },
    );
  }
}
