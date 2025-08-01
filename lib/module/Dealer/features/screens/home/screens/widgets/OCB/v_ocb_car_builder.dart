import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:wheels_kart/common/components/app_empty_text.dart';
import 'package:wheels_kart/common/controllers/auth%20cubit/auth_cubit.dart';
import 'package:wheels_kart/common/utils/responsive_helper.dart';
import 'package:wheels_kart/module/Dealer/core/components/v_loading.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_colors.dart';
import 'package:wheels_kart/module/Dealer/core/v_style.dart';
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
    context.read<VOcbControllerBloc>().add(OnFechOncList(context: context));

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
                child: Stack(
                  alignment: Alignment.bottomCenter,

                  children: [
                    SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.only(top: 10),
                      child:
                          carList.isEmpty
                              ? AppEmptyText(text: "No OCB cars found!")
                              : AnimationLimiter(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children:
                                      AnimationConfiguration.toStaggeredList(
                                        duration: const Duration(
                                          milliseconds: 375,
                                        ),
                                        childAnimationBuilder:
                                            (p0) => SlideAnimation(
                                              horizontalOffset: 50.0,
                                              child: FadeInAnimation(child: p0),
                                            ),
                                        children:
                                            carList
                                                .map(
                                                  (e) => VOcbCarCard(
                                                    myId: myId,
                                                    vehicle: e,
                                                  ),
                                                )
                                                .toList(),
                                      ),
                                ),
                              ),
                    ),
                    state.enableRefreshButton
                        ? ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: VColors.SECONDARY,
                          ),
                          label: Text(
                            'New OCB',
                            style: VStyle.style(
                              context: context,
                              fontWeight: FontWeight.bold,
                              size: 15,
                            ),
                          ),
                          icon: Icon(Icons.keyboard_double_arrow_up_rounded),
                          onPressed: () {
                            return context.read<VOcbControllerBloc>().add(
                              OnFechOncList(context: context),
                            );
                          },
                        )
                        : SizedBox.shrink(),
                  ],
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
