// import 'dart:convert';
// import 'dart:io';

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:image/image.dart' as img;
// import 'package:wheels_kart/common/utils/responsive_helper.dart';

// import 'package:wheels_kart/module/EVALAUATOR/core/ev_colors.dart';
// import 'package:wheels_kart/common/dimensions.dart';
// import 'package:wheels_kart/module/EVALAUATOR/core/ev_style.dart';
// import 'package:wheels_kart/module/EVALAUATOR/data/bloc/get%20data/fetch%20picture%20angles/fetch_picture_angles_cubit.dart';
// import 'package:wheels_kart/module/EVALAUATOR/data/bloc/get%20data/fetch_vehilce_photo/fetch_uploaded_vehilce_photos_cubit.dart';
// import 'package:wheels_kart/module/EVALAUATOR/data/bloc/upload%20vehilce%20photo/uplaod_vehilce_photo_cubit.dart';
// import 'package:wheels_kart/module/EVALAUATOR/features/widgets/ev_app_loading_indicator.dart';

// class UploadVehiclePhotos extends StatefulWidget {
//   final String inspectionId;
//   const UploadVehiclePhotos({super.key, required this.inspectionId});

//   @override
//   State<UploadVehiclePhotos> createState() => _UploadVehiclePhotosState();
// }

// class _UploadVehiclePhotosState extends State<UploadVehiclePhotos>
//     with TickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;
//   late Animation<Offset> _slideAnimation;
//   ScrollController _scrollController = ScrollController();
//   @override
//   void initState() {
//     super.initState();

//     // Animation setup
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );

//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     );

//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(0, 0.3),
//       end: Offset.zero,
//     ).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
//     );

//     // Bloc initialization
//     context.read<UplaodVehilcePhotoCubit>().onClearAll();
//     context.read<FetchPictureAnglesCubit>().onFetchPictureAngles(context);
//     context.read<FetchUploadedVehilcePhotosCubit>().onFetchUploadVehiclePhotos(
//       context,
//       widget.inspectionId,
//     );

//     _animationController.forward();

//     // _scrollControllerd.addListener(() {});
//   }

//   void _scrollToLast() {
//     _scrollController.animateTo(
//       _scrollController.position.maxScrollExtent,
//       duration: const Duration(milliseconds: 300),
//       curve: Curves.easeInOut,
//     );
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     // descriptionController.dispose();
//     super.dispose();
//   }

//   // final descriptionController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: _buildAppBar(context),
//       body: _buildBody(),
//     );
//   }

