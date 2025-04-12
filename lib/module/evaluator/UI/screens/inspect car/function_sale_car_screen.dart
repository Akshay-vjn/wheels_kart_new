// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:wheels_kart/core/constant/colors.dart';
// import 'package:wheels_kart/core/constant/dimensions.dart';
// import 'package:wheels_kart/core/constant/images.dart';
// import 'package:wheels_kart/core/constant/style.dart';
// import 'package:wheels_kart/core/utils/responsive_helper.dart';
// import 'package:wheels_kart/core/utils/routes.dart';
// import 'package:wheels_kart/module/evaluator/data/bloc/get%20data/fetch%20car%20make/fetch_car_make_bloc.dart';
// import 'package:wheels_kart/module/evaluator/data/model/evaluation_data_model.dart';
// import 'package:wheels_kart/module/evaluator/UI/screens/inspect%20car/fill%20basic%20details/2_select_and_search_manufacturing_year_selection.dart';
// import 'package:wheels_kart/module/evaluator/UI/screens/inspect%20car/fill%20basic%20details/1_select_and_search_car_makes.dart';
// import 'package:wheels_kart/core/components/app_custom_widgets.dart';
// import 'package:wheels_kart/core/components/app_loading_indicator.dart';
// import 'package:wheels_kart/core/components/app_margin.dart';
// import 'package:wheels_kart/core/components/app_spacer.dart';
// import 'package:cached_network_image/cached_network_image.dart';

// class EvSaleCarFunctionScreen extends StatefulWidget {
//   final String inspectionId;
//   const EvSaleCarFunctionScreen({super.key, required this.inspectionId});

//   @override
//   State<EvSaleCarFunctionScreen> createState() =>
//       _EvSaleCarFunctionScreenState();
// }

// class _EvSaleCarFunctionScreenState extends State<EvSaleCarFunctionScreen> {
//   @override
//   void initState() {
//     super.initState();
//     context.read<EvFetchCarMakeBloc>().add(
//       InitalFetchCarMakeEvent(context: context),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: customBackButton(context, color: AppColors.white),
//         title: Text(
//           'Choose Brand',
//           style: AppStyle.style(
//             context: context,
//             color: AppColors.white,
//             fontWeight: FontWeight.bold,
//             size: AppDimensions.fontSize18(context),
//           ),
//         ),
//       ),
//       body: AppMargin(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const AppSpacer(heightPortion: .03),
//             Container(
//               decoration: const BoxDecoration(
//                 image: DecorationImage(
//                   fit: BoxFit.fill,
//                   image: AssetImage(ConstImages.sellcCarImage),
//                 ),
//                 color: AppColors.DEFAULT_BLUE_DARK,
//                 borderRadius: BorderRadius.all(
//                   Radius.circular(AppDimensions.radiusSize18),
//                 ),
//               ),
//               height: 170,
//             ),
//             const AppSpacer(heightPortion: .05),
//             Text(
//               'Popular brands',
//               style: AppStyle.style(
//                 context: context,
//                 fontWeight: FontWeight.w600,
//                 size: AppDimensions.fontSize18(context),
//               ),
//             ),
//             const AppSpacer(heightPortion: .01),
//             BlocBuilder<EvFetchCarMakeBloc, EvFetchCarMakeState>(
//               builder: (context, state) {
//                 switch (state) {
//                   case FetchCarMakeLoadingState():
//                     {
//                       return Expanded(child: AppLoadingIndicator());
//                     }
//                   case FetchCarMakeSuccessState():
//                     {
//                       final data = state.carMakeData;

//                       return data.isEmpty
//                           ? const Center(child: Text('No Cars Found !'))
//                           : Column(
//                             children: [
//                               GridView.builder(
//                                 padding: const EdgeInsets.only(
//                                   bottom: AppDimensions.paddingSize5,
//                                 ),
//                                 physics: const NeverScrollableScrollPhysics(),
//                                 shrinkWrap: true,
//                                 itemCount: 6,
//                                 gridDelegate:
//                                     const SliverGridDelegateWithFixedCrossAxisCount(
//                                       crossAxisCount: 3,
//                                     ),
//                                 itemBuilder: (context, index) {
//                                   return InkWell(
//                                     overlayColor: const WidgetStatePropertyAll(
//                                       AppColors.kAppSecondaryColor,
//                                     ),
//                                     onTap: () {
//                                       Navigator.of(context).push(
//                                         AppRoutes.createRoute(
//                                           EvSelectAndSeachManufacturingYear(
//                                             evaluationDataEntryModel:
//                                                 EvaluationDataEntryModel(
//                                                   inspectionId:
//                                                       widget.inspectionId,
//                                                   carMake: data[index].makeName,
//                                                   makeId: data[index].makeId,
//                                                 ),
//                                           ),
//                                         ),
//                                       );
//                                     },
//                                     child: Card(
//                                       color: AppColors.white,
//                                       child: Center(
//                                         child: Column(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceEvenly,
//                                           children: [
//                                             SizedBox(
//                                               width: w(context),
//                                               height: h(context) * .05,
//                                               child: Center(
//                                                 child: CachedNetworkImage(
//                                                   errorListener: (value) {
//                                                     // log(value.toString());
//                                                   },
//                                                   errorWidget:
//                                                       (
//                                                         context,
//                                                         path,
//                                                         error,
//                                                       ) => Text(
//                                                         '(Image Not Found)',
//                                                         textAlign:
//                                                             TextAlign.center,
//                                                         style: AppStyle.style(
//                                                           color: AppColors.grey,
//                                                           size:
//                                                               AppDimensions.fontSize10(
//                                                                 context,
//                                                               ),
//                                                           context: context,
//                                                         ),
//                                                       ),
//                                                   imageUrl: data[index].logo,
//                                                 ),
//                                               ),
//                                             ),
//                                             Text(
//                                               data[index].makeName,
//                                               style: AppStyle.style(
//                                                 context: context,
//                                                 fontWeight: FontWeight.bold,
//                                                 letterSpacing: .5,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               ),
//                               Align(
//                                 alignment: Alignment.bottomRight,
//                                 child: TextButton(
//                                   onPressed: () {
//                                     Navigator.of(context).push(
//                                       AppRoutes.createRoute(
//                                         EvSelectAndSearchCarMakes(
//                                           inspectuionId: widget.inspectionId,
//                                           listofCarMake: state.carMakeData,
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                   child: Text(
//                                     'See All',
//                                     style: AppStyle.style(
//                                       fontWeight: FontWeight.w600,
//                                       context: context,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           );
//                     }

//                   case FetchCarMakeErrorState():
//                     {
//                       return SizedBox(
//                         height: h(context) * .2,
//                         child: Center(child: Text(state.errorData)),
//                       );
//                     }

//                   default:
//                     {
//                       return SizedBox(
//                         height: h(context) * .2,
//                         child: const Center(child: Text('Please wait...')),
//                       );
//                     }
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
