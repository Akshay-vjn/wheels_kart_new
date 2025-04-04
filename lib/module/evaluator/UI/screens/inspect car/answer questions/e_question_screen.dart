// import 'dart:io';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:percent_indicator/circular_percent_indicator.dart';
// import 'package:wheels_kart/core/components/app_custom_widgets.dart';
// import 'package:wheels_kart/core/components/app_empty_text.dart';
// import 'package:wheels_kart/core/components/app_loading_indicator.dart';
// import 'package:wheels_kart/core/components/app_margin.dart';
// import 'package:wheels_kart/core/components/app_spacer.dart';
// import 'package:wheels_kart/core/constant/colors.dart';
// import 'package:wheels_kart/core/constant/dimensions.dart';
// import 'package:wheels_kart/core/constant/style.dart';
// import 'package:wheels_kart/core/utils/responsive_helper.dart';
// import 'package:wheels_kart/module/evaluator/data/bloc/get%20data/fetch%20questions/fetch_questions_bloc.dart';
// import 'package:wheels_kart/module/evaluator/data/cubit/common%20controll/ev_common_controll_cubit.dart';
// import 'package:wheels_kart/module/evaluator/data/model/question_model_data.dart';
// import 'package:wheels_kart/module/evaluator/data/model/upload_inspection_model.dart';
// import 'package:wheels_kart/module/evaluator/UI/widgets/app_custom_textfield.dart';

// class EvQuestionScreen extends StatefulWidget {
//   final String portionId;
//   final String systemId;
//   final String inspectionId;
//   const EvQuestionScreen(
//       {super.key,
//       required this.portionId,
//       required this.systemId,
//       required this.inspectionId});

//   @override
//   State<EvQuestionScreen> createState() => _EvQuestionScreenState();
// }

// class _EvQuestionScreenState extends State<EvQuestionScreen> {
//   //
//   int selectedDropdownIndex = 0;
//   //
//   List<File> listOfImages = [];
//   String? selectedMainOption;
//   String? selectedInvalidOption;
//   String? selectedSubQuestionOption;
//   String? selectedValidOption;

//   final descriptiveController = TextEditingController();
//   final commnetControoller = TextEditingController();
//   final _formKeyForTextField = GlobalKey<FormState>();
//   final _formKeyForcommentField = GlobalKey<FormState>();

//   void _openCamera() async {
//     final imagepicker = ImagePicker();
//     final pickedXfile = await imagepicker.pickImage(source: ImageSource.camera);
//     if (pickedXfile != null) {
//       setState(() {
//         listOfImages.add(File(pickedXfile.path));
//       });
//     }
//   }

//   Future<bool> checkTheCurrentQuestionIsFullAnsweresOrNot(
//       QuestionModelData model) async {
//     QuestionModelData currentQuestionModel = model;
//     bool isMcq = currentQuestionModel.questionType == 'MCQ' ? true : false;
//     bool? pictureIsOptional;
//     if (currentQuestionModel.picture == 'Required Optional') {
//       pictureIsOptional = true;
//     } else if (currentQuestionModel.picture == 'Required Mandatory') {
//       pictureIsOptional = false;
//     }
//     return await _goNext(
//         isMcq, pictureIsOptional, currentQuestionModel.questionId, isMcq);
//   }