//   PreferredSizeWidget _buildAppBar(BuildContext context) {
//     return AppBar(
//       elevation: 0,
//       backgroundColor: Colors.white,
//       leading: Container(
//         margin: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           color: Colors.grey[100],
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//       ),
//       centerTitle: true,
//       title: Text(
//         "Upload Vehicle Photos",
//         style: EvAppStyle.style(
//           context: context,
//           color: Colors.black87,
//           size: AppDimensions.fontSize18(context),
//           fontWeight: FontWeight.w700,
//         ),
//       ),
//       bottom: PreferredSize(
//         preferredSize: const Size.fromHeight(1),
//         child: Container(
//           height: 1,
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 Colors.transparent,
//                 Colors.grey[300]!,
//                 Colors.transparent,
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildBody() {
//     return BlocBuilder<FetchPictureAnglesCubit, FetchPictureAnglesState>(
//       builder: (context, angleState) {
//         switch (angleState) {
//           case FetchPictureAnglesLoadingState():
//             return _buildLoadingState();
//           case FetchPictureAnglesSuccessState():
//             return _buildSuccessState(angleState);
//           case FetchPictureAnglesErrorState():
//             return _buildErrorState(angleState.error);
//           default:
//             return _buildLoadingState();
//         }
//       },
//     );
//   }

//   Widget _buildLoadingState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           EVAppLoadingIndicator(),
//           const SizedBox(height: 16),
//           Text(
//             "Loading photo angles...",
//             style: EvAppStyle.poppins(
//               context: context,
//               size: AppDimensions.fontSize13(context),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildErrorState(String error) {
//     return Center(
//       child: Container(
//         margin: const EdgeInsets.all(24),
//         padding: const EdgeInsets.all(24),
//         decoration: BoxDecoration(
//           color: Colors.red[50],
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(color: Colors.red[200]!),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(Icons.error_outline, color: Colors.red[400], size: 48),
//             const SizedBox(height: 16),
//             Text(
//               "Something went wrong",
//               style: EvAppStyle.style(
//                 context: context,
//                 color: Colors.red[700],
//                 size: AppDimensions.fontSize16(context),
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               error,
//               textAlign: TextAlign.center,
//               style: EvAppStyle.style(
//                 context: context,
//                 color: Colors.red[600],
//                 size: AppDimensions.fontSize15(context),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSuccessState(FetchPictureAnglesSuccessState angleState) {
//     return BlocBuilder<
//       FetchUploadedVehilcePhotosCubit,
//       FetchUploadedVehilcePhotosState
//     >(
//       builder: (context, fetchUploadsState) {
//         if (fetchUploadsState is FetchUploadedVehilcePhotosErrorState) {
//           return _buildErrorState(fetchUploadsState.errorMessage);
//         } else if (fetchUploadsState
//             is FetchUploadedVehilcePhotosLoadingState) {
//           return _buildLoadingState();
//         } else if (fetchUploadsState is FetchUploadedVehilcePhotosSuccessSate) {
//           return _buildMainContent(angleState, fetchUploadsState);
//         }
//         return const SizedBox();
//       },
//     );
//   }

//   Widget _buildMainContent(
//     FetchPictureAnglesSuccessState angleState,
//     FetchUploadedVehilcePhotosSuccessSate fetchUploadsState,
//   ) {
//     return BlocBuilder<UplaodVehilcePhotoCubit, UplaodVehilcePhotoState>(
//       builder: (context, uploadState) {
//         return FadeTransition(
//           opacity: _fadeAnimation,
//           child: SlideTransition(
//             position: _slideAnimation,
//             child: SingleChildScrollView(
//               controller: _scrollController,
//               physics: const BouncingScrollPhysics(),
//               child: Container(
//                 margin: const EdgeInsets.all(16),
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _buildProgressIndicator(angleState, fetchUploadsState),
//                       const SizedBox(height: 24),
//                       _buildSectionTitle(
//                         "Select Photo Angle",
//                         Icons.camera_alt,
//                       ),
//                       const SizedBox(height: 16),
//                       _buildAngleSelector(
//                         angleState,
//                         fetchUploadsState,
//                         uploadState,
//                       ),
//                       const SizedBox(height: 32),
//                       _buildPhotoPreviewSection(
//                         angleState,
//                         fetchUploadsState,
//                         uploadState,
//                       ),
//                       const SizedBox(height: 24),
//                       // _buildDescriptionSection(fetchUploadsState, uploadState),
//                       // const SizedBox(height: 32),
//                       _buildActionButton(
//                         angleState,
//                         fetchUploadsState,
//                         uploadState,
//                       ),
//                       const SizedBox(height: 24),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildProgressIndicator(
//     FetchPictureAnglesSuccessState angleState,
//     FetchUploadedVehilcePhotosSuccessSate fetchUploadsState,
//   ) {
//     final totalAngles =
//         angleState.pictureAnglesByCategory.values
//             .expand((list) => list)
//             .toList()
//             .length;
//     // final totalAngles = angleState.pictureAngles.length;
//     final completedAngles = fetchUploadsState.vehiclePhtotos.length;
//     final progress = totalAngles > 0 ? completedAngles / totalAngles : 0.0;

//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [
//             EvAppColors.DEFAULT_BLUE_DARK.withOpacity(0.1),
//             Colors.white,
//           ],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.grey[200]!),
//       ),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 "Upload Progress",
//                 style: EvAppStyle.style(
//                   context: context,
//                   color: Colors.black87,
//                   size: AppDimensions.fontSize16(context),
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               Text(
//                 "$completedAngles / $totalAngles",
//                 style: EvAppStyle.style(
//                   context: context,
//                   color: EvAppColors.DEFAULT_BLUE_DARK,
//                   size: AppDimensions.fontSize15(context),
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           ClipRRect(
//             borderRadius: BorderRadius.circular(8),
//             child: LinearProgressIndicator(
//               value: progress,
//               backgroundColor: Colors.grey[300],
//               valueColor: AlwaysStoppedAnimation<Color>(
//                 progress == 1.0 ? Colors.green : EvAppColors.DEFAULT_BLUE_DARK,
//               ),
//               minHeight: 8,
//             ),
//           ),
//           if (progress == 1.0) ...[
//             const SizedBox(height: 12),
//             Row(
//               children: [
//                 Icon(Icons.check_circle, color: Colors.green, size: 16),
//                 const SizedBox(width: 8),
//                 Text(
//                   "All photos uploaded successfully!",
//                   style: EvAppStyle.style(
//                     context: context,
//                     color: Colors.green,
//                     size: AppDimensions.fontSize12(context),
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ],
//       ),
//     );
//   }

//   Widget _buildSectionTitle(String title, IconData icon) {
//     return Row(
//       children: [
//         Container(
//           padding: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: EvAppColors.DEFAULT_BLUE_DARK.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Icon(icon, color: EvAppColors.DEFAULT_BLUE_DARK, size: 20),
//         ),
//         const SizedBox(width: 12),
//         Text(
//           title,
//           style: EvAppStyle.style(
//             context: context,
//             color: Colors.black87,
//             size: AppDimensions.fontSize16(context),
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildAngleSelector(
//     FetchPictureAnglesSuccessState angleState,
//     FetchUploadedVehilcePhotosSuccessSate fetchUploadsState,
//     UplaodVehilcePhotoState uploadState,
//   ) {
//     final totalAngles =
//         angleState.pictureAnglesByCategory.values
//             .expand((list) => list)
//             .toList();
//     return Wrap(
//       alignment: WrapAlignment.start,
//       runSpacing: 12,
//       spacing: 12,
//       children:
//           totalAngles.asMap().entries.map((e) {
//             final isUploaded = fetchUploadsState.vehiclePhtotos.any(
//               (element) => element.angleId == e.value.angleId,
//             );
//             final isSelected = uploadState.selectedAngleId == e.value.angleId;

//             return AnimatedContainer(
//               duration: const Duration(milliseconds: 300),
//               curve: Curves.easeInOut,
//               child: Stack(
//                 clipBehavior: Clip.none,
//                 children: [
//                   InkWell(
//                     onTap: () async {
//                       HapticFeedback.selectionClick();
//                       context.read<UplaodVehilcePhotoCubit>().onSelectAngle(
//                         e.value.angleId,
//                       );

//                       WidgetsBinding.instance.addPostFrameCallback((_) {
//                         _scrollToLast();
//                       });
//                     },
//                     borderRadius: BorderRadius.circular(25),
//                     child: AnimatedContainer(
//                       duration: const Duration(milliseconds: 300),
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 12,
//                       ),
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           colors:
//                               isUploaded
//                                   ? [Colors.green, Colors.green[700]!]
//                                   : isSelected
//                                   ? [
//                                     EvAppColors.DEFAULT_ORANGE,
//                                     EvAppColors.DEFAULT_ORANGE.withOpacity(0.8),
//                                   ]
//                                   : [
//                                     EvAppColors.DEFAULT_BLUE_DARK,
//                                     EvAppColors.DEFAULT_BLUE_DARK.withOpacity(
//                                       0.8,
//                                     ),
//                                   ],
//                         ),
//                         borderRadius: BorderRadius.circular(25),
//                         boxShadow: [
//                           BoxShadow(
//                             color: (isUploaded
//                                     ? Colors.green
//                                     : isSelected
//                                     ? EvAppColors.DEFAULT_ORANGE
//                                     : EvAppColors.DEFAULT_BLUE_DARK)
//                                 .withOpacity(0.3),
//                             blurRadius: 8,
//                             offset: const Offset(0, 4),
//                           ),
//                         ],
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           if (isUploaded)
//                             const Icon(
//                               Icons.check_circle,
//                               color: Colors.white,
//                               size: 16,
//                             ),
//                           if (isUploaded) const SizedBox(width: 6),
//                           Text(
//                             e.value.angleName,
//                             style: EvAppStyle.poppins(
//                               context: context,
//                               color: Colors.white,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   if (isUploaded)
//                     Positioned(
//                       right: -6,
//                       top: -6,
//                       child: InkWell(
//                         onTap: () {
//                           _showDeleteConfirmation(
//                             context,
//                             fetchUploadsState,
//                             e.value.angleId,
//                           );
//                         },
//                         child: Container(
//                           padding: const EdgeInsets.all(4),
//                           decoration: const BoxDecoration(
//                             color: Colors.red,
//                             shape: BoxShape.circle,
//                           ),
//                           child: const Icon(
//                             Icons.close,
//                             color: Colors.white,
//                             size: 14,
//                           ),
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//             );
//           }).toList(),
//     );
//   }

//   Widget _buildPhotoPreviewSection(
//     FetchPictureAnglesSuccessState angleState,
//     FetchUploadedVehilcePhotosSuccessSate fetchUploadsState,
//     UplaodVehilcePhotoState uploadState,
//   ) {
//     return BlocBuilder<UplaodVehilcePhotoCubit, UplaodVehilcePhotoState>(
//       builder: (context, state) {
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildSectionTitle("Photo Preview", Icons.photo_camera),
//             const SizedBox(height: 16),
//             AnimatedContainer(
//               duration: const Duration(milliseconds: 300),
//               width: double.infinity,
//               height: MediaQuery.of(context).size.height * 0.35,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(
//                   color:
//                       uploadState.selectedAngleId != null
//                           ? EvAppColors.DEFAULT_BLUE_DARK
//                           : Colors.grey[300]!,
//                   width: 2,
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.05),
//                     blurRadius: 10,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(14),
//                 child:
//                     state is UplaodVehilcePhotoLoadingState
//                         ? EVAppLoadingIndicator()
//                         : _buildPhotoContent(
//                           angleState,
//                           fetchUploadsState,
//                           uploadState,
//                         ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildPhotoContent(
//     FetchPictureAnglesSuccessState angleState,
//     FetchUploadedVehilcePhotosSuccessSate fetchUploadsState,
//     UplaodVehilcePhotoState uploadState,
//   ) {
//     if (uploadState.selectedAngleId == null) {
//       return Container(
//         color: Colors.grey[50],
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(
//                 Icons.photo_camera_outlined,
//                 size: 64,
//                 color: Colors.grey[400],
//               ),
//               const SizedBox(height: 16),
//               Text(
//                 "Select an angle to begin",
//                 style: EvAppStyle.style(
//                   context: context,
//                   color: Colors.grey[600],
//                   size: AppDimensions.fontSize16(context),
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 "Choose a photo angle from above",
//                 style: EvAppStyle.style(
//                   context: context,
//                   color: Colors.grey[500],
//                   size: AppDimensions.fontSize12(context),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     if (uploadState.selectedImageFile != null) {
//       return Stack(
//         fit: StackFit.expand,
//         children: [
//           Image.file(uploadState.selectedImageFile!, fit: BoxFit.cover),
//           Positioned(
//             top: 12,
//             right: 12,
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//               decoration: BoxDecoration(
//                 color: Colors.black.withOpacity(0.7),
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Icon(Icons.photo_camera, color: Colors.white, size: 16),
//                   const SizedBox(width: 4),
//                   Text(
//                     "New Photo",
//                     style: EvAppStyle.style(
//                       context: context,
//                       color: Colors.white,
//                       size: AppDimensions.fontSize12(context),
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       );
//     }

//     final imageUrl =
//         fetchUploadsState.vehiclePhtotos.any(
//               (element) => element.angleId == uploadState.selectedAngleId,
//             )
//             ? fetchUploadsState.vehiclePhtotos
//                 .where(
//                   (element) => element.angleId == uploadState.selectedAngleId,
//                 )
//                 .first
//                 .picture
//             : angleState.pictureAnglesByCategory.values
//                 .expand((list) => list)
//                 .toList()
//                 .where(
//                   (element) => element.angleId == uploadState.selectedAngleId,
//                 )
//                 .first
//                 .samplePicture;

//     final isUploaded = fetchUploadsState.vehiclePhtotos.any(
//       (element) => element.angleId == uploadState.selectedAngleId,
//     );

//     return Stack(
//       fit: StackFit.expand,
//       children: [
//         CachedNetworkImage(
//           imageUrl: imageUrl,
//           fit: BoxFit.cover,
//           placeholder:
//               (context, url) => Container(
//                 color: Colors.grey[100],
//                 child: const Center(
//                   child: CircularProgressIndicator(strokeWidth: 2),
//                 ),
//               ),
//           errorWidget:
//               (context, url, error) => Container(
//                 color: Colors.grey[100],
//                 child: Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         Icons.broken_image,
//                         size: 48,
//                         color: Colors.grey[400],
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         "Failed to load image",
//                         style: EvAppStyle.style(
//                           context: context,
//                           color: Colors.grey[600],
//                           size: AppDimensions.fontSize12(context),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//         ),
//         Positioned(
//           top: 12,
//           left: 12,
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//             decoration: BoxDecoration(
//               color:
//                   isUploaded
//                       ? Colors.green.withOpacity(0.9)
//                       : Colors.blue.withOpacity(0.9),
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(
//                   isUploaded ? Icons.cloud_done : Icons.photo,
//                   color: Colors.white,
//                   size: 16,
//                 ),
//                 const SizedBox(width: 4),
//                 Text(
//                   isUploaded ? "Uploaded" : "Sample",
//                   style: EvAppStyle.style(
//                     context: context,
//                     color: Colors.white,
//                     size: AppDimensions.fontSize12(context),
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   // Widget _buildDescriptionSection(
//   //   FetchUploadedVehilcePhotosSuccessSate fetchUploadsState,
//   //   UplaodVehilcePhotoState uploadState,
//   // ) {
//   //   final hasUploadedPhoto = fetchUploadsState.vehiclePhtotos.any(
//   //     (element) => element.angleId == uploadState.selectedAngleId,
//   //   );

//   //   if (uploadState.selectedImageFile != null) {
//   //     return Column(
//   //       crossAxisAlignment: CrossAxisAlignment.start,
//   //       children: [
//   //         _buildSectionTitle("Add Description", Icons.description),
//   //         const SizedBox(height: 16),
//   //         Container(
//   //           decoration: BoxDecoration(
//   //             color: Colors.white,
//   //             borderRadius: BorderRadius.circular(12),
//   //             border: Border.all(color: Colors.grey[300]!),
//   //             boxShadow: [
//   //               BoxShadow(
//   //                 color: Colors.black.withOpacity(0.05),
//   //                 blurRadius: 5,
//   //                 offset: const Offset(0, 2),
//   //               ),
//   //             ],
//   //           ),
//   //           child: TextFormField(
//   //             controller: descriptionController,
//   //             maxLines: 3,
//   //             decoration: InputDecoration(
//   //               hintText:
//   //                   "Describe the photo details (damage, condition, etc.)",
//   //               hintStyle: EvAppStyle.style(
//   //                 context: context,
//   //                 color: Colors.grey[500],
//   //                 size: AppDimensions.fontSize15(context),
//   //               ),
//   //               border: InputBorder.none,
//   //               contentPadding: const EdgeInsets.all(16),
//   //             ),
//   //             validator: (value) {
//   //               if (value == null || value.trim().isEmpty) {
//   //                 return "Please add a description for this photo";
//   //               }
//   //               return null;
//   //             },
//   //           ),
//   //         ),
//   //       ],
//   //     );
//   //   }

//   //   if (hasUploadedPhoto) {
//   //     final description =
//   //         fetchUploadsState.vehiclePhtotos
//   //             .where(
//   //               (element) => element.angleId == uploadState.selectedAngleId,
//   //             )
//   //             .first
//   //             .description;

//   //     return Column(
//   //       crossAxisAlignment: CrossAxisAlignment.start,
//   //       children: [
//   //         _buildSectionTitle("Photo Description", Icons.description),
//   //         const SizedBox(height: 16),
//   //         Container(
//   //           width: double.infinity,
//   //           padding: const EdgeInsets.all(16),
//   //           decoration: BoxDecoration(
//   //             color: Colors.green[50],
//   //             borderRadius: BorderRadius.circular(12),
//   //             border: Border.all(color: Colors.green[200]!),
//   //           ),
//   //           child: Text(
//   //             description,
//   //             style: EvAppStyle.style(
//   //               context: context,
//   //               color: Colors.green[800],
//   //               size: AppDimensions.fontSize15(context),
//   //               fontWeight: FontWeight.w400,
//   //             ),
//   //           ),
//   //         ),
//   //       ],
//   //     );
//   //   }

//   //   return const SizedBox();
//   // }

//   Widget _buildActionButton(
//     FetchPictureAnglesSuccessState angleState,
//     FetchUploadedVehilcePhotosSuccessSate fetchUploadsState,
//     UplaodVehilcePhotoState uploadState,
//   ) {
//     if (uploadState.selectedAngleId == null) {
//       return const SizedBox();
//     }

//     final isUploading = uploadState is UplaodVehilcePhotoLoadingState;

//     return SizedBox(
//       width: double.infinity,
//       height: 56,
//       child: ElevatedButton(
//         onPressed:
//             isUploading
//                 ? null
//                 : () => _handleButtonPress(angleState, uploadState),
//         style: ElevatedButton.styleFrom(
//           backgroundColor:
//               uploadState.selectedImageFile == null
//                   ? EvAppColors.DEFAULT_BLUE_DARK
//                   : EvAppColors.DEFAULT_ORANGE,
//           foregroundColor: Colors.white,
//           elevation: 0,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           disabledBackgroundColor: Colors.grey[300],
//         ),
//         child:
//             isUploading
//                 ? const SizedBox(
//                   height: 24,
//                   width: 24,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 2,
//                     valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                   ),
//                 )
//                 : Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(
//                       uploadState.selectedImageFile == null
//                           ? Icons.camera_alt
//                           : Icons.cloud_upload,
//                       size: 24,
//                     ),
//                     const SizedBox(width: 12),
//                     Text(
//                       uploadState.selectedImageFile == null
//                           ? "Take Photo"
//                           : "Upload Photo",
//                       style: EvAppStyle.style(
//                         context: context,
//                         color: Colors.white,
//                         size: AppDimensions.fontSize16(context),
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 ),
//       ),
//     );
//   }

//   void _handleButtonPress(
//     FetchPictureAnglesSuccessState angleState,
//     UplaodVehilcePhotoState uploadState,
//   ) async {
//     if (uploadState.selectedImageFile == null) {
//       context.read<UplaodVehilcePhotoCubit>().onSelectImage(context);
//     } else {
//       if (_formKey.currentState!.validate()) {
//         final convertedImage = await convertFile(uploadState.selectedImageFile);
//         final totalAngles =
//             angleState.pictureAnglesByCategory.values
//                 .expand((list) => list)
//                 .toList();
//         final angleName =
//             totalAngles
//                 .where(
//                   (element) => element.angleId == uploadState.selectedAngleId,
//                 )
//                 .first
//                 .angleName;

//         Map<String, dynamic> json = {
//           "pictureType": "FINAL",
//           "pictureName": '$angleName-${widget.inspectionId}.jpg',
//           'angleId': uploadState.selectedAngleId,
//           'description': angleName,
//           'picture': convertedImage,
//         };

//         await context.read<UplaodVehilcePhotoCubit>().onUploadVehilcePhoto(
//           context,
//           widget.inspectionId,
//           json,
//         );

//         if (mounted) {
//           // descriptionController.clear();
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: const Text("Photo uploaded successfully!"),
//               backgroundColor: Colors.green,
//               behavior: SnackBarBehavior.floating,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//           );
//         }
//       }
//     }
//   }

//   void _showDeleteConfirmation(
//     BuildContext context,
//     FetchUploadedVehilcePhotosSuccessSate fetchUploadsState,
//     String angleId,
//   ) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           title: Row(
//             children: [
//               Icon(
//                 Icons.warning_amber_rounded,
//                 color: Colors.orange[600],
//                 size: 28,
//               ),
//               const SizedBox(width: 12),
//               const Text("Delete Photo"),
//             ],
//           ),
//           content: const Text(
//             "Are you sure you want to delete this photo? This action cannot be undone.",
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: Text("Cancel", style: TextStyle(color: Colors.grey[600])),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 final pictureId =
//                     fetchUploadsState.vehiclePhtotos
//                         .where((element) => element.angleId == angleId)
//                         .first
//                         .pictureId;

//                 await context
//                     .read<FetchUploadedVehilcePhotosCubit>()
//                     .deleteImage(context, widget.inspectionId, pictureId);
//                 Navigator.of(context).pop();
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.red,
//                 foregroundColor: Colors.white,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               child: const Text("Delete"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Future<String> convertFile(File? file) async {
//     if (file == null) return '';
//     final bytes = await file.readAsBytes();
//     img.Image? image = img.decodeImage(bytes);
//     if (image == null) {
//       throw Exception("Unable to decode image");
//     }
//     if (image.width > 800) {
//       image = img.copyResize(image, width: 800);
//     }
//     final compressed = img.encodeJpg(image, quality: 80);
//     return base64Encode(compressed);
//   }
// }