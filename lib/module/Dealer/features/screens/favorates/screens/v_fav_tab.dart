import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:wheels_kart/common/components/app_empty_text.dart';
import 'package:wheels_kart/common/components/app_margin.dart';
import 'package:wheels_kart/common/controllers/auth%20cubit/auth_cubit.dart';
import 'package:wheels_kart/module/Dealer/core/components/v_loading.dart';
import 'package:wheels_kart/module/Dealer/features/screens/favorates/data/controller/wishlist%20controller/v_wishlist_controller_cubit.dart';
import 'package:wheels_kart/module/Dealer/features/screens/favorates/widgets/whishlist_card.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/data/model/v_car_model.dart';
import 'package:wheels_kart/module/Dealer/features/v_nav_screen.dart';

class VFavTab extends StatefulWidget {
  const VFavTab({super.key});
  @override
  State<VFavTab> createState() => _VFavTabState();
}

class _VFavTabState extends State<VFavTab> {
  late final VWishlistControllerCubit _wishlistCubit;

  @override
  void initState() {
    _wishlistCubit = context.read<VWishlistControllerCubit>();
    _wishlistCubit.connectWebSocket();
    _wishlistCubit.onFetchWishList(context);
    // _getMyId();

    super.initState();
  }

  // String myId = "";
  // Future<void> _getMyId() async {
  //   final userData = await context.read<AppAuthController>().getUserData;
  //   myId = userData.userId ?? '';
  // }

  List<VCarModel> likedList = [];
  @override
  void dispose() {
    _wishlistCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<VWishlistControllerCubit, VWishlistControllerState>(
        builder: (context, state) {
          switch (state) {
            case VWishlistControllerSuccessState():
              {
                likedList = state.myWishList;
                return state.myWishList.isEmpty
                    ? AppEmptyText(
                      text: "Nothing is found in your list",
                      showIcon: true,
                    )
                    : AnimationLimiter(
                      child: ListView.builder(
                        padding: EdgeInsets.only(top: 10),

                        itemCount: likedList.length,
                        itemBuilder: (context, index) {
                          return AppMargin(
                            child: AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 375),

                              child: SlideAnimation(
                                verticalOffset: 50.0,

                                child: FadeInAnimation(
                                  child: VWhishlistCard(
                                    myId: CURRENT_DEALER_ID,
                                    onPressFavoureButton: () async {
                                      HapticFeedback.lightImpact();
                                      await context
                                          .read<VWishlistControllerCubit>()
                                          .onChangeFavState(
                                            context,
                                            likedList[index].inspectionId,
                                            fetch: false,
                                          );
                                      likedList.removeAt(index);
                                      setState(() {});
                                    },
                                    model: likedList[index],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
              }
            case VWishlistControllerErrorState():
              {
                return Center(child: AppEmptyText(text: state.error));
              }
            default:
              {
                return Center(child: VLoadingIndicator());
              }
          }
        },
      ),
    );
  }
}
