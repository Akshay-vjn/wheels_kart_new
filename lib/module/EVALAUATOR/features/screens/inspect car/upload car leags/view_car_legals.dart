import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wheels_kart/common/utils/routes.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/bloc/get%20data/fetch%20documents/fetch_documents_cubit.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/model/document_data_model.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/screens/inspect%20car/upload%20car%20leags/upload_car_legals.dart';

// Assuming these models are imported from your project
// import 'package:wheels_kart/module/EVALAUATOR/data/model/vehicle_legal_model.dart';

class ViewCarLegals extends StatefulWidget {
  final String inspectionId;

  const ViewCarLegals({super.key, required this.inspectionId});

  @override
  State<ViewCarLegals> createState() => _ViewCarLegalsState();
}

class _ViewCarLegalsState extends State<ViewCarLegals> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Car Legal Documents',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<FetchDocumentsCubit, FetchDocumentsState>(
          builder: (context, state) {
            switch (state) {
              case FetchDocumentsSuccessState():
                {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Vehicle Inspection Details Card
                      _buildInspectionCard(state.vehicleLgalModel),
                      const SizedBox(height: 20),

                      // Documents Section
                      _buildDocumentsSection(state.vehicleLgalModel),
                      const SizedBox(height: 30),

                      // Update Legals Button
                      _buildUpdateButton(context, widget.inspectionId),
                      const SizedBox(height: 20),
                    ],
                  );
                }
              default:
                {
                  return SizedBox();
                }
            }
          },
        ),
      ),
    );
  }

  Widget _buildInspectionCard(VehicleLgalModel vehicleLegalData) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.directions_car, color: Colors.blue[600], size: 28),
                const SizedBox(width: 12),
                const Text(
                  'Vehicle Inspection Details',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Grid of inspection details
            _buildDetailGrid(vehicleLegalData),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailGrid(VehicleLgalModel vehicleLegalData) {
    final inspection = vehicleLegalData.inspection;

    final inspectionData = {
      'Number of Owners': inspection.noOfOwners,
      'Road Tax': inspection.roadTaxPaid,
      'Road Tax Validity': inspection.roadTaxValidity,
      'Insurance Type': inspection.insuranceType,
      'Insurance Validity': _formatDate(
        inspection.insuranceValidity.toString(),
      ),
      'Current RTO': inspection.currentRto,
      'Car Length': inspection.carLength,
      'Cubic Capacity': inspection.cubicCapacity,
      'Manufacture Date': inspection.manufactureDate,
      'Number of Keys': inspection.noOfKeys,
      'Registration Date': inspection.regDate,
    };

    return Column(
      children:
          inspectionData.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      entry.key,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const Text(': ', style: TextStyle(color: Colors.black54)),
                  Expanded(
                    flex: 3,
                    child: Text(
                      entry.value,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }

  Widget _buildDocumentsSection(VehicleLgalModel vehicleLegalData) {
    final insuranceDocuments =
        vehicleLegalData.documents
            .where((doc) => doc.documentType == DocumentType.INSURANCE)
            .toList();

    final rcDocuments =
        vehicleLegalData.documents
            .where((doc) => doc.documentType == DocumentType.RC_CARD)
            .toList();

    return rcDocuments.isEmpty && insuranceDocuments.isEmpty
        ? SizedBox.shrink()
        : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.description, color: Colors.green[600], size: 28),
                const SizedBox(width: 12),
                const Text(
                  'Uploaded Documents',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Insurance Documents
            if (insuranceDocuments.isNotEmpty)
              _buildDocumentTypeSection(
                'Insurance Documents',
                insuranceDocuments,
              ),

            if (insuranceDocuments.isNotEmpty && rcDocuments.isNotEmpty)
              const SizedBox(height: 16),

            // RC Card Documents
            if (rcDocuments.isNotEmpty)
              _buildDocumentTypeSection('RC Card Documents', rcDocuments),
          ],
        );
  }

  Widget _buildDocumentTypeSection(String title, List<Document> documents) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${documents.length}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            ...documents.map((doc) => _buildDocumentItem(doc)),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentItem(Document document) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: _getStatusColor(document.status).withOpacity(0.2),
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: Icon(
              _getStatusIcon(document.status),
              color: _getStatusColor(document.status),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  document.documentName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'Status: ',
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      _getStatusText(document.status),
                      style: TextStyle(
                        color: _getStatusColor(document.status),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Text(
                  'Uploaded: ${_formatDate(document.createdAt.date.toString())}',
                  style: const TextStyle(color: Colors.black54, fontSize: 12),
                ),
                Text(
                  'Uploaded by: User ${document.uploadedBy}',
                  style: const TextStyle(color: Colors.black54, fontSize: 12),
                ),
              ],
            ),
          ),

          Row(
            children: [
              // IconButton(
              //   onPressed: () => _viewDocument(document),
              //   icon: const Icon(Icons.visibility, color: Colors.blue),
              //   tooltip: 'View Document',
              // ),
              IconButton(
                onPressed: () => _deletDoc(document, context),
                icon: const Icon(Icons.delete, color: Colors.red),
                tooltip: 'View Document',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUpdateButton(BuildContext context, String inspectionId) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () => _handleUpdateLegals(context, inspectionId),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[600],
          foregroundColor: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.edit_document, size: 24),
            SizedBox(width: 12),
            Text(
              'Update Legals',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods
  Color _getStatusColor(Status status) {
    switch (status) {
      case Status.APPROVED:
        return Colors.green;
    }
  }

  IconData _getStatusIcon(Status status) {
    switch (status) {
      case Status.APPROVED:
        return Icons.check_circle;
    }
  }

  String _getStatusText(Status status) {
    switch (status) {
      case Status.APPROVED:
        return 'APPROVED';
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  void _viewDocument(Document document) {
    // Handle document viewing - you can implement this based on your requirements
    // For example, open the document URL in a web view or download it
    print('Viewing document: ${document.document}');
  }

  void _deletDoc(Document document, BuildContext context) {
    context.read<FetchDocumentsCubit>().deleteDocument(
      context,
      widget.inspectionId,
      document.inspectionDocumentId,
    );
  }

  void _handleUpdateLegals(BuildContext context, String inspectionId) {
    // Handle update legals functionality
    // You can navigate to an update screen or show a dialog
    Navigator.of(context).pushReplacement(
      AppRoutes.createRoute(UploadCarLegals(inspectionId: inspectionId)),
    );
  }
}

//
