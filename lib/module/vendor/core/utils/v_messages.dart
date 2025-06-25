import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:wheels_kart/module/VENDOR/core/const/v_colors.dart';

void vSnackBarMessage(
  BuildContext context,
  String message, {
  VSnackState? state = VSnackState.SUCCESS,
}) {
  Color color;
  IconData icon;
  switch (state) {
    case VSnackState.ERROR:
      {
        icon = Icons.error;
        color = VColors.ERROR;
      }
    case VSnackState.SUCCESS:
      {
        icon = Icons.check_circle;
        color = VColors.SUCCESS;
      }
    default:
      {
        icon = Icons.info;
        color = VColors.DARK_GREY;
      }
  }
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Flexible(child: Text(message)),
        ],
      ),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(16),
    ),
  );
}

enum VSnackState { ERROR, SUCCESS, OTHER }
