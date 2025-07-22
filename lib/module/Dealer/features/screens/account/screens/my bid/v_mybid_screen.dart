import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wheels_kart/common/components/app_margin.dart';
import 'package:wheels_kart/common/components/app_spacer.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_colors.dart';
import 'package:wheels_kart/module/Dealer/core/v_style.dart';
import 'package:wheels_kart/module/Dealer/features/widgets/v_custom_backbutton.dart';

class VMybidScreen extends StatefulWidget {
  const VMybidScreen({super.key});

  @override
  State<VMybidScreen> createState() => _VMybidScreenState();
}

class _VMybidScreenState extends State<VMybidScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: DefaultTabController(
          length: 3,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  VCustomBackbutton(blendColor: VColors.GREY),
                  // Text(
                  //   "Bid History",
                  //   style: VStyle.style(
                  //     context: context,
                  //     fontWeight: FontWeight.bold,
                  //     size: 13
                  //   ),
                  // ),
                  AppSpacer(widthPortion: .02),
                  Flexible(
                    child: TabBar(
                      controller: _tabController,
                      tabAlignment: TabAlignment.center,
                      // indicatorSize: TabBarIndicatorSize.tab,
                      indicatorColor: VColors.SECONDARY,
                      labelStyle: VStyle.style(
                        color: VColors.SECONDARY,
                        context: context,
                        fontWeight: FontWeight.w900,
                        size: 10,
                      ),
                      unselectedLabelStyle: VStyle.style(
                        size: 10,
                        context: context,
                        fontWeight: FontWeight.w300,
                      ),
                      dividerHeight: 0,
                      tabs: [
                        Padding(
                          padding: EdgeInsetsGeometry.only(bottom: 10),
                          child: Text("Hightlist"),
                        ),
                        Padding(
                          padding: EdgeInsetsGeometry.only(bottom: 10),
                          child: Text("Lowlist"),
                        ),
                        Padding(
                          padding: EdgeInsetsGeometry.only(bottom: 10),
                          child: Text('Bought (OCB)'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [_buildHighList(), _buildLowList(), _buildBought()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHighList() {
    return SizedBox();
  }

  Widget _buildLowList() {
    return SizedBox();
  }

  Widget _buildBought() {
    return SizedBox();
  }
}
