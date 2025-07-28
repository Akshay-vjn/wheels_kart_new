import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/widgets/ev_app_loading_indicator.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_colors.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_style.dart';
import 'package:wheels_kart/common/utils/intl_helper.dart';
import 'package:wheels_kart/common/utils/routes.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/screens/inspect%20car/fill%20basic%20details/1_select_and_search_car_makes.dart';
import 'package:wheels_kart/module/EVALAUATOR/features/screens/inspect%20car/inspection_start_screen.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/bloc/get%20data/fetch%20car%20make/fetch_car_make_bloc.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/bloc/get%20data/fetch%20inspections/fetch_inspections_bloc.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/model/inspection_data_model.dart';
import 'package:wheels_kart/module/EVALAUATOR/data/repositories/master/fetch_the_instruction_repo.dart';

class EvLiveLeadsTab extends StatefulWidget {
  const EvLiveLeadsTab({super.key});

  @override
  State<EvLiveLeadsTab> createState() => _EvLiveLeadsTabState();
}

class _EvLiveLeadsTabState extends State<EvLiveLeadsTab>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    context.read<EvFetchCarMakeBloc>().add(
      InitalFetchCarMakeEvent(context: context),
    );
   _loadInspections();

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadInspections() async {
    context.read<FetchInspectionsBloc>().add(
      OnGetInspectionList(context: context, inspetionListType: 'ASSIGNED'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.grey[50]!, Colors.white],
        ),
      ),
      child: RefreshIndicator.adaptive(
        onRefresh: () async {
          await _loadInspections();
          _animationController.reset();
          _animationController.forward();
        },
        color: EvAppColors.DEFAULT_BLUE_DARK,
        backgroundColor: Colors.white,
        child: BlocBuilder<FetchInspectionsBloc, FetchInspectionsState>(
          builder: (context, state) {
            switch (state) {
              case LoadingFetchInspectionsState():
                return Center(child: EVAppLoadingIndicator());
              case SuccessFetchInspectionsState():
                return state.listOfInspection.isEmpty
                    ? _buildEmptyState(state.message)
                    : _buildInspectionList(state.listOfInspection);
              case ErrorFetchInspectionsState():
                return _buildErrorState(state.errormessage);
              default:
                return const SizedBox();
            }
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.assignment_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Active Inspections',
            style: EvAppStyle.style(
              context: context,
              size: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: EvAppStyle.style(
              context: context,
              size: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
          const SizedBox(height: 16),
          Text(
            'Something went wrong',
            style: EvAppStyle.style(
              context: context,
              size: 18,
              fontWeight: FontWeight.bold,
              color: Colors.red[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: EvAppStyle.style(
              context: context,
              size: 14,
              color: Colors.red[500],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _loadInspections,
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
            style: ElevatedButton.styleFrom(
              backgroundColor: EvAppColors.DEFAULT_BLUE_DARK,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInspectionList(List<InspectionModel> inspections) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: inspections.length,
      itemBuilder: (context, index) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300 + (index * 100)),
              margin: EdgeInsets.only(
                bottom: index + 1 == inspections.length ? 80 : 16,
              ),
              child: _buildEnhancedInspectionCard(context, inspections[index]),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEnhancedInspectionCard(
    BuildContext context,
    InspectionModel inspectionModel,
  ) {
    final bool isVehicleRegistered =
        inspectionModel.engineTypeId.isNotEmpty &&
        inspectionModel.engineTypeId != '0';
    final bool canInspect = isVehicleRegistered;

    return Card(
      elevation: 4,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Colors.grey[50]!],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCardHeader(inspectionModel),
            _buildCustomerDetails(inspectionModel),
            _buildActionButtons(
              context,
              inspectionModel,
              isVehicleRegistered,
              canInspect,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardHeader(InspectionModel inspectionModel) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            EvAppColors.DEFAULT_BLUE_DARK,
            EvAppColors.DEFAULT_BLUE_DARK.withOpacity(0.8),
          ],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'INSPECTION ID',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  inspectionModel.evaluationId,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: Colors.white.withOpacity(0.9),
                  size: 15,
                ),
                const SizedBox(height: 4),
                Text(
                  IntlHelper.converToDate(inspectionModel.createdAt.date),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerDetails(InspectionModel inspectionModel) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Customer Details',
            style: EvAppStyle.style(
              context: context,
              size: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildDetailItem(
                  icon: SolarIconsOutline.userCircle,
                  label: 'Name',
                  value: inspectionModel.customer.customerName,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDetailItem(
                  icon: SolarIconsOutline.phoneCallingRounded,
                  label: 'Phone',
                  value: inspectionModel.customer.customerMobileNumber,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: EvAppStyle.style(
              context: context,
              size: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[800],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    InspectionModel inspectionModel,
    bool isVehicleRegistered,
    bool canInspect,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: _buildActionButton(
              label: 'Register Vehicle',
              icon: Icons.directions_car,
              isCompleted: isVehicleRegistered,
              onTap: () => _onRegisterVehicle(context, inspectionModel),
              backgroundColor:
                  isVehicleRegistered ? Colors.green : Colors.orange,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildActionButton(
              label: 'Start Inspection',
              icon: Icons.search,
              isCompleted: false,
              isEnabled: canInspect,
              onTap:
                  canInspect
                      ? () => _onStartInspection(context, inspectionModel)
                      : null,
              backgroundColor:
                  canInspect ? EvAppColors.kAppSecondaryColor : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required bool isCompleted,
    bool isEnabled = true,
    required VoidCallback? onTap,
    required Color backgroundColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
        decoration: BoxDecoration(
          color:
              isEnabled ? backgroundColor.withOpacity(0.1) : Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isEnabled ? backgroundColor : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isCompleted ? Icons.check_circle : icon,
              color: isEnabled ? backgroundColor : Colors.grey[400],
              size: 20,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  color: isEnabled ? backgroundColor : Colors.grey[400],
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onRegisterVehicle(
    BuildContext context,
    InspectionModel inspectionModel,
  ) {
    final state = BlocProvider.of<EvFetchCarMakeBloc>(context).state;
    if (state is FetchCarMakeSuccessState) {
      Navigator.of(context).push(
        AppRoutes.createRoute(
          EvSelectAndSearchCarMakes(
            inspectuionId: inspectionModel.inspectionId,
            listofCarMake: state.carMakeData,
          ),
        ),
      );
    } else {
      _showErrorSnackBar(
        context,
        'Car make data not available. Please try again.',
      );
    }
  }

  void _onStartInspection(
    BuildContext context,
    InspectionModel inspectionModel,
  ) async {
    if (inspectionModel.engineTypeId.isEmpty ||
        inspectionModel.engineTypeId == '0') {
      _showWarningDialog(
        context,
        'Vehicle Registration Required',
        'Please complete the vehicle registration before starting the inspection.',
      );
      return;
    }

    _showLoadingDialog(context);

    try {
      if (inspectionModel.engineTypeId == '1') {
        final snapshot =
            await FetchTheInstructionRepo.getTheInstructionForStartEngine(
              context,
              inspectionModel.engineTypeId,
            );

        Navigator.of(context).pop(); // Close loading dialog

        if (snapshot['error'] == true) {
          _showErrorSnackBar(context, snapshot['message']);
        } else if (snapshot.isEmpty) {
          _showErrorSnackBar(context, 'Instruction page not found!');
        } else if (snapshot['error'] == false) {
          Navigator.of(context).push(
            AppRoutes.createRoute(
              InspectionStartScreen(
                inspectionId: inspectionModel.inspectionId,
                instructionData: snapshot['data'][0]['instructions'],
              ),
            ),
          );
        }
      } else {
        Navigator.of(context).pop(); // Close loading dialog
        Navigator.of(context).push(
          AppRoutes.createRoute(
            InspectionStartScreen(
              instructionData: null,
              inspectionId: inspectionModel.inspectionId,
            ),
          ),
        );
      }
    } catch (e) {
      Navigator.of(context).pop(); // Close loading dialog
      _showErrorSnackBar(context, 'An error occurred. Please try again.');
    }
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => const Center(
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Loading instructions...'),
                  ],
                ),
              ),
            ),
          ),
    );
  }

  void _showWarningDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(Icons.warning_amber, color: Colors.orange[600]),
                const SizedBox(width: 12),
                Text(title),
              ],
            ),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        action: SnackBarAction(
          label: 'DISMISS',
          textColor: Colors.white,
          onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
        ),
      ),
    );
  }
}
