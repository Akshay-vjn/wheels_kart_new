import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wheels_kart/core/components/app_appbar.dart';
import 'package:wheels_kart/core/components/app_margin.dart';
import 'package:wheels_kart/core/components/app_spacer.dart';
import 'package:wheels_kart/core/constant/colors.dart';
import 'package:wheels_kart/core/constant/dimensions.dart';
import 'package:wheels_kart/core/constant/style.dart';
import 'package:wheels_kart/core/utils/custome_show_messages.dart';
import 'package:wheels_kart/core/utils/routes.dart';
import 'package:wheels_kart/core/utils/validator.dart';
import 'package:wheels_kart/module/evaluator/UI/screens/inspect%20car/answer%20questions/e_eselect_portion_screen.dart';
import 'package:wheels_kart/module/evaluator/UI/widgets/app_custom_button.dart';
import 'package:wheels_kart/module/evaluator/UI/widgets/app_custom_textfield.dart';
import 'package:wheels_kart/module/evaluator/data/bloc/get%20data/fetch%20city/fetch_city_bloc.dart';
import 'package:wheels_kart/module/evaluator/data/model/inspection_data_model.dart';
import 'package:wheels_kart/module/evaluator/data/repositories/master/fetch_the_instruction_repo.dart';
import 'package:wheels_kart/module/evaluator/data/repositories/new_inspection_repo.dart';

class EvCreateInspectionScreen extends StatefulWidget {
  const EvCreateInspectionScreen({super.key});

  @override
  State<EvCreateInspectionScreen> createState() =>
      _EvCreateInspectionScreenState();
}

class _EvCreateInspectionScreenState extends State<EvCreateInspectionScreen> {
  @override
  void initState() {
    super.initState();
    context.read<EvFetchCityBloc>().add(OnFetchCityDataEvent(context: context));
  }

  final _nameController = TextEditingController();
  final _mobileNumber = TextEditingController();
  final _emailAddress = TextEditingController();
  final _addressController = TextEditingController();