//   Future<bool> _goNext(bool isMcq, bool? pictureIsOptional, dynamic questionId,
//       bool isMacq) async {
//     bool goNext = false;
//     if (isMcq) {
//       if (selectedMainOption != null) {
//         if (pictureIsOptional == null || pictureIsOptional == true) {
//           goNext = true;
//         } else {
//           if (listOfImages.isEmpty) {
//             _showMessage('Upload atleast one image');
//             goNext = false;
//           } else {
//             goNext = true;
//           }
//         }
//       } else {
//         _showMessage('Before procceed, select the answer');
//         goNext = false;
//       }
//     } else {
//       if (_formKeyForTextField.currentState!.validate() &&
//           _formKeyForcommentField.currentState!.validate()) {
//         if (pictureIsOptional == null || pictureIsOptional == true) {
//           goNext = true;
//         } else {
//           if (listOfImages.isEmpty) {
//             _showMessage('Upload atleast one image');
//             goNext = false;
//           } else {
//             goNext = true;
//           }
//         }
//       }
//     }
//     if (goNext) {
//       final value =
//           await context.read<EvCommonControllCubit>().uploadInspection(
//               listOfImages,
//               context,
//               UploadInspectionModel(
//                 inspectionId: widget.inspectionId,
//                 questionId: questionId,
//                 answer: isMcq ? selectedMainOption : descriptiveController.text,
//                 invalidOption: selectedInvalidOption,
//                 subQuestionAnswer: selectedSubQuestionOption,
//                 validOption: selectedValidOption,
//                 comment: commnetControoller.text.isNotEmpty
//                     ? commnetControoller.text
//                     : null,
//               ));

//       if (value == false) {
//         return false;
//       } else {
//         _clearControll();
//         return true;
//       }
//     } else {
//       return false;
//     }
//   }

//   void _clearControll() {
//     listOfImages = [];
//     descriptiveController.clear();
//     commnetControoller.clear();
//     selectedMainOption = null;
//     selectedInvalidOption = null;
//     selectedSubQuestionOption = null;
//     selectedValidOption = null;
//     context.read<EvCommonControllCubit>().clearImages();
//   }

//   void _loadData() {
//     context.read<FetchQuestionsBloc>().add(OnCallQuestinApiRepoEvent(
//         context: context,
//         postionId: widget.portionId,
//         systemId: widget.systemId));
//   }

//   @override
//   void initState() {
//     super.initState();
//     _loadData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: customBackButton(
//           context,
//         ),
//         title: Text(
//           'Answer the Questions',
//           style: AppStyle.poppinsStyle(
//               context: context,
//               color: AppColors.kWhite,
//               fontWeight: FontWeight.bold,
//               size: AppDimensions.fontSize18(context)),
//         ),
//         backgroundColor: AppColors.kAppPrimaryColor,
//         actions: [
//           TextButton(
//               onPressed: () {
//                 final state =
//                     BlocProvider.of<FetchQuestionsBloc>(context, listen: false)
//                         .state;

