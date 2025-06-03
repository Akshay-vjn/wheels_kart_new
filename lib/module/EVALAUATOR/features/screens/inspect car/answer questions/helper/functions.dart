import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/bloc/get%20data/fetch%20questions/fetch_questions_bloc.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/bloc/submit%20answer%20controller/submit_answer_controller_cubit.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/model/inspection_prefill_model.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/model/upload_inspection_model.dart';

class Functions {
  // Prefill Function
  static Future<void> onPrefillTheQuestion(
    BuildContext context,
    int questionIndex,
    InspectionPrefillModel prefillData,
  ) async {
    final currentState = BlocProvider.of<FetchQuestionsBloc>(context).state;
    if (currentState is SuccessFetchQuestionsState) {
      String? subQuestionAnswer = prefillData.subQuestionAnswer;
      String? answer = prefillData.answer;
      String? validAnswer = prefillData.validOption;
      String? inValidAnswer = prefillData.invalidOption;
      String? comment = prefillData.comment;

      List<UploadInspectionModel> updatedIndexVariables =
          currentState.listOfUploads;
      //-----------------------REST------------------------------
      updatedIndexVariables[questionIndex].subQuestionAnswer =
          subQuestionAnswer;
      updatedIndexVariables[questionIndex].answer = answer;
      updatedIndexVariables[questionIndex].invalidOption = inValidAnswer;
      updatedIndexVariables[questionIndex].validOption = validAnswer;
      updatedIndexVariables[questionIndex].attachments = null;
      updatedIndexVariables[questionIndex].comment = comment;

      //------------------------------------------------------

      context.read<FetchQuestionsBloc>().add(
        OnAnswerTheQuestion(
           
          listOfUploads: updatedIndexVariables,
          index: questionIndex,
        ),
      );
      final state = BlocProvider.of<FetchQuestionsBloc>(context).state;
      if (state is SuccessFetchQuestionsState) {
        context.read<EvSubmitAnswerControllerCubit>().changeStatusToSaved(
          questionIndex,
        );
      }
      
    }
  }

  //--------------------------------
  static void onSelectSubQuestion(
    BuildContext context,
    int questionIndex,
    dynamic value,
  ) {
    final currentState = BlocProvider.of<FetchQuestionsBloc>(context).state;
    if (currentState is SuccessFetchQuestionsState) {
      List<UploadInspectionModel> updatedIndexVariables =
          currentState.listOfUploads;
      //-----------------------REST------------------------------

      updatedIndexVariables[questionIndex].answer = null;
      updatedIndexVariables[questionIndex].invalidOption = null;
      updatedIndexVariables[questionIndex].validOption = null;
      updatedIndexVariables[questionIndex].attachments = null;
      updatedIndexVariables[questionIndex].comment = null;

      //------------------------------------------------------

      updatedIndexVariables[questionIndex].subQuestionAnswer = value;
      context.read<FetchQuestionsBloc>().add(
        OnAnswerTheQuestion(
          listOfUploads: updatedIndexVariables,
          index: questionIndex,
        ),
      );

      // Reset
      resetButtonStatus(context, questionIndex);
    }
  }

  static void onSelectAnswertion(
    BuildContext context,
    int questionIndex,
    dynamic value,
  ) {
    final currentState = BlocProvider.of<FetchQuestionsBloc>(context).state;
    if (currentState is SuccessFetchQuestionsState) {
      final updatedIndexVariables = currentState.listOfUploads;
      //-----------------------REST------------------------------

      updatedIndexVariables[questionIndex].invalidOption = null;
      updatedIndexVariables[questionIndex].validOption = null;
      updatedIndexVariables[questionIndex].attachments = null;
      updatedIndexVariables[questionIndex].comment = null;

      //------------------------------------------------------

      updatedIndexVariables[questionIndex].answer = value;
      context.read<FetchQuestionsBloc>().add(
        OnAnswerTheQuestion(
          listOfUploads: updatedIndexVariables,
          index: questionIndex,
        ),
      );
      // Reset
      resetButtonStatus(context, questionIndex);
    }
  }

