import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wheels_kart/module/evaluator/data/bloc/get%20data/fetch%20questions/fetch_questions_bloc.dart';
import 'package:wheels_kart/module/evaluator/data/cubit/submit%20answer%20controller/submit_answer_controller_cubit.dart';
import 'package:wheels_kart/module/evaluator/data/model/upload_inspection_model.dart';

class Functions {
  static void onSelectSubQuestion(
      BuildContext context, int questionIndex, dynamic value) {
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
      context
          .read<FetchQuestionsBloc>()
          .add(OnAnswerTheQuestion(listOfUploads: updatedIndexVariables));

      // Reset
      _resetButtonStatus(context, questionIndex);
    }
  }

  static void onSelectAnswertion(
      BuildContext context, int questionIndex, dynamic value) {
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
      context
          .read<FetchQuestionsBloc>()
          .add(OnAnswerTheQuestion(listOfUploads: updatedIndexVariables));
      // Reset
      _resetButtonStatus(context, questionIndex);
    }
  }

  static void onSelectValidOption(
      BuildContext context, int questionIndex, dynamic value) {
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
            context
                .read<FetchQuestionsBloc>()
                .add(OnAnswerTheQuestion(listOfUploads: updatedIndexVariables));
          } else {
            updatedIndexVariables[questionIndex].validOption = null;
            context
                .read<FetchQuestionsBloc>()
                .add(OnAnswerTheQuestion(listOfUploads: updatedIndexVariables));
          }
        } else {
          listOfSelectedvalidOption.add(value);
          final result = listOfSelectedvalidOption.join(",");
          updatedIndexVariables[questionIndex].validOption = result;
          context
              .read<FetchQuestionsBloc>()
              .add(OnAnswerTheQuestion(listOfUploads: updatedIndexVariables));
        }
      } else {
        updatedIndexVariables[questionIndex].validOption = value;
        context
            .read<FetchQuestionsBloc>()
            .add(OnAnswerTheQuestion(listOfUploads: updatedIndexVariables));
      }
      // Reset
      _resetButtonStatus(context, questionIndex);
    }
  }

  static void onSelectInValidOption(
      BuildContext context, int questionIndex, dynamic value) {
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
            context
                .read<FetchQuestionsBloc>()
                .add(OnAnswerTheQuestion(listOfUploads: updatedIndexVariables));
          } else {
            updatedIndexVariables[questionIndex].invalidOption = null;
            context
                .read<FetchQuestionsBloc>()
                .add(OnAnswerTheQuestion(listOfUploads: updatedIndexVariables));
          }
        } else {
          listOfSelectedIvalidOption.add(value);
          final result = listOfSelectedIvalidOption.join(",");
          updatedIndexVariables[questionIndex].invalidOption = result;
          context
              .read<FetchQuestionsBloc>()
              .add(OnAnswerTheQuestion(listOfUploads: updatedIndexVariables));
        }
      } else {
        updatedIndexVariables[questionIndex].invalidOption = value;
        context
            .read<FetchQuestionsBloc>()
            .add(OnAnswerTheQuestion(listOfUploads: updatedIndexVariables));
      }
      // Reset
      _resetButtonStatus(context, questionIndex);
    }
  }

  static onFillDescriptiveAnswer(
      BuildContext context, int questionIndex, String answer) {
    final currentState = BlocProvider.of<FetchQuestionsBloc>(context).state;
    if (currentState is SuccessFetchQuestionsState) {
      final updatedIndexVariables = currentState.listOfUploads;
      updatedIndexVariables[questionIndex].answer = answer;
      context
          .read<FetchQuestionsBloc>()
          .add(OnAnswerTheQuestion(listOfUploads: updatedIndexVariables));
    }
  }

//----------------SUBMISSION----------------
  static Future<void> onAddComment(
      BuildContext context, int questionIndex, String comment) async {
    log(comment);
    final currentState = BlocProvider.of<FetchQuestionsBloc>(context).state;
    if (currentState is SuccessFetchQuestionsState) {
      final updatedIndexVariables = currentState.listOfUploads;
      updatedIndexVariables[questionIndex].comment = comment;
      context
          .read<FetchQuestionsBloc>()
          .add(OnAnswerTheQuestion(listOfUploads: updatedIndexVariables));
    }
  }

  static Future<void> onAddImages(
      BuildContext context, int questionIndex, List<File> images) async {
    final currentState = BlocProvider.of<FetchQuestionsBloc>(context).state;
    if (currentState is SuccessFetchQuestionsState) {
      final updatedIndexVariables = currentState.listOfUploads;
      List<Attachment> attachments = [];
      if (images.isNotEmpty) {
        for (var file in images) {
          final compressedFile = await _compressImageFile(file) ?? File("");
          if (compressedFile.path.isNotEmpty) {
            final mapData =
                await _convartImageFileToBase65Formate(compressedFile);
            attachments.add(Attachment.fromJson(mapData));
          }
        }
      }
      log("Total attachements : ${attachments.length}");
      updatedIndexVariables[questionIndex].attachments = attachments;
      context
          .read<FetchQuestionsBloc>()
          .add(OnAnswerTheQuestion(listOfUploads: updatedIndexVariables));
    }
  }

  // ---------------------------HELPERS-----
  static Future<File?> _compressImageFile(File imageFile) async {
    try {
      final dir = await getTemporaryDirectory();
      final targetPath = "${dir.absolute.path}/${DateTime.now()}.jpg";
      var result = await FlutterImageCompress.compressAndGetFile(
        imageFile.absolute.path,
        targetPath,
        quality: 100, // Adjust the quality parameter
        minWidth: 800, // Optionally resize the image width
        minHeight: 600,
      );

      return File(result!.path);
    } catch (e) {
      log("Image compression Error - ${e.toString()}");
      return null;
    }
  }

  static Future<Map<String, dynamic>> _convartImageFileToBase65Formate(
      File file) async {
    final bytes = await file.readAsBytes();
    final converted = base64Encode(bytes);
    final fileName = path.basename(file.path);
    return {'fileName': fileName, 'file': converted};
  }

  static _resetButtonStatus(BuildContext context, int questionIndex) {
    final state = BlocProvider.of<FetchQuestionsBloc>(context).state;
    if (state is SuccessFetchQuestionsState) {
      context.read<SubmitAnswerControllerCubit>().resetState(questionIndex);
    }
  }
}
