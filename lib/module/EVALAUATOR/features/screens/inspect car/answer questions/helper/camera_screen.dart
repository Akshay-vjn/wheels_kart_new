import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_colors.dart';

class CameraScreen extends StatefulWidget {
  final Function(File) onImageCaptured;

  const CameraScreen({Key? key, required this.onImageCaptured})
    : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
    // Force landscape orientation - UNCOMMENTED
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();

    final rearCamera = _cameras!.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.back,
    );

    _cameraController = CameraController(
      rearCamera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    await _cameraController!.initialize();
    if (!mounted) return;
    setState(() {
      _isCameraInitialized = true;
    });
  }

  Future<void> _takePicture() async {
    if (!_cameraController!.value.isInitialized) return;

    try {
      final image = await _cameraController!.takePicture();

      final directory = await getTemporaryDirectory();
      final fileName = path.basename(image.path);
      final imagePath = path.join(directory.path, fileName);
      final File finalImage = File(imagePath);
      await finalImage.writeAsBytes(await image.readAsBytes());

      widget.onImageCaptured(finalImage);
      Navigator.of(context).pop(); // return to previous screen
    } catch (e) {
      print('Error taking picture: $e');
      // Show error message to user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to capture image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    // Reset to portrait orientation when leaving
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EvAppColors.black,
      body: _isCameraInitialized
          ? Stack(
              children: [
                // Full screen camera preview
                Positioned.fill(
                  child: CameraPreview(_cameraController!),
                ),
                
                // Camera controls overlay
                Positioned.fill(
                  child: SafeArea(
                    child: Column(
                      children: [
                        // Top bar with close button and instructions
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () => Navigator.of(context).pop(),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.black54,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    color: EvAppColors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                              
                              // Landscape instruction
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.screen_rotation,
                                      color: EvAppColors.white,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 4),
                                    const Text(
                                      'Landscape Mode',
                                      style: TextStyle(
                                        color: EvAppColors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const Spacer(),
                        
                        // Bottom controls
                        Padding(
                          padding: const EdgeInsets.all(30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                            
                              
                              // Capture button
                              InkWell(
                                overlayColor: const WidgetStatePropertyAll(
                                  Colors.transparent,
                                ),
                                onTap: _takePicture,
                                child: Container(
                                  padding: const EdgeInsets.all(25),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: EvAppColors.white,
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                      width: 4,
                                    ),
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.red,
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt,
                                      size: 32,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              
                              // Gallery button (optional)
                              // InkWell(
                              //   onTap: () {
                              //     // You can add gallery selection functionality here
                              //     ScaffoldMessenger.of(context).showSnackBar(
                              //       const SnackBar(
                              //         content: Text('Gallery selection coming soon'),
                              //       ),
                              //     );
                              //   },
                              //   child: Container(
                              //     padding: const EdgeInsets.all(15),
                              //     decoration: BoxDecoration(
                              //       color: Colors.black54,
                              //       borderRadius: BorderRadius.circular(40),
                              //     ),
                              //     child: const Icon(
                              //       Icons.photo_library,
                              //       color: EvAppColors.white,
                              //       size: 28,
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Grid overlay (optional - helps with composition)
                if (_showGrid) _buildGridOverlay(),
              ],
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    color: EvAppColors.white,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Initializing Camera...',
                    style: TextStyle(
                      color: EvAppColors.white,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Please rotate to landscape mode',
                    style: TextStyle(
                      color: EvAppColors.white.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  // Optional: Add grid overlay for better composition
  bool _showGrid = false;
  
  Widget _buildGridOverlay() {
    return Positioned.fill(
      child: CustomPaint(
        painter: GridPainter(),
      ),
    );
  }
}

// Optional: Grid painter for composition guidelines
class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..strokeWidth = 1;

    // Vertical lines
    canvas.drawLine(
      Offset(size.width / 3, 0),
      Offset(size.width / 3, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 2 / 3, 0),
      Offset(size.width * 2 / 3, size.height),
      paint,
    );

    // Horizontal lines
    canvas.drawLine(
      Offset(0, size.height / 3),
      Offset(size.width, size.height / 3),
      paint,
    );
    canvas.drawLine(
      Offset(0, size.height * 2 / 3),
      Offset(size.width, size.height * 2 / 3),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}