// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:wheels_kart/core/components/app_custom_widgets.dart';
// import 'package:wheels_kart/core/components/app_empty_text.dart';
// import 'package:wheels_kart/core/components/app_loading_indicator.dart';
// import 'package:wheels_kart/core/components/app_margin.dart';
// import 'package:wheels_kart/core/components/app_spacer.dart';
// import 'package:wheels_kart/core/constant/colors.dart';
// import 'package:wheels_kart/core/constant/dimensions.dart';
// import 'package:wheels_kart/core/constant/style.dart';
// import 'package:wheels_kart/core/paint/dash_border.dart';
// import 'package:wheels_kart/core/utils/responsive_helper.dart';
// import 'package:wheels_kart/core/utils/routes.dart';
// import 'package:wheels_kart/module/evaluator/UI/screens/inspect%20car/upload%20vehilce%20photo/upload_vehilce_photo_screen.dart';
// import 'package:wheels_kart/module/evaluator/data/bloc/get%20data/fetch_vehilce_photo/fetch_uploaded_vehilce_photos_cubit.dart';
// import 'package:wheels_kart/module/evaluator/data/model/vehicle_photo_model.dart';

// class ViewUploadedVihilcePhotosScreen extends StatefulWidget {
//   final String inspectionId;
//   const ViewUploadedVihilcePhotosScreen({
//     super.key,
//     required this.inspectionId,
//   });

//   @override
//   State<ViewUploadedVihilcePhotosScreen> createState() =>
//       _ViewUploadedVihilcePhotosScreenState();
// }

// class _ViewUploadedVihilcePhotosScreenState
//     extends State<ViewUploadedVihilcePhotosScreen> {
//   @override
//   void initState() {
//     context.read<FetchUploadedVehilcePhotosCubit>().onFetchUploadVehiclePhotos(
//       context,
//       widget.inspectionId,
//     );
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: customBackButton(context),
//         title: Text(
//           "Upload Vehicle Photos",
//           style: AppStyle.style(
//             context: context,
//             color: AppColors.white,
//             size: AppDimensions.fontSize18(context),
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),
//       body: BlocBuilder<
//         FetchUploadedVehilcePhotosCubit,
//         FetchUploadedVehilcePhotosState
//       >(
//         builder: (context, state) {
//           switch (state) {
//             case FetchUploadedVehilcePhotosLoadingState():
//               {
//                 return AppLoadingIndicator();
//               }
//             case FetchUploadedVehilcePhotosErrorState():
//               {
//                 return AppEmptyText(text: state.errorMessage);
//               }
//             case FetchUploadedVehilcePhotosSuccessSate():
//               {
//                 return Center(
//                   child:
//                       state.vehiclePhtotos.isEmpty
//                           ? _buildNoPhotosUi()
//                           : _buildData(state.vehiclePhtotos),
//                 );
//               }
//             default:
//               {
//                 return SizedBox();
//               }
//           }
//         },
//       ),
//     );
//   }

//   Widget _buildNoPhotosUi() {
//     return AppMargin(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           InkWell(
//             onTap: () {
//               Navigator.of(context).push(
//                 AppRoutes.createRoute(
//                   UploadVehilcePhotoScreen(inspectionId: widget.inspectionId),
//                 ),
//               );
//             },
//             child: CustomPaint(
//               foregroundPainter: DashedBorderPainter(),
//               child: SizedBox(
//                 width: w(context) * .5,

//                 height: w(context) * .5,
//                 child: Icon(Icons.add, color: AppColors.grey, size: 100),
//               ),
//             ),
//           ),
//           AppSpacer(heightPortion: .06),
//           Text(
//             textAlign: TextAlign.center,
//             "You haven't uploaded any photos yet!",
//             style: AppStyle.style(
//               context: context,
//               color: AppColors.black2,
//               fontWeight: FontWeight.w400,
//               size: 20,
//             ),
//           ),
//           Text(
//             textAlign: TextAlign.center,
//             "Please upload your vehicle photos from different angles.",
//             style: AppStyle.style(
//               context: context,
//               color: AppColors.black2,
//               fontWeight: FontWeight.w400,
//               size: 15,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildData(List<VehiclePhotoModel> data) {
//     return Column(
//       children: [
//         Expanded(
//           child: AppMargin(
//             child: GridView.builder(
//               padding: EdgeInsets.only(top: 10),
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisSpacing: 5,
//                 mainAxisSpacing: 10,
//                 crossAxisCount: 2,
//               ),
//               itemCount: data.length + 1,
//               itemBuilder: (context, index) {
//                 if (index == data.length) {
//                   return InkWell(
//                     onTap: () {
//                       Navigator.of(context).push(
//                         AppRoutes.createRoute(
//                           UploadVehilcePhotoScreen(
//                             inspectionId: widget.inspectionId,
//                           ),
//                         ),
//                       );
//                     },
//                     child: CustomPaint(
//                       painter: DashedBorderPainter(),
//                       child: Icon(Icons.add, color: AppColors.grey, size: 50),
//                     ),
//                   );
//                 }
//                 return Stack(
//                   children: [
//                     Container(
//                       decoration: BoxDecoration(
//                         border: Border.all(color: AppColors.BORDER_COLOR),
//                       ),
//                       child: Column(
//                         children: [
//                           // AppSpacer(heightPortion: .01),
//                           Expanded(
//                             child: CachedNetworkImage(
//                               errorListener: (value) {},
//                               errorWidget:
//                                   (context, url, error) => Text("No Image"),
//                               imageUrl: data[index].picture,
//                             ),
//                           ),
//                           AppSpacer(heightPortion: .01),
//                           Container(
//                             padding: EdgeInsets.all(3),
//                             alignment: Alignment.center,
//                             width: w(context),
//                             decoration: BoxDecoration(
//                               color: AppColors.DEFAULT_BLUE_DARK,
//                             ),
//                             child: Text(
//                               textAlign: TextAlign.center,
//                               data[index].description,
//                               style: AppStyle.style(
//                                 color: AppColors.white,
//                                 context: context,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Positioned(
//                       left: 10,
//                       top: 10,
//                       child: InkWell(
//                         onTap: () {
//                           context
//                               .read<FetchUploadedVehilcePhotosCubit>()
//                               .deleteImage(
//                                 context,
//                                 widget.inspectionId,
//                                 data[index].pictureId,
//                               );
//                         },
//                         child: Container(
//                           padding: EdgeInsets.symmetric(
//                             horizontal: 6,
//                             vertical: 5,
//                           ),

//                           decoration: BoxDecoration(
//                             color: AppColors.white,
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: Text(
//                             "Remove",
//                             style: AppStyle.style(context: context),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 );
//               },
//             ),
//           ),
//         ),
      
//       ],
//     );
//   }
// }
