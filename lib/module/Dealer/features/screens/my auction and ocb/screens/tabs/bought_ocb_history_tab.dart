import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wheels_kart/common/components/app_empty_text.dart';
import 'package:wheels_kart/common/components/app_spacer.dart';
import 'package:wheels_kart/common/utils/routes.dart';
import 'package:wheels_kart/module/Dealer/core/components/v_loading.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_colors.dart';
import 'package:wheels_kart/module/Dealer/core/v_style.dart';
import 'package:wheels_kart/module/Dealer/features/screens/home/screens/car_details_screen.dart';
import 'package:wheels_kart/module/Dealer/features/screens/my%20auction%20and%20ocb/data/controller/ocb%20controller/my_ocb_controller_bloc.dart';
import 'package:wheels_kart/module/Dealer/features/screens/my%20auction%20and%20ocb/screens/v_mybid_screen.dart';
import 'package:wheels_kart/module/Dealer/features/widgets/ocb_tile.dart';

class BoughtOcbHistoryTab extends StatefulWidget {
  const BoughtOcbHistoryTab({super.key});

  @override
  State<BoughtOcbHistoryTab> createState() => _BoughtOcbHistoryTabState();
}

class _BoughtOcbHistoryTabState extends State<BoughtOcbHistoryTab> {
  @override
  void initState() {
    context.read<MyOcbControllerBloc>().add(OnFetchMyOCBList(context: context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyOcbControllerBloc, MyOcbControllerState>(
      builder: (context, state) {
        switch (state) {
          case MyOcbControllerErrorState():
            {
              return Center(child: AppEmptyText(text: state.error));
            }
          case MyOncControllerSuccessState():
            {
              final list = state.myOcbList;
              return list.isEmpty
                  ? Center(child: AppEmptyText(text: "No OCB Purchase found!"))
                  : ListView.separated(
                    itemCount: list.length,
                    separatorBuilder:
                        (context, index) => AppSpacer(heightPortion: .01),
                    padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                    itemBuilder: (context, index) {
                      final ocb = list[index];
                      return OcbTile( ocb:ocb);
                    },
                  );
            }
          default:
            {
              return Center(child: VLoadingIndicator());
            }
        }
      },
    );
  }
}