  static void onSelectValidOption(
    BuildContext context,
    int questionIndex,
    dynamic value,
  ) {
    final currentState = BlocProvider.of<FetchQuestionsBloc>(context).state;
    if (currentState is SuccessFetchQuestionsState) {
      final updatedIndexVariables = currentState.listOfUploads;

      //-----------------------REST------------------------------

      updatedIndexVariables[questionIndex].invalidOption = null;
      updatedIndexVariables[questionIndex].attachments = null;
      updatedIndexVariables[questionIndex].comment = null;

      //------------------------------------------------------
      final validOption = updatedIndexVariables[questionIndex].validOption;
      if (validOption != null) {
        final listOfSelectedvalidOption = validOption.split(",");
        if (listOfSelectedvalidOption.contains(value)) {
          listOfSelectedvalidOption.remove(value);
          if (listOfSelectedvalidOption.isNotEmpty) {
            final result = listOfSelectedvalidOption.join(",");
            updatedIndexVariables[questionIndex].validOption = result;
            context.read<FetchQuestionsBloc>().add(
              OnAnswerTheQuestion(
                listOfUploads: updatedIndexVariables,
                index: questionIndex,
              ),
            );
          } else {
            updatedIndexVariables[questionIndex].validOption = null;
            context.read<FetchQuestionsBloc>().add(
              OnAnswerTheQuestion(
                listOfUploads: updatedIndexVariables,
                index: questionIndex,
              ),
            );
          }
        } else {
          listOfSelectedvalidOption.add(value);
          final result = listOfSelectedvalidOption.join(",");
          updatedIndexVariables[questionIndex].validOption = result;
          context.read<FetchQuestionsBloc>().add(
            OnAnswerTheQuestion(
              listOfUploads: updatedIndexVariables,
              index: questionIndex,
            ),
          );
        }
      } else {
        updatedIndexVariables[questionIndex].validOption = value;
        context.read<FetchQuestionsBloc>().add(
          OnAnswerTheQuestion(
            listOfUploads: updatedIndexVariables,
            index: questionIndex,
          ),
        );
      }
      // Reset
      resetButtonStatus(context, questionIndex);
    }
  }

  static void onSelectInValidOption(
    BuildContext context,
    int questionIndex,
    dynamic value,
  ) {
    final currentState = BlocProvider.of<FetchQuestionsBloc>(context).state;
    if (currentState is SuccessFetchQuestionsState) {
      final updatedIndexVariables = currentState.listOfUploads;
      //-----------------------REST------------------------------

      updatedIndexVariables[questionIndex].validOption = null;
      updatedIndexVariables[questionIndex].attachments = null;
      updatedIndexVariables[questionIndex].comment = null;

      //------------------------------------------------------
      final inValidOptions = updatedIndexVariables[questionIndex].invalidOption;
      if (inValidOptions != null) {
        final listOfSelectedIvalidOption = inValidOptions.split(",");
        if (listOfSelectedIvalidOption.contains(value)) {
          listOfSelectedIvalidOption.remove(value);
          if (listOfSelectedIvalidOption.isNotEmpty) {
            final result = listOfSelectedIvalidOption.join(",");
            updatedIndexVariables[questionIndex].invalidOption = result;
            context.read<FetchQuestionsBloc>().add(
              OnAnswerTheQuestion(
                listOfUploads: updatedIndexVariables,
                index: questionIndex,
              ),
            );
          } else {
            updatedIndexVariables[questionIndex].invalidOption = null;
            context.read<FetchQuestionsBloc>().add(
              OnAnswerTheQuestion(
                listOfUploads: updatedIndexVariables,
                index: questionIndex,
              ),
            );
          }
        } else {
          listOfSelectedIvalidOption.add(value);
          final result = listOfSelectedIvalidOption.join(",");
          updatedIndexVariables[questionIndex].invalidOption = result;
          context.read<FetchQuestionsBloc>().add(
            OnAnswerTheQuestion(
              listOfUploads: updatedIndexVariables,
              index: questionIndex,
            ),
          );
        }
      } else {
        updatedIndexVariables[questionIndex].invalidOption = value;
        context.read<FetchQuestionsBloc>().add(
          OnAnswerTheQuestion(
            listOfUploads: updatedIndexVariables,
            index: questionIndex,
          ),
        );
      }
      // Reset
      resetButtonStatus(context, questionIndex);
    }
  }