  String? _selectedCity;

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppbar(title: "Add New Lead"),
      body: AppMargin(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSpacer(heightPortion: .01),

                EvAppCustomTextfield(
                  validator: Validator.validateRequired,
                  controller: _nameController,
                  isTextCapital: false,
                  borderRudius: 15,

                  labeltext: "Full Name",

                  hintText: "Enter customer name",
                ),
                EvAppCustomTextfield(
                  validator: Validator.validateMobileNumber,
                  controller: _mobileNumber,
                  keyBoardType: TextInputType.phone,
                  borderRudius: 15,
                  maxLenght: 10,
                  labeltext: "Mobile Number",
                  hintText: "Enter customer mobile number",
                ),

                EvAppCustomTextfield(
                  validator: Validator.validateEmail,
                  controller: _emailAddress,
                  keyBoardType: TextInputType.emailAddress,
                  borderRudius: 15,
                  isTextCapital: null,
                  labeltext: "Email Address",
                  hintText: "Enter customer email address",
                ),
                _buildCityDropDown(),
                EvAppCustomTextfield(
                  validator: Validator.validateRequired,
                  controller: _addressController,
                  isTextCapital: false,
                  borderRudius: 15,
                  labeltext: "Address",
                  hintText: "Enter customer address",
                  maxLine: 3,
                ),

                AppSpacer(heightPortion: .02),

                EvAppCustomButton(
                  title: "SUBMIT",
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      final response = await NewInspectionRepo.createInspection(
                        context,
                        _nameController.text.trim(),
                        _mobileNumber.text.trim(),
                        _addressController.text.trim(),
                        _emailAddress.text.trim(),
                        int.parse(_selectedCity!),
                      );
                      if (response.isNotEmpty) {
                        if (response['error'] == false) {
                          final data = InspectionModel.fromJson(
                            response['data'],
                          );

                          showSheet(context, data);
                        } else {
                          showSnakBar(
                            context,
                            response['message'],
                            isError: true,
                          );
                        }
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showSheet(BuildContext context, dynamic inspectionModel) {
    _clearAll();
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              TweenAnimationBuilder(
                duration: const Duration(seconds: 2),
                tween: Tween<double>(begin: 0.8, end: 1.0),
                curve: Curves.elasticOut,
                builder: (context, v, _) {
                  return Transform.scale(
                    scale: v,
                    child: TweenAnimationBuilder(
                      duration: const Duration(seconds: 2),
                      tween: Tween<double>(begin: 0.8, end: 1.0),
                      curve: Curves.elasticOut,
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: Icon(
                            size: 120,
                            Icons.sentiment_very_satisfied_rounded,
                            color: AppColors.DEFAULT_BLUE_DARK,
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              // showCustomMessageDialog(context, message, messageType: messageType)
              AppSpacer(heightPortion: 0.02),
              Text(
                'Vehicle Registered',

                style: AppStyle.style(
                  context: context,
                  size: AppDimensions.fontSize17(context),
                  fontWeight: FontWeight.bold,
                ),
              ),
              AppSpacer(heightPortion: 0.01),
              Text(
                'Do you want to inspect the vehicle now or later?',
                textAlign: TextAlign.center,
                style: AppStyle.style(
                  context: context,
                  size: AppDimensions.fontSize15(context),
                  color: AppColors.grey,
                ),
              ),
              AppSpacer(heightPortion: 0.03),
              ElevatedButton.icon(
                onPressed: () async {
                  if (inspectionModel.engineTypeId.isEmpty ||
                      inspectionModel.engineTypeId == '0') {
                    showCustomMessageDialog(
                      context,
                      'Fill the basic detailes and try again',
                      messageType: MessageCategory.WARNING,
                    );
                  } else {
                    if (inspectionModel.engineTypeId == '1') {
                      final snapshot =
                          await FetchTheInstructionRepo.getTheInstructionForStartEngine(
                            context,
                            inspectionModel.engineTypeId,
                          );

                      if (snapshot['error'] == true) {
                        showCustomMessageDialog(
                          context,
                          snapshot['message'],
                          messageType: MessageCategory.ERROR,
                        );
                      } else if (snapshot.isEmpty) {
                        showCustomMessageDialog(
                          context,
                          'Instruction page not found!',
                          messageType: MessageCategory.ERROR,
                        );
                      } else if (snapshot['error'] == false) {
                        // log(snapshot['data'][0]['instructions'].toString());
                        Navigator.of(context).push(
                          AppRoutes.createRoute(
                            EvSelectPostionScreen(
                              inspectionModel: inspectionModel,
                              inspectionId: inspectionModel.inspectionId,
                              instructionData:
                                  snapshot['data'][0]['instructions'],
                            ),
                          ),
                        );
                        // navigate to instruction page
                      }
                    } else if (inspectionModel.engineTypeId == '1') {
                      // naviga to guestion page
                      Navigator.of(context).push(
                        AppRoutes.createRoute(
                          EvSelectPostionScreen(
                            inspectionModel: inspectionModel,
                            instructionData: null,
                            inspectionId: inspectionModel.inspectionId,
                          ),
                        ),
                      );
                    }
                  }
                },
                icon: Icon(Icons.search, color: Colors.white),
                label: Text(
                  'Inspect Now',
                  style: AppStyle.style(
                    context: context,
                    color: AppColors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.DEFAULT_BLUE_DARK,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              AppSpacer(heightPortion: 0.015),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  showSnakBar(
                    context,
                    "Vehicle registered for inspection. You can complete it later from the dashboard.",
                  );
                },
                child: Text(
                  'Do It Later',
                  style: AppStyle.style(
                    context: context,
                    color: AppColors.DEFAULT_BLUE_DARK,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCityDropDown() {
    return BlocBuilder<EvFetchCityBloc, EvFetchCityState>(
      builder: (context, state) {
        if (state is! FetchCitySuccessSate) return SizedBox();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "City",
              style: AppStyle.style(
                context: context,
                size: AppDimensions.fontSize15(context),
                color: AppColors.DEFAULT_BLUE_DARK,
                fontWeight: FontWeight.w600,
              ),
            ),
            const AppSpacer(heightPortion: .01),
            DropdownButtonFormField<String>(
              validator: Validator.validateRequired,
              style: AppStyle.style(
                context: context,
                color: AppColors.black,
                fontWeight: FontWeight.w500,
                size: AppDimensions.fontSize18(context),
              ),
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  borderSide: BorderSide(width: 1, color: AppColors.grey),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  borderSide: BorderSide(width: 1.5, color: AppColors.kRed),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  borderSide: BorderSide(width: 1.5, color: AppColors.kRed),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  borderSide: BorderSide(
                    width: 2,
                    color: AppColors.DEFAULT_BLUE_GREY,
                  ),
                ),
                // hintText: "Select City",

                // hintStyle: AppStyle.style(
                //   fontWeight: FontWeight.w300,
                //   size: AppDimensions.fontSize16(context),
                //   context: context,
                //   color: AppColors.grey,
                // ),
              ),
              hint: Text(
                "Select City",
                style: AppStyle.style(
                  fontWeight: FontWeight.w400,
                  size: AppDimensions.fontSize16(context),
                  context: context,
                  color: AppColors.grey,
                ),
              ),
              value: _selectedCity,
              items:
                  state.listOfCities
                      .asMap()
                      .entries
                      .map(
                        (e) => DropdownMenuItem(
                          value: e.value.cityId,
                          child: Text(
                            e.value.cityName,
                            style: AppStyle.style(
                              context: context,
                              color: AppColors.black,
                              fontWeight: FontWeight.w500,
                              size: AppDimensions.fontSize18(context),
                            ),
                          ),
                        ),
                      )
                      .toList(),
              onChanged: (value) {
                _selectedCity = value;
              },
            ),
            const AppSpacer(heightPortion: .01),
          ],
        );
      },
    );
  }

  _clearAll() {
    _nameController.clear();
    _emailAddress.clear();
    _mobileNumber.clear();
    _addressController.clear();
    _selectedCity = null;
  }
}