//                 if (state is SuccessFetchQuestionsState) {
//                   _clearControll();
//                   context.read<FetchQuestionsBloc>().add(OnPressNextButtonEvent(
//                       nextQuestionIndex: state.currentIndexOfQuestion + 1,
//                       context: context));
//                 }
//               },
//               child: Text(
//                 'Skip',
//                 style: AppStyle.opensansStyle(
//                     decoration: TextDecoration.underline,
//                     context: context,
//                     color: AppColors.kWhite,
//                     fontWeight: FontWeight.bold,
//                     size: AppDimensions.fontSize16(context)),
//               ))
//         ],
//         bottom: PreferredSize(
//           preferredSize: Size.fromHeight(h(context) * .1),
//           child: Builder(
//             builder: (context) {
//               final state =
//                   BlocProvider.of<FetchQuestionsBloc>(context, listen: true)
//                       .state;
//               if (state is SuccessFetchQuestionsState) {
//                 return Padding(
//                   padding: EdgeInsets.symmetric(
//                       horizontal: AppDimensions.paddingSize10,
//                       vertical: AppDimensions.paddingSize15),
//                   child: DropdownButtonFormField(
//                       // padding: EdgeInsets.all(20),
//                       isExpanded: true,
//                       dropdownColor: AppColors.kAppSecondaryColor,
//                       icon: Icon(
//                         CupertinoIcons.chevron_down,
//                         size: 15,
//                         color: AppColors.kWhite,
//                       ),
//                       value: state.listOfQuestions[state.currentIndexOfQuestion]
//                           .question,
//                       style: AppStyle.opensansStyle(
//                           context: context, fontWeight: FontWeight.bold),
//                       decoration:
//                           AppStyle.dropdownDecoration(isBorderWhite: true),
//                       items: state.listOfQuestions
//                           .asMap()
//                           .entries
//                           .map((e) => DropdownMenuItem(
//                               onTap: () {
//                                 selectedDropdownIndex = e.key;
//                               },
//                               value: e.value.question,
//                               child: SizedBox(
//                                 width: w(context) * .7,
//                                 child: Text(
//                                   '${e.key + 1} - ${e.value.question}',
//                                   style: AppStyle.opensansStyle(
//                                       context: context,
//                                       fontWeight: FontWeight.bold,
//                                       color: AppColors.kWhite),
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               )))
//                           .toList(),
//                       onChanged: (value) {
//                         _clearControll();
//                         context.read<FetchQuestionsBloc>().add(
//                             OnPressTheDropDownItem(
//                                 pressedQuestionIndex: selectedDropdownIndex));
//                       }),
//                 );
//               } else {
//                 return SizedBox();
//               }
//             },
//           ),
//         ),
//       ),
//       body: BlocConsumer<FetchQuestionsBloc, FetchQuestionsState>(
//         listener: (context, state) {
//           if (state is SuccessFetchQuestionsState) {}
//         },
//         builder: (context, state) {
//           switch (state) {
//             case LoadingFetchQuestionsState():
//               {
//                 return AppLoadingIndicator();
//               }
//             case SuccessFetchQuestionsState():
//               {
//                 return BlocProvider.of<EvCommonControllCubit>(context)
//                         .uploadLoading
//                     ? AppLoadingIndicator()
//                     : SingleChildScrollView(
//                         child: AppMargin(
//                           child: Column(
//                             children: [
//                               const AppSpacer(
//                                 heightPortion: .03,
//                               ),
//                               Container(
//                                 decoration: const BoxDecoration(
//                                     borderRadius: BorderRadius.vertical(
//                                         top: Radius.circular(
//                                             AppDimensions.radiusSize18),
//                                         bottom: Radius.circular(
//                                             AppDimensions.radiusSize18)),
//                                     color: AppColors.kWhite,
//                                     boxShadow: [
//                                       BoxShadow(
//                                           blurRadius: 3,
//                                           blurStyle: BlurStyle.solid,
//                                           offset: Offset(0, 0),
//                                           color: AppColors.kAppSecondaryColor)
//                                     ]),
//                                 child: Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: AppDimensions.paddingSize10,
//                                       vertical: AppDimensions.paddingSize25),
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Row(
//                                         children: [
//                                           CircleAvatar(
//                                             backgroundColor:
//                                                 AppColors.kAppPrimaryColor,
//                                             child: Text(
//                                               '${state.currentIndexOfQuestion + 1}',
//                                               style: AppStyle.opensansStyle(
//                                                   color: AppColors.kWhite,
//                                                   size:
//                                                       AppDimensions.fontSize15(
//                                                           context),
//                                                   context: context,
//                                                   fontWeight: FontWeight.bold),
//                                             ),
//                                           ),
//                                           const AppSpacer(
//                                             widthPortion: .02,
//                                           ),
//                                           SizedBox(
//                                             width: w(context) * .74,
//                                             child: Text(
//                                               overflow: TextOverflow.clip,
//                                               ' ${state.listOfQuestions[state.currentIndexOfQuestion].question}',
//                                               style: AppStyle.opensansStyle(
//                                                   size:
//                                                       AppDimensions.fontSize15(
//                                                           context),
//                                                   context: context,
//                                                   fontWeight: FontWeight.bold),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       const AppSpacer(
//                                         heightPortion: .01,
//                                       ),
//                                       if (state
//                                               .listOfQuestions[
//                                                   state.currentIndexOfQuestion]
//                                               .questionType ==
//                                           'MCQ')
//                                         Column(
//                                           children: [
//                                             _subquestionView(),
//                                             Column(
//                                               children:
//                                                   _buildMcqQuestionTypeView(),
//                                             ),
//                                             selectedMainOption != null
//                                                 ? _isSelectedInvalidoptionView()
//                                                 : SizedBox(),
//                                             selectedMainOption != null
//                                                 ? _isSelecteValidoptionView()
//                                                 : SizedBox()
//                                           ],
//                                         ),
//                                       if (state
//                                               .listOfQuestions[
//                                                   state.currentIndexOfQuestion]
//                                               .questionType ==
//                                           'Descriptive')
//                                         _buildDescriptiveQuestionTypeView(),
//                                       if (state
//                                               .listOfQuestions[
//                                                   state.currentIndexOfQuestion]
//                                               .picture !=
//                                           "Not Required")
//                                         _takePictureView(state
//                                                     .listOfQuestions[state
//                                                         .currentIndexOfQuestion]
//                                                     .picture ==
//                                                 "Required Optional"
//                                             ? true
//                                             : false),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                               _commentBoxView(
//                                   state
//                                       .listOfQuestions[
//                                           state.currentIndexOfQuestion]
//                                       .commentsTitle,
//                                   state
//                                       .listOfQuestions[
//                                           state.currentIndexOfQuestion]
//                                       .invalidAnswers)
//                             ],
//                           ),
//                         ),
//                       );
//               }
//             case ErrorFetchQuestionsState():
//               {
//                 return AppEmptyText(text: state.errorMessage);
//               }
//             default:
//               {
//                 return SizedBox();
//               }
//           }
//         },
//       ),
//       bottomNavigationBar: _buildActionbutton(),
//     );
//   }

//   Widget _buildActionbutton() {
//     final state =
//         BlocProvider.of<FetchQuestionsBloc>(context, listen: true).state;
//     if (state is SuccessFetchQuestionsState) {
//       return AppMargin(
//         child: Container(
//           color: Colors.transparent,
//           width: w(context),
//           height: h(context) * .13,
//           child: Stack(
//             alignment: Alignment.center,
//             // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                     vertical: AppDimensions.paddingSize10,
//                     horizontal: AppDimensions.paddingSize10),
//                 decoration: BoxDecoration(
//                     borderRadius:
//                         BorderRadius.circular(AppDimensions.radiusSize50),
//                     gradient: const LinearGradient(
//                         begin: Alignment.topRight,
//                         end: Alignment.bottomRight,
//                         colors: [
//                           AppColors.kAppSecondaryColor,
//                           AppColors.kAppPrimaryColor
//                         ]),
//                     color: AppColors.kAppPrimaryColor),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     TextButton(
//                         onPressed: () {
//                           _clearControll();
//                           context.read<FetchQuestionsBloc>().add(
//                               OnPressPreviousButtonEvent(
//                                   previouseQuestionIndex:
//                                       state.currentIndexOfQuestion - 1));
//                         },
//                         child: Row(
//                           children: [
//                             const Icon(
//                               Icons.arrow_back_ios,
//                               color: AppColors.kWhite,
//                               size: 20,
//                             ),
//                             const AppSpacer(
//                               widthPortion: .02,
//                             ),
//                             Text(
//                               'Previous',
//                               style: AppStyle.poppinsStyle(
//                                   fontWeight: FontWeight.bold,
//                                   size: AppDimensions.fontSize15(context),
//                                   context: context,
//                                   color: AppColors.kWhite),
//                             ),
//                             const AppSpacer(
//                               widthPortion: .02,
//                             ),
//                           ],
//                         )),
//                     TextButton(
//                         onPressed: () async {
//                           if (_formKeyForcommentField.currentState!
//                               .validate()) {
//                             bool letsGoNextQuestion =
//                                 await checkTheCurrentQuestionIsFullAnsweresOrNot(
//                                     state.listOfQuestions[
//                                         state.currentIndexOfQuestion]);
//                             if (letsGoNextQuestion) {
//                               context.read<FetchQuestionsBloc>().add(
//                                   OnPressNextButtonEvent(
//                                       context: context,
//                                       nextQuestionIndex:
//                                           state.currentIndexOfQuestion + 1));
//                             }
//                           }
//                         },
//                         child: Row(
//                           children: [
//                             Text(
//                               'Submit',
//                               style: AppStyle.poppinsStyle(
//                                   fontWeight: FontWeight.bold,
//                                   size: AppDimensions.fontSize15(context),
//                                   context: context,
//                                   color: AppColors.kWhite),
//                             ),
//                             const AppSpacer(
//                               widthPortion: .04,
//                             ),
//                             const Icon(Icons.arrow_forward_ios,
//                                 color: AppColors.kWhite)
//                           ],
//                         )),
//                   ],
//                 ),
//               ),
//               Container(
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   gradient: const LinearGradient(
//                       begin: Alignment.topRight,
//                       end: Alignment.bottomRight,
//                       colors: [
//                         AppColors.kAppSecondaryColor,
//                         AppColors.kAppPrimaryColor
//                       ]),
//                 ),
//                 child: CircularPercentIndicator(
//                   backgroundColor: AppColors.kWhite,
//                   radius: 50,
//                   percent: (state.currentIndexOfQuestion) /
//                       state.listOfQuestions.length,
//                   center: Text(
//                     "${((state.currentIndexOfQuestion) / state.listOfQuestions.length * 100).toInt()}%",
//                     style: AppStyle.poppinsStyle(
//                         context: context,
//                         color: AppColors.kWhite,
//                         fontWeight: FontWeight.bold,
//                         size: AppDimensions.fontSize24(context)),
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       );
//     } else {
//       return Text('');
//     }
//   }

//   TextInputType getKeyboardType(String keybordType) {
//     switch (keybordType) {
//       case 'Float':
//         {
//           return TextInputType.number;
//         }
//       case 'Integer':
//         {
//           return TextInputType.number;
//         }
//       default:
//         {
//           return TextInputType.name;
//         }
//     }
//   }

//   //  IMGAE VIEW

//   Widget _takePictureView(bool isOptional) {
//     return Column(
//       children: [
//         AppSpacer(
//           heightPortion: .02,
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             RichText(
//                 text: TextSpan(
//                     text: 'Upload Pictures',
//                     style: AppStyle.opensansStyle(
//                         context: context,
//                         fontWeight: FontWeight.w600,
//                         size: AppDimensions.fontSize17(context)),
//                     children: [
//                   TextSpan(
//                       text: isOptional ? "  (optional) " : "",
//                       style: AppStyle.opensansStyle(context: context))
//                 ])),
//             Flexible(
//                 child: Divider(
//               thickness: .2,
//               endIndent: 10,
//               indent: 10,
//             )),
//           ],
//         ),
//         AppSpacer(
//           heightPortion: .02,
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Container(
//               width: w(context) * .23,
//               height: h(context) * .1,
//               padding: const EdgeInsets.all(AppDimensions.paddingSize10),
//               decoration: BoxDecoration(
//                   color: AppColors.kWhite,
//                   border: Border.all(color: AppColors.kAppSecondaryColor),
//                   borderRadius:
//                       BorderRadius.circular(AppDimensions.radiusSize10)),
//               child: Column(
//                 children: [
//                   IconButton(
//                       onPressed: () async {
//                         _openCamera();
//                       },
//                       icon: const Icon(
//                         CupertinoIcons.camera_circle_fill,
//                         size: 30,
//                       )),
//                   Text(
//                     listOfImages.isNotEmpty ? 'Take More' : 'Take picture',
//                     style: AppStyle.opensansStyle(
//                         context: context,
//                         fontWeight: FontWeight.bold,
//                         size: AppDimensions.fontSize10(context)),
//                   ),
//                 ],
//               ),
//             ),
//             const AppSpacer(
//               widthPortion: .01,
//             ),
//             listOfImages.isEmpty
//                 ? const SizedBox()
//                 : SizedBox(
//                     width: w(context) * .56,
//                     height: h(context) * .1,
//                     child: ListView.separated(
//                       shrinkWrap: true,
//                       separatorBuilder: (context, index) => const AppSpacer(
//                         widthPortion: .01,
//                       ),
//                       // hrinkWrap: true,
//                       itemCount: listOfImages.length,
//                       scrollDirection: Axis.horizontal,
//                       itemBuilder: (context, index) {
//                         return Container(
//                           width: w(context) * .23,
//                           height: h(context) * .1,
//                           decoration: BoxDecoration(
//                               border: Border.all(
//                                   color: AppColors.kAppSecondaryColor),
//                               borderRadius: BorderRadius.circular(
//                                   AppDimensions.radiusSize10),
//                               color: AppColors.kWhite,
//                               image: DecorationImage(
//                                   fit: BoxFit.fill,
//                                   image: FileImage(listOfImages[index]))),
//                         );
//                       },
//                     ),
//                   ),
//           ],
//         ),
//       ],
//     );
//   }

//   //---------

//   List<Widget> _buildMcqQuestionTypeView() {
//     final state =
//         BlocProvider.of<FetchQuestionsBloc>(context, listen: true).state;
//     if (state is SuccessFetchQuestionsState) {
//       QuestionModelData question =
//           state.listOfQuestions[state.currentIndexOfQuestion];
//       return question.answers
//           .map((anwers) => RadioListTile(
//               title: Text(
//                 anwers,
//                 style: AppStyle.opensansStyle(
//                     context: context, color: AppColors.kAppSecondaryColor),
//               ),
//               value: anwers,
//               groupValue: selectedMainOption,
//               onChanged: (value) {
//                 setState(() {
//                   selectedMainOption = value;
//                   if (question.invalidOptions.isNotEmpty) {
//                     selectedInvalidOption = question.invalidOptions.first;
//                   }
//                   if (question.validOptions.isNotEmpty) {
//                     selectedValidOption = question.validOptions.first;
//                   }
//                 });
//               }))
//           .toList();
//     } else {
//       return [];
//     }
//   }

//   Widget _buildDescriptiveQuestionTypeView() {
//     final state =
//         BlocProvider.of<FetchQuestionsBloc>(context, listen: true).state;

//     if (state is SuccessFetchQuestionsState) {
//       return Form(
//         key: _formKeyForTextField,
//         child: Column(
//           children: [
//             EvAppCustomTextfield(
//               keyBoardType: getKeyboardType(state
//                   .listOfQuestions[state.currentIndexOfQuestion].keyboardType),
//               controller: descriptiveController,
//               validator: (value) {
//                 if (value!.isEmpty) {
//                   return 'This filed is required';
//                 } else {
//                   return null;
//                 }
//               },
//               hintText: 'Enter the answer',
//             )
//           ],
//         ),
//       );
//     } else {
//       return SizedBox();
//     }
//   }

//   _showMessage(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         showCloseIcon: true,
//         behavior: SnackBarBehavior.floating,
//         content: Text(
//           message,
//           style:
//               AppStyle.opensansStyle(context: context, color: AppColors.kWhite),
//         )));
//   }

//   Widget _isSelectedInvalidoptionView() {
//     final state =
//         BlocProvider.of<FetchQuestionsBloc>(context, listen: true).state;

//     if (state is SuccessFetchQuestionsState) {
//       QuestionModelData question =
//           state.listOfQuestions[state.currentIndexOfQuestion];

//       if (question.invalidAnswers == selectedMainOption) {
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             AppSpacer(
//               heightPortion: .02,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   question.invalidOptionsTitle,
//                   style: AppStyle.opensansStyle(
//                       context: context,
//                       fontWeight: FontWeight.w600,
//                       size: AppDimensions.fontSize17(context)),
//                 ),
//                 Flexible(
//                     child: Divider(
//                   thickness: .2,
//                   endIndent: 10,
//                   indent: 10,
//                 )),
//               ],
//             ),
//             AppSpacer(
//               heightPortion: .02,
//             ),
//             DropdownButtonFormField(
//                 icon: Icon(
//                   CupertinoIcons.chevron_down,
//                   size: 15,
//                   color: AppColors.kAppSecondaryColor,
//                 ),
//                 elevation: 4,
//                 decoration: AppStyle.dropdownDecoration(),
//                 value: selectedInvalidOption,
//                 hint: Text(
//                   'Select the ${question.invalidOptionsTitle}',
//                   style: AppStyle.poppinsStyle(
//                       context: context, color: AppColors.kGrey),
//                 ),
//                 items: question.invalidOptions
//                     .asMap()
//                     .entries
//                     .map((e) => DropdownMenuItem(
//                         value: e.value.toString(),
//                         child: Text(
//                           e.value.toString(),
//                           style: AppStyle.opensansStyle(
//                             context: context,
//                             color: AppColors.kAppSecondaryColor,
//                             // size:
//                             //     AppDimensions.fontSize16(context),
//                             fontWeight: FontWeight.w600,
//                           ),
//                         )))
//                     .toList(),
//                 onChanged: (value) {
//                   selectedInvalidOption = value;
//                 }),
//           ],
//         );
//       } else {
//         return SizedBox();
//       }
//     } else {
//       return SizedBox();
//     }
//   }

//   Widget _isSelecteValidoptionView() {
//     final state =
//         BlocProvider.of<FetchQuestionsBloc>(context, listen: true).state;

//     if (state is SuccessFetchQuestionsState) {
//       QuestionModelData question =
//           state.listOfQuestions[state.currentIndexOfQuestion];

//       if (question.answers.first == selectedMainOption &&
//           question.validOptions.isNotEmpty) {
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             AppSpacer(
//               heightPortion: .02,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   question.validOptionsTitle.isNotEmpty
//                       ? question.validOptionsTitle
//                       : 'Please choose the option',
//                   style: AppStyle.opensansStyle(
//                       context: context,
//                       fontWeight: FontWeight.w600,
//                       size: AppDimensions.fontSize17(context)),
//                 ),
//                 Flexible(
//                     child: Divider(
//                   thickness: .2,
//                   endIndent: 10,
//                   indent: 10,
//                 )),
//               ],
//             ),
//             AppSpacer(
//               heightPortion: .02,
//             ),
//             DropdownButtonFormField(
//                 elevation: 4,
//                 icon: Icon(
//                   CupertinoIcons.chevron_down,
//                   size: 15,
//                   color: AppColors.kAppSecondaryColor,
//                 ),
//                 decoration: AppStyle.dropdownDecoration(),
//                 value: selectedValidOption,
//                 hint: Text(
//                   'Select the option',
//                   style: AppStyle.poppinsStyle(
//                       context: context, color: AppColors.kGrey),
//                 ),
//                 items: question.validOptions
//                     .asMap()
//                     .entries
//                     .map((e) => DropdownMenuItem(
//                         value: e.value.toString(),
//                         child: Text(
//                           e.value.toString(),
//                           style: AppStyle.opensansStyle(
//                             context: context,
//                             color: AppColors.kAppSecondaryColor,
//                             // size:
//                             //     AppDimensions.fontSize16(context),
//                             fontWeight: FontWeight.w600,
//                           ),
//                         )))
//                     .toList(),
//                 onChanged: (value) {
//                   selectedValidOption = value;
//                 }),
//           ],
//         );
//       } else {
//         return SizedBox();
//       }
//     } else {
//       return SizedBox();
//     }
//   }

//   Widget _subquestionView() {
//     final state =
//         BlocProvider.of<FetchQuestionsBloc>(context, listen: true).state;

//     if (state is SuccessFetchQuestionsState) {
//       QuestionModelData question =
//           state.listOfQuestions[state.currentIndexOfQuestion];
//       if (question.subQuestionOptions.isNotEmpty) {
//         selectedSubQuestionOption = question.subQuestionOptions.first;
//         return Column(
//           children: [
//             AppSpacer(
//               heightPortion: .02,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   question.subQuestionTitle,
//                   style: AppStyle.opensansStyle(
//                       context: context,
//                       fontWeight: FontWeight.w600,
//                       size: AppDimensions.fontSize17(context)),
//                 ),
//                 Flexible(
//                     child: Divider(
//                   thickness: .2,
//                   endIndent: 10,
//                   indent: 10,
//                 )),
//               ],
//             ),
//             AppSpacer(
//               heightPortion: .02,
//             ),
//             DropdownButtonFormField(
//                 elevation: 4,
//                 decoration: AppStyle.dropdownDecoration(),
//                 icon: Icon(
//                   CupertinoIcons.chevron_down,
//                   size: 15,
//                   color: AppColors.kAppSecondaryColor,
//                 ),
//                 value: selectedSubQuestionOption,
//                 hint: Text(
//                   'Select the ${question.subQuestionTitle}',
//                   style: AppStyle.poppinsStyle(
//                       context: context, color: AppColors.kGrey),
//                 ),
//                 items: question.subQuestionOptions
//                     .asMap()
//                     .entries
//                     .map((e) => DropdownMenuItem(
//                         value: e.value.toString(),
//                         child: Text(
//                           e.value.toString(),
//                           style: AppStyle.opensansStyle(
//                             context: context,
//                             color: AppColors.kAppSecondaryColor,
//                             // size:
//                             //     AppDimensions.fontSize16(context),
//                             fontWeight: FontWeight.w600,
//                           ),
//                         )))
//                     .toList(),
//                 onChanged: (value) {
//                   selectedSubQuestionOption = value;
//                 }),
//           ],
//         );
//       } else {
//         return SizedBox();
//       }
//     } else {
//       return SizedBox();
//     }
//   }

//   Widget _commentBoxView(String commentTitle, String invalidAnswer) {
//     return Form(
//       key: _formKeyForcommentField,
//       child: Column(
//         children: [
//           AppSpacer(
//             heightPortion: .02,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               RichText(
//                   text: TextSpan(
//                       text: commentTitle.isEmpty ? 'Comment' : commentTitle,
//                       style: AppStyle.opensansStyle(
//                           context: context,
//                           fontWeight: FontWeight.w600,
//                           size: AppDimensions.fontSize17(context)),
//                       children: [
//                     TextSpan(
//                         text: commentTitle.isNotEmpty ||
//                                 invalidAnswer == selectedMainOption
//                             ? ""
//                             : "  (optional) ",
//                         style: AppStyle.opensansStyle(context: context))
//                   ])),
//               Flexible(
//                   child: Divider(
//                 thickness: .2,
//                 endIndent: 10,
//                 indent: 10,
//               )),
//             ],
//           ),
//           EvAppCustomTextfield(
//               maxLine: 5,
//               validator: (value) {
//                 if (invalidAnswer == selectedMainOption) {
//                   if (value!.isEmpty) {
//                     return 'Enter the comment';
//                   } else {
//                     return null;
//                   }
//                 } else {
//                   return null;
//                 }
//               },
//               controller: commnetControoller,
//               hintText: commentTitle.isEmpty
//                   ? 'Enter the comment in any...'
//                   : commentTitle),
//         ],
//       ),
//     );
//   }
// }
