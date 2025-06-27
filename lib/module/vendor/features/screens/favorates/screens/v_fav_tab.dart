import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wheels_kart/common/components/app_empty_text.dart';
import 'package:wheels_kart/common/components/app_margin.dart';
import 'package:wheels_kart/common/components/app_spacer.dart';
import 'package:wheels_kart/common/dimensions.dart';
import 'package:wheels_kart/module/VENDOR/core/components/v_loading.dart';
import 'package:wheels_kart/module/VENDOR/core/v_style.dart';
import 'package:wheels_kart/module/VENDOR/features/screens/favorates/data/controller/wishlist%20controller/v_wishlist_controller_cubit.dart';
import 'package:wheels_kart/module/VENDOR/features/screens/favorates/widgets/whishlist_card.dart';
import 'package:wheels_kart/module/vendor/core/const/v_colors.dart';

class VFavTab extends StatefulWidget {
  const VFavTab({super.key});
  @override
  State<VFavTab> createState() => _VFavTabState();
}

class _VFavTabState extends State<VFavTab> {
  @override
  void initState() {
    context.read<VWishlistControllerCubit>().onFetchWishList(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<VWishlistControllerCubit, VWishlistControllerState>(
        builder: (context, state) {
          switch (state) {
            case VWishlistControllerSuccessState():
              {
                return state.myWishList.isEmpty
                    ? AppEmptyText(text: "Nothing is found in your list")
                    : ListView.separated(
                      padding: EdgeInsets.only(top: 10),
                      separatorBuilder:
                          (context, index) => AppSpacer(heightPortion: .02),
                      itemCount: state.myWishList.length,
                      itemBuilder: (context, index) {
                        return AppMargin(
                          child: VWhishlistCard(model: state.myWishList[index]),
                        );
                      },
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
