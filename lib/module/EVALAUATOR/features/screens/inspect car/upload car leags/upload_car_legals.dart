import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wheels_kart/common/dimensions.dart';
import 'package:wheels_kart/common/utils/custome_show_messages.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_colors.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_style.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/bloc/submit%20document/submit_document_cubit.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/widgets/ev_app_custom_widgets.dart';

class UploadCarLegals extends StatefulWidget {
  final String inspectionId;
  const UploadCarLegals({super.key, required this.inspectionId});

  @override
  State<UploadCarLegals> createState() => _UploadCarLegalsState();
}

class _UploadCarLegalsState extends State<UploadCarLegals> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  // Document images
  List<Map<String, dynamic>> rcDocument = [];
  List<Map<String, dynamic>> insuranceDocument = [];

  // Dropdown values
  int? numberOfOwners;
  String? roadTaxPaid;
  String? insuranceType;
  String? carLength;
  int? numberOfKeys;

  // Date controllers
  TextEditingController roadTaxValidityController = TextEditingController();
  TextEditingController insuranceValidityController = TextEditingController();
  TextEditingController manufactureDateController = TextEditingController();
  TextEditingController registrationDateController = TextEditingController();

  // Text field controllers
  TextEditingController currentRTOController = TextEditingController();
  TextEditingController cubicCapacityController = TextEditingController();

  // Date variables
  DateTime? roadTaxValidityDate;
  DateTime? insuranceValidityDate;
  DateTime? manufactureDate;
  DateTime? registrationDate;

  @override
  void dispose() {
    roadTaxValidityController.dispose();
    insuranceValidityController.dispose();
    manufactureDateController.dispose();
    registrationDateController.dispose();
    currentRTOController.dispose();
    cubicCapacityController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(String documentType) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      if (documentType == 'RC') {
        if (rcDocument.length < 2) {
          // rcImages.add(File(image.path));
          final doc = await _genarateImageJson(
            File(image.path),
            "RC (${rcDocument.length})",
            "2",
          );
          rcDocument.add(doc);
          setState(() {});
        }
      } else if (documentType == 'Insurance') {
        if (insuranceDocument.length < 2) {
          final doc = await _genarateImageJson(
            File(image.path),
            "Insurance (${insuranceDocument.length})",
            "1",
          );
          insuranceDocument.add(doc);
          setState(() {});
          // insuranceImages.add(File(image.path));
        }
      }
    }
  }

  void _removeImage(String documentType, int index) {
    setState(() {
      if (documentType == 'RC') {
        rcDocument.removeAt(index);
      } else if (documentType == 'Insurance') {
        insuranceDocument.removeAt(index);
      }
    });
  }

  Future<void> _selectMonthYear(
    TextEditingController controller,
    String title,
  ) async {
    DateTime initialDate = DateTime.now();

    showModalBottomSheet(
      context: context,
      builder: (context) {
        int selectedYear = initialDate.year;
        int selectedMonth = initialDate.month;

        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: 300,
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Select $title',
                    style: EvAppStyle.style(
                      context: context,
                      size: AppDimensions.fontSize18(context),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Month Picker
                      Expanded(
                        child: Column(
                          children: [
                            Text('Month'),
                            DropdownButton<int>(
                              value: selectedMonth,
                              items: List.generate(12, (index) {
                                return DropdownMenuItem(
                                  value: index + 1,
                                  child: Text(_getMonthName(index + 1)),
                                );
                              }),
                              onChanged: (value) {
                                setModalState(() {
                                  selectedMonth = value!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      // Year Picker
                      Expanded(
                        child: Column(
                          children: [
                            Text('Year'),
                            DropdownButton<int>(
                              value: selectedYear,
                              items: List.generate(50, (index) {
                                int year = DateTime.now().year - 25 + index;
                                return DropdownMenuItem(
                                  value: year,
                                  child: Text(year.toString()),
                                );
                              }),
                              onChanged: (value) {
                                setModalState(() {
                                  selectedYear = value!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      controller.text =
                          '${_getMonthName(selectedMonth)}/$selectedYear';
                      Navigator.pop(context);
                    },
                    child: Text('Select'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _selectDate(
    TextEditingController controller,
    String title,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now().add(Duration(days: 3650)),
    );
    if (picked != null) {
      setState(() {
        controller.text =
            '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
        if (title.contains('Insurance')) {
          insuranceValidityDate = picked;
        }
      });
    }
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (insuranceDocument.isEmpty || rcDocument.isEmpty) {
        showSnakBar(context, "Upload the Documents");
      } else {
        context.read<SubmitDocumentCubit>().onSubmitDocument(
          context,
          widget.inspectionId,
          [...insuranceDocument, ...rcDocument],
          numberOfOwners.toString(),
          roadTaxPaid.toString(),
          roadTaxValidityController.text,
          insuranceType.toString(),
          insuranceValidityController.text,
          currentRTOController.text,
          carLength.toString(),
          cubicCapacityController.text,
          manufactureDateController.text,
          numberOfKeys.toString(),
          registrationDateController.text,
        );
      }
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('Form submitted successfully!'),
      //     backgroundColor: EvAppColors.kGreen,
      //   ),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: EvAppColors.DARK_PRIMARY,
        leading: evCustomBackButton(context),
        title: Text(
          "Vehicle Legals",
          style: EvAppStyle.style(
            context: context,
            color: EvAppColors.white,
            size: AppDimensions.fontSize18(context),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Document Upload Section
              _buildSectionTitle('Upload Documents'),
              SizedBox(height: 16),

              // RC Documents
              _buildDocumentUploadSection('RC Documents', rcDocument, 'RC'),
              SizedBox(height: 16),

              // Insurance Documents
              _buildDocumentUploadSection(
                'Insurance Documents',
                insuranceDocument,
                'Insurance',
              ),
              SizedBox(height: 24),

              // Dropdown Section
              _buildSectionTitle('Vehicle Information'),
              SizedBox(height: 16),

              // Number of Owners
              _buildDropdown(
                'Number of Owners',
                numberOfOwners?.toString(),
                List.generate(20, (index) => (index + 1).toString()),
                (value) => setState(() => numberOfOwners = int.parse(value!)),
              ),
              SizedBox(height: 16),

              // Road Tax Paid
              _buildDropdown(
                'Road Tax Paid',
                roadTaxPaid,
                ['Life Time', 'Yearly', 'Tax Not Paid'],
                (value) => setState(() => roadTaxPaid = value),
              ),
              SizedBox(height: 16),

              // Insurance Type
              _buildDropdown(
                'Insurance Type',
                insuranceType,
                ['Comprehensive', 'Third Party', 'Lapse'],
                (value) => setState(() => insuranceType = value),
              ),
              SizedBox(height: 16),

              // Car Length
              _buildDropdown('Car Length', carLength, [
                'Below 4 meters',
                '4-5 meters',
                'Above 5 meters',
              ], (value) => setState(() => carLength = value)),
              SizedBox(height: 16),

              // Number of Keys
              _buildDropdown(
                'Number of Keys',
                numberOfKeys?.toString(),
                ['0', '1', '2', '3', '4', '5+'],
                (value) =>
                    setState(() => numberOfKeys = int.tryParse(value!) ?? 0),
              ),
              SizedBox(height: 24),

              // Date Pickers Section
              _buildSectionTitle('Important Dates'),
              SizedBox(height: 16),

              // Road Tax Validity (Month/Year)
              _buildDateField(
                'Road Tax Validity',
                roadTaxValidityController,
                'Month/Year',
                () => _selectMonthYear(
                  roadTaxValidityController,
                  'Road Tax Validity',
                ),
              ),
              SizedBox(height: 16),

              // Insurance Validity (dd/mm/yyyy)
              _buildDateField(
                'Insurance Validity',
                insuranceValidityController,
                'dd/mm/yyyy',
                () => _selectDate(
                  insuranceValidityController,
                  'Insurance Validity',
                ),
              ),
              SizedBox(height: 16),

              // Manufacture Date (Month/Year)
              _buildDateField(
                'Manufacture Date',
                manufactureDateController,
                'Month/Year',
                () => _selectMonthYear(
                  manufactureDateController,
                  'Manufacture Date',
                ),
              ),
              SizedBox(height: 16),

              // Registration Date (Month/Year)
              _buildDateField(
                'Registration Date',
                registrationDateController,
                'Month/Year',
                () => _selectMonthYear(
                  registrationDateController,
                  'Registration Date',
                ),
              ),
              SizedBox(height: 24),

              // Text Fields Section
              _buildSectionTitle('Additional Information'),
              SizedBox(height: 16),

              // Current RTO
              _buildTextField(
                'Current RTO',
                currentRTOController,
                'Enter current RTO',
              ),
              SizedBox(height: 16),

              // Cubic Capacity
              _buildTextField(
                'Cubic Capacity',
                cubicCapacityController,
                'Enter cubic capacity',
                isNumeric: true,
              ),
              SizedBox(height: 32),

              // Submit Button
              Container(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: EvAppColors.DARK_PRIMARY,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Submit Vehicle Legals',
                    style: EvAppStyle.style(
                      context: context,
                      color: EvAppColors.white,
                      size: AppDimensions.fontSize16(context),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: EvAppStyle.style(
        context: context,
        size: AppDimensions.fontSize16(context),
        fontWeight: FontWeight.w600,
        color: EvAppColors.DARK_PRIMARY,
      ),
    );
  }

  Widget _buildDocumentUploadSection(
    String title,
    List<Map<String, dynamic>> images,
    String documentType,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: EvAppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: EvAppColors.grey.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: EvAppStyle.style(
              context: context,
              size: AppDimensions.fontSize15(context),
              fontWeight: FontWeight.w500,
              color: EvAppColors.DARK_PRIMARY,
            ),
          ),
          SizedBox(height: 12),

          // Display uploaded images
          if (images.isNotEmpty)
            Container(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(right: 8),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.memory(
                            base64Decode(images[index]['file']),
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () => _removeImage(documentType, index),
                            child: Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: EvAppColors.kRed,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.close,
                                color: EvAppColors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

          SizedBox(height: 12),

          // Upload button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed:
                  images.length < 2 ? () => _pickImage(documentType) : null,
              icon: Icon(Icons.camera_alt, color: EvAppColors.DARK_PRIMARY),
              label: Text(
                images.length < 2
                    ? 'Take Photo (${images.length}/2)'
                    : 'Maximum 2 photos uploaded',
                style: EvAppStyle.style(
                  context: context,
                  color: EvAppColors.DARK_PRIMARY,
                  size: AppDimensions.fontSize12(context),
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: EvAppColors.DARK_PRIMARY),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    String? value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: EvAppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: EvAppColors.grey.withOpacity(0.3)),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        items:
            items.map((String item) {
              return DropdownMenuItem<String>(value: item, child: Text(item));
            }).toList(),
        onChanged: onChanged,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDateField(
    String label,
    TextEditingController controller,
    String format,
    VoidCallback onTap,
  ) {
    return Container(
      padding: EdgeInsets.only(bottom: 10),

      decoration: BoxDecoration(
        color: EvAppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: EvAppColors.grey.withOpacity(0.3)),
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: '$label ($format)',
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          suffixIcon: Icon(
            Icons.calendar_today,
            color: EvAppColors.DARK_PRIMARY,
          ),
        ),
        readOnly: true,
        onTap: onTap,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    String hint, {
    bool isNumeric = false,
  }) {
    return Container(
      padding: EdgeInsets.only(bottom: 10),

      decoration: BoxDecoration(
        color: EvAppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: EvAppColors.grey.withOpacity(0.3)),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        inputFormatters:
            isNumeric ? [FilteringTextInputFormatter.digitsOnly] : null,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  Future<Map<String, dynamic>> _genarateImageJson(
    File file,
    String docName,
    String docId,
  ) async {
    final bytes = await file.readAsBytes();
    final base64 = base64Encode(bytes);
    final fileName = "$docName-${widget.inspectionId}.png";

    return {'documentId': docId, 'fileName': fileName, 'file': base64};
  }
}
