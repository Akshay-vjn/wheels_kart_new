import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wheels_kart/common/components/app_spacer.dart';
import 'package:wheels_kart/common/dimensions.dart';
import 'package:wheels_kart/common/utils/custome_show_messages.dart';
import 'package:wheels_kart/common/utils/responsive_helper.dart';
import 'package:wheels_kart/module/Dealer/core/const/v_colors.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_colors.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_style.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/bloc/submit%20document/submit_document_cubit.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/bloc/get%20data/fetch%20documents/fetch_documents_cubit.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/model/document_data_model.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/widgets/ev_app_custom_widgets.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/widgets/ev_app_loading_indicator.dart';

class UploadCarLegals extends StatefulWidget {
  final String inspectionId;
  const UploadCarLegals({super.key, required this.inspectionId});

  @override
  State<UploadCarLegals> createState() => _UploadCarLegalsState();
}

class _UploadCarLegalsState extends State<UploadCarLegals> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  List<Map<String, dynamic>> rcDocument = [];
  List<Map<String, dynamic>> insuranceDocument = [];

  int? numberOfOwners;
  String? roadTaxPaid;
  String? insuranceType;
  String? carLength;
  int? numberOfKeys;

  TextEditingController roadTaxValidityController = TextEditingController();
  TextEditingController insuranceValidityController = TextEditingController();
  TextEditingController manufactureDateController = TextEditingController();
  TextEditingController registrationDateController = TextEditingController();
  TextEditingController currentRTOController = TextEditingController();
  TextEditingController cubicCapacityController = TextEditingController();

  final _scrollController = ScrollController();
  VehicleLgalModel? existingData;

  @override
  void initState() {
    super.initState();
    _loadExistingData();
  }

  Future<void> _loadExistingData() async {
    context.read<FetchDocumentsCubit>().onFetchDocumets(context, widget.inspectionId);
  }

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

  Future<void> _showPickImageSheet(String documentType) async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Select Image Source",
                  style: EvAppStyle.poppins(
                    fontWeight: FontWeight.w600,
                    size: 18,
                    color: VColors.BLACK,
                    context: context,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Choose how you want to upload your $documentType",
                  textAlign: TextAlign.center,
                  style: EvAppStyle.poppins(
                    fontWeight: FontWeight.w400,
                    size: 13,
                    color: Colors.grey[600],
                    context: context,
                  ),
                ),
                SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          await _pickImage(documentType, ImageSource.camera);
                          Navigator.pop(context);
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          decoration: BoxDecoration(
                            color: EvAppColors.black,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: EvAppColors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Icon(Icons.camera_alt_rounded, color: Colors.white, size: 32),
                              SizedBox(height: 12),
                              Text("Camera", style: EvAppStyle.poppins(
                                fontWeight: FontWeight.w600,
                                size: 14,
                                color: Colors.white,
                                context: context,
                              )),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          await _pickImage(documentType, ImageSource.gallery);
                          Navigator.pop(context);
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Column(
                            children: [
                              Icon(Icons.photo_library_rounded, color: EvAppColors.black, size: 32),
                              SizedBox(height: 12),
                              Text("Gallery", style: EvAppStyle.poppins(
                                fontWeight: FontWeight.w600,
                                size: 14,
                                color: EvAppColors.black,
                                context: context,
                              )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage(String documentType, ImageSource imageSource) async {
    final XFile? image = await _picker.pickImage(source: imageSource);
    if (image != null) {
      if (documentType == 'RC') {
        if (rcDocument.length < 2) {
          final doc = await _genarateImageJson(File(image.path), "RC (${rcDocument.length})", "2");
          rcDocument.add(doc);
          setState(() {});
        }
      } else if (documentType == 'Insurance') {
        if (insuranceDocument.length < 2) {
          final doc = await _genarateImageJson(File(image.path), "Insurance (${insuranceDocument.length})", "1");
          insuranceDocument.add(doc);
          setState(() {});
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

  bool _isUrlString(String value) {
    return value.startsWith('http://') || value.startsWith('https://');
  }

  void _populateExistingData(VehicleLgalModel vehicleLegalData) {
    final inspection = vehicleLegalData.inspection;

    if (inspection.noOfOwners.isNotEmpty) numberOfOwners = int.tryParse(inspection.noOfOwners);
    if (inspection.roadTaxPaid.isNotEmpty) roadTaxPaid = inspection.roadTaxPaid;
    if (inspection.roadTaxValidity.isNotEmpty) roadTaxValidityController.text = inspection.roadTaxValidity;
    if (inspection.insuranceType.isNotEmpty) insuranceType = inspection.insuranceType;
    if (inspection.insuranceValidity.isNotEmpty) insuranceValidityController.text = inspection.insuranceValidity;
    if (inspection.currentRto.isNotEmpty) currentRTOController.text = inspection.currentRto;
    if (inspection.carLength.isNotEmpty) carLength = inspection.carLength;
    if (inspection.cubicCapacity.isNotEmpty) cubicCapacityController.text = inspection.cubicCapacity;
    if (inspection.manufactureDate.isNotEmpty) manufactureDateController.text = inspection.manufactureDate;
    if (inspection.noOfKeys.isNotEmpty) numberOfKeys = int.tryParse(inspection.noOfKeys);
    if (inspection.regDate.isNotEmpty) registrationDateController.text = inspection.regDate;

    final insuranceDocs = vehicleLegalData.documents.where((doc) => doc.documentType == DocumentType.INSURANCE).toList();
    final rcDocs = vehicleLegalData.documents.where((doc) => doc.documentType == DocumentType.RC_CARD).toList();

    for (var doc in insuranceDocs) {
      insuranceDocument.add({
        'file': doc.document,
        'name': doc.documentName,
        'type': '1',
        'isUrl': true,
      });
    }

    for (var doc in rcDocs) {
      rcDocument.add({
        'file': doc.document,
        'name': doc.documentName,
        'type': '2',
        'isUrl': true,
      });
    }

    setState(() {});
  }

  /// 🧩 Fix: Normalize image data before submit
  List<Map<String, dynamic>> _prepareDocumentsForSubmit(List<Map<String, dynamic>> docs) {
    return docs.map((doc) {
      return {
        'documentId': doc['type'] ?? '',
        'fileName': doc['name'] ?? '',
        'file': doc['file'],
      };
    }).toList();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (insuranceDocument.isEmpty || rcDocument.isEmpty) {
        showSnakBar(context, "Upload the Documents", isError: true);
        _scrollController.jumpTo(0);
      } else {
        final preparedDocs = [
          ..._prepareDocumentsForSubmit(insuranceDocument),
          ..._prepareDocumentsForSubmit(rcDocument),
        ];

        context.read<SubmitDocumentCubit>().onSubmitDocument(
          context,
          widget.inspectionId,
          preparedDocs,
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FetchDocumentsCubit, FetchDocumentsState>(
      listener: (context, state) {
        if (state is FetchDocumentsSuccessState) {
          existingData = state.vehicleLgalModel;
          _populateExistingData(state.vehicleLgalModel);
        }
      },
      child: Scaffold(
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
            controller: _scrollController,
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Upload Documents'),
                SizedBox(height: 16),
                _buildDocumentUploadSection('RC Documents (Front & Back)', rcDocument, 'RC'),
                SizedBox(height: 16),
                _buildDocumentUploadSection('Insurance Documents', insuranceDocument, 'Insurance'),
                SizedBox(height: 24),
                _buildSectionTitle('Vehicle Information'),
                SizedBox(height: 16),
                _buildDropdown(
                  'Number of Owners',
                  numberOfOwners?.toString(),
                  List.generate(20, (i) => (i + 1).toString()),
                      (v) => setState(() => numberOfOwners = int.parse(v!)),
                ),
                SizedBox(height: 16),
                _buildDropdown(
                  'Road Tax Paid',
                  roadTaxPaid,
                  ['Life Time', 'Yearly', 'Tax Not Paid'],
                      (v) => setState(() => roadTaxPaid = v),
                ),
                SizedBox(height: 16),
                _buildDropdown(
                  'Insurance Type',
                  insuranceType,
                  ['Comprehensive', 'Third Party', 'Lapse'],
                      (v) => setState(() => insuranceType = v),
                ),
                SizedBox(height: 16),
                _buildDropdown(
                  'Car Length',
                  carLength,
                  ['Below 4 meters', '4-5 meters', 'Above 5 meters'],
                      (v) => setState(() => carLength = v),
                ),
                SizedBox(height: 16),
                _buildDropdown(
                  'Number of Keys',
                  numberOfKeys?.toString(),
                  ['0', '1', '2', '3', '4', '5+'],
                      (v) => setState(() => numberOfKeys = int.tryParse(v!) ?? 0),
                ),
                SizedBox(height: 24),
                _buildSectionTitle('Important Dates'),
                SizedBox(height: 16),
                _buildDateField('Road Tax Validity', roadTaxValidityController, 'Month/Year', () {}),
                SizedBox(height: 16),
                _buildDateField('Insurance Validity', insuranceValidityController, 'dd/mm/yyyy', () {}),
                SizedBox(height: 16),
                _buildDateField('Manufacture Date', manufactureDateController, 'Month/Year', () {}),
                SizedBox(height: 16),
                _buildDateField('Registration Date', registrationDateController, 'Month/Year', () {}),
                SizedBox(height: 24),
                _buildSectionTitle('Additional Information'),
                SizedBox(height: 16),
                _buildTextField('Current RTO', currentRTOController, 'Enter current RTO'),
                SizedBox(height: 16),
                _buildTextField('Cubic Capacity', cubicCapacityController, 'Enter cubic capacity', isNumeric: true),
                SizedBox(height: 32),
                BlocBuilder<SubmitDocumentCubit, SubmitDocumentState>(
                  builder: (context, state) {
                    if (state is SubmitDocumentLoadingState) {
                      return EVAppLoadingIndicator();
                    }
                    return SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: EvAppColors.DARK_PRIMARY,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                    );
                  },
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) => Text(
    title,
    style: EvAppStyle.style(
      context: context,
      size: AppDimensions.fontSize16(context),
      fontWeight: FontWeight.w600,
      color: EvAppColors.DARK_PRIMARY,
    ),
  );

  Widget _buildDocumentUploadSection(String title, List<Map<String, dynamic>> images, String documentType) {
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
          Text(title, style: EvAppStyle.style(context: context, size: AppDimensions.fontSize15(context))),
          SizedBox(height: 12),
          if (images.isNotEmpty)
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                itemBuilder: (context, index) {
                  final fileData = images[index]['file'] as String;
                  final isUrl = images[index]['isUrl'] ?? _isUrlString(fileData);
                  return Container(
                    margin: EdgeInsets.only(right: 8),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: isUrl
                              ? Image.network(fileData, width: 80, height: 80, fit: BoxFit.cover)
                              : Image.memory(base64Decode(fileData), width: 80, height: 80, fit: BoxFit.cover),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () => _removeImage(documentType, index),
                            child: Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(color: EvAppColors.kRed, shape: BoxShape.circle),
                              child: Icon(Icons.close, color: EvAppColors.white, size: 16),
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
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: images.length < 2 ? () => _showPickImageSheet(documentType) : null,
              icon: Icon(Icons.camera_alt, color: EvAppColors.DARK_PRIMARY),
              label: Text(
                images.length < 2 ? 'Take Photo' : 'Maximum photos uploaded',
                style: EvAppStyle.style(context: context, color: EvAppColors.DARK_PRIMARY),
              ),
            ),
          ),
          AppSpacer(heightPortion: .01),
          Align(
            child: Text("(Maximum 2 Photos)", style: EvAppStyle.poppins(context: context, color: EvAppColors.grey)),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String label, String? value, List<String> items, Function(String?) onChanged) {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: EvAppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: EvAppColors.grey.withOpacity(0.3)),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(labelText: label, border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: onChanged,
        validator: (v) => v == null || v.isEmpty ? 'Please select $label' : null,
      ),
    );
  }

  Widget _buildDateField(String label, TextEditingController controller, String format, VoidCallback onTap) {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: EvAppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: EvAppColors.grey.withOpacity(0.3)),
      ),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        onTap: onTap,
        decoration: InputDecoration(
          labelText: '$label ($format)',
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          suffixIcon: Icon(Icons.calendar_today, color: EvAppColors.DARK_PRIMARY),
        ),
        validator: (v) => v == null || v.isEmpty ? 'Please select $label' : null,
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, String hint, {bool isNumeric = false}) {
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
        inputFormatters: isNumeric ? [FilteringTextInputFormatter.digitsOnly] : null,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        validator: (v) => v == null || v.isEmpty ? 'Please enter $label' : null,
      ),
    );
  }

  Future<Map<String, dynamic>> _genarateImageJson(File file, String docName, String docId) async {
    final bytes = await file.readAsBytes();
    final base64 = base64Encode(bytes);
    final fileName = "$docName-${widget.inspectionId}.png";
    return {'documentId': docId, 'fileName': fileName, 'file': base64};
  }
}
