import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:wheels_kart/common/components/app_margin.dart';
import 'package:wheels_kart/common/components/app_spacer.dart';
import 'package:wheels_kart/common/dimensions.dart';
import 'package:wheels_kart/common/utils/validator.dart';
import 'package:wheels_kart/module/VENDOR/core/const/v_colors.dart';
import 'package:wheels_kart/module/VENDOR/features/screens/account/data/controller/profile%20controller/v_profile_controller_cubit.dart';
import 'package:wheels_kart/module/VENDOR/features/screens/account/data/model/v_profile_model.dart';
import 'package:wheels_kart/module/VENDOR/features/widgets/v_custom_backbutton.dart';
import 'package:wheels_kart/module/VENDOR/features/widgets/v_custom_button.dart';
import 'package:wheels_kart/module/VENDOR/features/widgets/v_custom_texfield.dart';
import 'package:wheels_kart/module/vendor/core/v_style.dart';

class VEditProfileScreen extends StatefulWidget {
  final VProfileModel model;
  VEditProfileScreen({super.key, required this.model});

  @override
  State<VEditProfileScreen> createState() => _VEditProfileScreenState();
}

class _VEditProfileScreenState extends State<VEditProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  final _locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: VColors.WHITE,
        leading: VCustomBackbutton(blendColor: VColors.DARK_GREY.withAlpha(50)),
        centerTitle: false,
        title: Text(
          "Edit Profile",
          style: VStyle.style(
            context: context,
            fontWeight: FontWeight.w800,
            size: 25,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: AppMargin(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: VColors.SECONDARY.withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 5),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(
                    AppDimensions.radiusSize15 + 5,
                  ),
                  color: VColors.WHITE,
                  border: Border.all(color: VColors.GREY.withOpacity(0.1)),
                ),
                padding: EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildField(
                        "Full Name",
                        _nameController,
                        SolarIconsOutline.user,
                        "Enter your name",
                        context,
                        (p0) {
                          return null;
                        },
                        isFirst: true,
                      ),
                      _buildField(
                        "Location",
                        _locationController,
                        CupertinoIcons.location,
                        "Enter your city",
                        context,
                        (p0) {
                          return null;
                        },
                      ),
                      _buildField(
                        "Email Address",
                        _emailController,
                        CupertinoIcons.mail,
                        "Enter your email",
                        context,
                        (p0) {
                          if (p0!.isNotEmpty) {
                            return Validator.validateEmail(p0);
                          }
                          return null;
                        },
                        isLast: true,
                      ),
                    ],
                  ),
                ),
              ),
              AppSpacer(heightPortion: .03),
              BlocBuilder<VProfileControllerCubit, VProfileControllerState>(
                builder: (context, state) {
                  return VCustomButton(
                    isLoading: state is VProfileControllerLoadingState,
                    title: "UPDATE",

                    onTap: () {
                      bool isDisabled =
                          _nameController.text.trim().isEmpty &&
                          _nameController.text.trim().isEmpty &&
                          _nameController.text.trim().isEmpty;

                      if (_formKey.currentState!.validate()) {
                        if (!isDisabled) {
                          final model = widget.model;
                          final name =
                              _nameController.text.trim().isEmpty
                                  ? model.vendorName
                                  : _nameController.text.trim();
                          final city =
                              _locationController.text.trim().isEmpty
                                  ? model.vendorCity
                                  : _locationController.text.trim();
                          final email =
                              _emailController.text.trim().isEmpty
                                  ? model.vendorEmail
                                  : _emailController.text.trim();
                          context.read<VProfileControllerCubit>().onEditProfile(
                            context,
                            name,
                            email,
                            city,
                          );
                        }
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller,
    IconData icon,
    String hintText,

    BuildContext context,
    String? Function(String?)? validator, {
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : 12, top: isFirst ? 0 : 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: VColors.GREY.withOpacity(0.05),
        border: Border.all(color: VColors.GREY.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: VColors.SECONDARY.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: VColors.SECONDARY, size: 18),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: VStyle.style(
                    context: context,
                    size: 12,
                    color: VColors.GREY,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                VCustomTexfield(
                  hintText: hintText,
                  validator: validator,
                  controller: controller,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