  static onFillDescriptiveAnswer(
    BuildContext context,
    int questionIndex,
    String answer,
  ) {
    final currentState = BlocProvider.of<FetchQuestionsBloc>(context).state;
    if (currentState is SuccessFetchQuestionsState) {
      final updatedIndexVariables = currentState.listOfUploads;
      updatedIndexVariables[questionIndex].answer = answer;
      context.read<FetchQuestionsBloc>().add(
        OnAnswerTheQuestion(
          listOfUploads: updatedIndexVariables,
          index: questionIndex,
        ),
      );
    }
  }

  //----------------SUBMISSION----------------
  static Future<void> onAddComment(
    BuildContext context,
    int questionIndex,
    String comment,
  ) async {
    log(comment);
    final currentState = BlocProvider.of<FetchQuestionsBloc>(context).state;
    if (currentState is SuccessFetchQuestionsState) {
      final updatedIndexVariables = currentState.listOfUploads;
      updatedIndexVariables[questionIndex].comment = comment;
      context.read<FetchQuestionsBloc>().add(
        OnAnswerTheQuestion(
          listOfUploads: updatedIndexVariables,
          index: questionIndex,
        ),
      );
    }
  }

  static Future<void> onAddImages(
    BuildContext context,
    int questionIndex,
    List<Uint8List?> images,
  ) async {
    final currentState = BlocProvider.of<FetchQuestionsBloc>(context).state;
    if (currentState is SuccessFetchQuestionsState) {
      final updatedIndexVariables = currentState.listOfUploads;
      List<Attachment> attachments = [];
      if (images.isNotEmpty) {
        for (var file in images) {
          if (file != null) {
            final compressedFile = await _compressImageFromUint8List(file);
            if (compressedFile != null) {
              final mapData = await _convertImageUint8ToBase64(compressedFile);
              attachments.add(Attachment.fromJson(mapData));
            }
          }
        }
      }
      log("Total attachements : ${attachments.length}");
      updatedIndexVariables[questionIndex].attachments = attachments;
      context.read<FetchQuestionsBloc>().add(
        OnAnswerTheQuestion(
          listOfUploads: updatedIndexVariables,
          index: questionIndex,
        ),
      );
     
    }
  }

  // ---------------------------HELPERS-----
  // static Future<File?> _compressImageFile(Uint8List imageFile) async {
  //   try {
  //     final dir = await getTemporaryDirectory();
  //     final targetPath = "${dir.absolute.path}/${DateTime.now()}.jpg";
  //     var result = await FlutterImageCompress.compressAndGetFile(
  //       imageFile.absolute.path,
  //       targetPath,
  //       quality: 100, // Adjust the quality parameter
  //       minWidth: 800, // Optionally resize the image width
  //       minHeight: 600,
  //     );

  //     return File(result!.path);
  //   } catch (e) {
  //     log("Image compression Error - ${e.toString()}");
  //     return null;
  //   }
  // }
  static Future<Uint8List?> _compressImageFromUint8List(
    Uint8List imageData,
  ) async {
    try {
      var result = await FlutterImageCompress.compressWithList(
        imageData,
        quality: 80, // Adjust quality here
        minWidth: 800,
        minHeight: 600,
      );
      return result;
    } catch (e) {
      log("Compression Error: ${e.toString()}");
      return null;
    }
  }

  // static Future<Map<String, dynamic>> _convartImageFileToBase65Formate(
  //   Uint8List file,
  // ) async {
  //   final bytes = await file.readAsBytes();
  //   final converted = base64Encode(bytes);
  //   final fileName = path.basename(file.path);

  //   return {'fileName': fileName, 'file': converted};
  // }
  static Future<Map<String, dynamic>> _convertImageUint8ToBase64(
    Uint8List fileBytes, {
    String? filePath,
  }) async {
    final converted = base64Encode(fileBytes);
    final fileName =
        filePath != null
            ? path.basename(filePath)
            : '${DateTime.now().toIso8601String()}.jpg';

    return {'fileName': fileName, 'file': converted};
  }

  static Future<Uint8List?> convartNetworkImageToUni8ListFormate(
    String imageUrl,
  ) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        return response.bodyBytes; // This is your Uint8List
      } else {
        print("Failed to load image. Status: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error fetching image: $e");
      return null;
    }
  }

  static resetButtonStatus(BuildContext context, int questionIndex) {
    final state = BlocProvider.of<FetchQuestionsBloc>(context).state;
    if (state is SuccessFetchQuestionsState) {
      context.read<EvSubmitAnswerControllerCubit>().resetState(questionIndex);
    }
  }
}
