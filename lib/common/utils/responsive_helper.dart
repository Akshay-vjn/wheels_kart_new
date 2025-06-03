import 'package:flutter/material.dart';

double responsiveTextSize(BuildContext context, double scaleFactor) {
  double screenWidth = MediaQuery.of(context).size.width;
  double screenHeight = MediaQuery.of(context).size.height;
  double basis = screenHeight + screenWidth;

  return basis * scaleFactor;
}

double h(BuildContext context) {
  return MediaQuery.of(context).size.height;

}
double w(BuildContext context) {
  return MediaQuery.of(context).size.width;
  
}