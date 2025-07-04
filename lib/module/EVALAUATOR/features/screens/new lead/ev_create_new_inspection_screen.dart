

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/widgets/ev_app_custom_widgets.dart';
import 'package:wheels_kart/common/components/app_margin.dart';
import 'package:wheels_kart/common/components/app_spacer.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_colors.dart';
import 'package:wheels_kart/common/dimensions.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_style.dart';
import 'package:wheels_kart/common/utils/custome_show_messages.dart';
import 'package:wheels_kart/common/utils/routes.dart';
import 'package:wheels_kart/common/utils/validator.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/screens/inspect%20car/fill%20basic%20details/1_select_and_search_car_makes.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/bloc/get%20data/fetch%20car%20make/fetch_car_make_bloc.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/bloc/get%20data/fetch%20city/fetch_city_bloc.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/bloc/get%20data/fetch%20inspections/fetch_inspections_bloc.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/repositories/inspection/new_inspection_repo.dart';

class EvCreateInspectionScreen extends StatefulWidget {
  const EvCreateInspectionScreen({super.key});

  @override
  State<EvCreateInspectionScreen> createState() =>
      _EvCreateInspectionScreenState();
}

class _EvCreateInspectionScreenState extends State<EvCreateInspectionScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    context.read<EvFetchCityBloc>().add(OnFetchCityDataEvent(context: context));

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _mobileNumber.dispose();
    _emailAddress.dispose();
    _addressController.dispose();
    super.dispose();
  }

  final _nameController = TextEditingController();
  final _mobileNumber = TextEditingController();
  final _emailAddress = TextEditingController();
  final _addressController = TextEditingController();

  String? _selectedCity;
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar:AppBar(
      leading:evCustomBackButton(context),
      title: Text(
        "Create new lead",
        style: EvAppStyle.style(
          fontWeight: FontWeight.w600,
          size: AppDimensions.paddingSize15,
          context: context,
          color: EvAppColors.white,
        ),
      ),
      backgroundColor: EvAppColors.DEFAULT_BLUE_DARK,
    ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Column(
            children: [
              // Progress Indicator
              _buildProgressIndicator(),

              // Form Content
              Expanded(
                child: AppMargin(
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const AppSpacer(heightPortion: .02),

                          // Header Section
                          _buildHeaderSection(),

                          const AppSpacer(heightPortion: .03),

                          // Form Fields with Cards
                          _buildFormCard(
                            title: "Personal Information",
                            icon: Icons.person_outline,
                            children: [
                              _buildEnhancedTextField(
                                controller: _nameController,
                                label: "Full Name",
                                hint: "Enter customer's full name",
                                icon: Icons.person,
                                validator: Validator.validateRequired,
                                textCapitalization: TextCapitalization.words,
                              ),
                              const SizedBox(height: 20),
                              _buildEnhancedTextField(
                                controller: _mobileNumber,
                                label: "Mobile Number",
                                hint: "Enter 10-digit mobile number",
                                icon: Icons.phone,
                                keyboardType: TextInputType.phone,
                                maxLength: 10,
                                validator: Validator.validateMobileNumber,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                              ),
                            ],
                          ),

                          const AppSpacer(heightPortion: .02),

                          _buildFormCard(
                            title: "Contact Details",
                            icon: Icons.contact_mail_outlined,
                            children: [
                              _buildEnhancedTextField(
                                controller: _emailAddress,
                                label: "Email Address",
                                hint: "Enter customer's email",
                                icon: Icons.email,
                                keyboardType: TextInputType.emailAddress,
                                validator: Validator.validateEmail,
                              ),
                              const SizedBox(height: 20),
                              _buildEnhancedCityDropdown(),
                            ],
                          ),

                          const AppSpacer(heightPortion: .02),

                          _buildFormCard(
                            title: "Address Information",
                            icon: Icons.location_on_outlined,
                            children: [
                              _buildEnhancedTextField(
                                controller: _addressController,
                                label: "Address",
                                hint: "Enter complete address",
                                icon: Icons.home,
                                maxLines: 3,
                                validator: Validator.validateRequired,
                                textCapitalization:
                                    TextCapitalization.sentences,
                              ),
                            ],
                          ),

                          const AppSpacer(heightPortion: .04),

                          // Submit Button
                          _buildSubmitButton(),

                          const AppSpacer(heightPortion: .03),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: 0.7,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    EvAppColors.DEFAULT_BLUE_DARK,
                  ),
                  minHeight: 4,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                "70%",
                style: EvAppStyle.style(
                  context: context,
                  size: AppDimensions.fontSize15(context),
                  fontWeight: FontWeight.w600,
                  color: EvAppColors.DEFAULT_BLUE_DARK,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Step 1 of 1",
                style: EvAppStyle.style(
                  context: context,
                  size: AppDimensions.fontSize12(context),
                  color: EvAppColors.grey,
                ),
              ),
              Text(
                "Almost done!",
                style: EvAppStyle.style(
                  context: context,
                  size: AppDimensions.fontSize12(context),
                  color: EvAppColors.DEFAULT_BLUE_DARK,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            EvAppColors.DEFAULT_BLUE_DARK.withOpacity(0.1),
            EvAppColors.DEFAULT_BLUE_DARK.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: EvAppColors.DEFAULT_BLUE_DARK.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: EvAppColors.DEFAULT_BLUE_DARK,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.add_business,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Create New Inspection",
                  style: EvAppStyle.style(
                    context: context,
                    size: AppDimensions.fontSize18(context),
                    fontWeight: FontWeight.bold,
                    color: EvAppColors.DEFAULT_BLUE_DARK,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Fill in the customer details to schedule a vehicle inspection",
                  style: EvAppStyle.style(
                    context: context,
                    size: AppDimensions.fontSize15(context),
                    color: EvAppColors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: EvAppColors.DEFAULT_BLUE_DARK, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: EvAppStyle.style(
                  context: context,
                  size: AppDimensions.fontSize16(context),
                  fontWeight: FontWeight.w600,
                  color: EvAppColors.DEFAULT_BLUE_DARK,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildEnhancedTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int? maxLength,
    int maxLines = 1,
    List<TextInputFormatter>? inputFormatters,
    TextCapitalization textCapitalization = TextCapitalization.none,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: EvAppStyle.style(
            context: context,
            size: AppDimensions.fontSize15(context),
            fontWeight: FontWeight.w600,
            color: EvAppColors.DEFAULT_BLUE_DARK,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          maxLength: maxLength,
          maxLines: maxLines,
          inputFormatters: inputFormatters,
          textCapitalization: textCapitalization,
          style: EvAppStyle.style(
            context: context,
            size: AppDimensions.fontSize16(context),
            color: EvAppColors.black,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: EvAppStyle.style(
              context: context,
              size: AppDimensions.fontSize15(context),
              color: EvAppColors.grey.withOpacity(0.7),
            ),
            prefixIcon: Icon(
              icon,
              color: EvAppColors.DEFAULT_BLUE_DARK.withOpacity(0.7),
              size: 20,
            ),
            filled: true,
            fillColor: Colors.grey[50],
            counterText: "",
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: EvAppColors.DEFAULT_BLUE_DARK,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: EvAppColors.kRed, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: EvAppColors.kRed, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEnhancedCityDropdown() {
    return BlocBuilder<EvFetchCityBloc, EvFetchCityState>(
      builder: (context, state) {
        if (state is! FetchCitySuccessSate) {
          return const SizedBox(
            height: 60,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "City",
              style: EvAppStyle.style(
                context: context,
                size: AppDimensions.fontSize15(context),
                fontWeight: FontWeight.w600,
                color: EvAppColors.DEFAULT_BLUE_DARK,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedCity,
              validator: Validator.validateRequired,
              decoration: InputDecoration(
                hintText: "Select your city",
                hintStyle: EvAppStyle.style(
                  context: context,
                  size: AppDimensions.fontSize15(context),
                  color: EvAppColors.grey.withOpacity(0.7),
                ),
                prefixIcon: Icon(
                  Icons.location_city,
                  color: EvAppColors.DEFAULT_BLUE_DARK.withOpacity(0.7),
                  size: 20,
                ),
                filled: true,
                fillColor: Colors.grey[50],
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: EvAppColors.DEFAULT_BLUE_DARK,
                    width: 2,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: EvAppColors.kRed, width: 1.5),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: EvAppColors.kRed, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
              items:
                  state.listOfCities.map((city) {
                    return DropdownMenuItem<String>(
                      value: city.cityId,
                      child: Text(
                        city.cityName,
                        style: EvAppStyle.style(
                          context: context,
                          size: AppDimensions.fontSize16(context),
                          color: EvAppColors.black,
                        ),
                      ),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCity = value;
                });
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            EvAppColors.DEFAULT_BLUE_DARK,
            EvAppColors.DEFAULT_BLUE_DARK.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: EvAppColors.DEFAULT_BLUE_DARK.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: isLoading ? null : _handleSubmit,
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
            child: Center(
              child:
                  isLoading
                      ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                      : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.check_circle_outline,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "CREATE INSPECTION",
                            style: EvAppStyle.style(
                              context: context,
                              size: AppDimensions.fontSize16(context),
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
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
            context.read<FetchInspectionsBloc>().add(
              OnGetInspectionList(
                context: context,
                inspetionListType: 'ASSIGNED',
              ),
            );
            log(response['data'].toString());
            final inspectionID = response['data']['inspectionId'];

            _showSuccessBottomSheet(inspectionID);
            // Navigator.of(context).pop

            showSnakBar(context, response['message'], isError: false);
          } else {
            showSnakBar(context, response['message'], isError: true);
          }
        }
      } catch (e) {
        showSnakBar(
          context,
          'An error occurred. Please try again.',
          isError: true,
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _showSuccessBottomSheet(dynamic inspectionModel) {
    _clearAll();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
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
                const SizedBox(height: 24),

                // Success Animation
                TweenAnimationBuilder(
                  duration: const Duration(milliseconds: 1200),
                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  curve: Curves.elasticOut,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: EvAppColors.DEFAULT_BLUE_DARK.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check_circle,
                          size: 60,
                          color: EvAppColors.DEFAULT_BLUE_DARK,
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 24),

                Text(
                  'Vehicle Registered Successfully!',
                  textAlign: TextAlign.center,
                  style: EvAppStyle.style(
                    context: context,
                    size: AppDimensions.fontSize18(context),
                    fontWeight: FontWeight.bold,
                    color: EvAppColors.DEFAULT_BLUE_DARK,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  'Would you like to start the inspection now or schedule it for later?',
                  textAlign: TextAlign.center,
                  style: EvAppStyle.style(
                    context: context,
                    size: AppDimensions.fontSize15(context),
                    color: EvAppColors.grey,
                  ),
                ),

                const SizedBox(height: 32),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          showSnakBar(
                            context,
                            "Vehicle registered. You can complete inspection from dashboard.",
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(
                            color: EvAppColors.DEFAULT_BLUE_DARK,
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Later',
                          style: EvAppStyle.style(
                            context: context,
                            color: EvAppColors.DEFAULT_BLUE_DARK,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        onPressed: () => _handleInspectNow(inspectionModel),
                        icon: const Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 20,
                        ),
                        label: Text(
                          'Inspect Now',
                          style: EvAppStyle.style(
                            context: context,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: EvAppColors.DEFAULT_BLUE_DARK,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleInspectNow(dynamic inspectionId) async {
    final state = BlocProvider.of<EvFetchCarMakeBloc>(context).state;
    if (state is FetchCarMakeSuccessState) {
      Navigator.of(context).push(
        AppRoutes.createRoute(
          EvSelectAndSearchCarMakes(
            inspectuionId: inspectionId.toString(),
            listofCarMake: state.carMakeData,
          ),
        ),
      );
    } else {
      showSnakBar(context, 'Car make data not available. Please try again.');
    }
  }

  void _clearAll() {
    _nameController.clear();
    _emailAddress.clear();
    _mobileNumber.clear();
    _addressController.clear();
    setState(() {
      _selectedCity = null;
    });
  }
}
