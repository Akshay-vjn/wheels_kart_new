//
// import 'dart:io';
// import 'dart:math';
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:path/path.dart' as path;
// import 'package:path_provider/path_provider.dart';
// import 'package:flutter/services.dart';
// import 'package:wheels_kart/module/EVALAUATOR/core/ev_colors.dart';
//
// class CameraScreen extends StatefulWidget {
//   bool? isFromVhiclePhotoScreen;
//   final Function(File) onImageCaptured;
//
//   CameraScreen({
//     Key? key,
//     required this.onImageCaptured,
//     this.isFromVhiclePhotoScreen,
//   }) : super(key: key);
//
//   @override
//   State<CameraScreen> createState() => _CameraScreenState();
// }
//
// class _CameraScreenState extends State<CameraScreen>
//     with TickerProviderStateMixin {
//   CameraController? _cameraController;
//   List<CameraDescription>? _cameras;
//   bool _isCameraInitialized = false;
//   bool _isCapturing = false;
//
//   // Zoom functionality
//   double _currentZoomLevel = 1.0;
//   double _minZoomLevel = 1.0;
//   double _maxZoomLevel = 1.0;
//
//   // Focus functionality
//   Offset? _focusPoint;
//   bool _showFocusCircle = false;
//
//   // Animation controllers
//   late AnimationController _focusAnimationController;
//   late AnimationController _captureAnimationController;
//   late Animation<double> _focusAnimation;
//   late Animation<double> _captureAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//     _initCamera();
//     _initAnimations();
//
//     // Force landscape orientation
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.landscapeLeft,
//       DeviceOrientation.landscapeRight,
//     ]);
//
//     // Hide status bar for immersive experience
//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
//   }
//
//   void _initAnimations() {
//     _focusAnimationController = AnimationController(
//       duration: const Duration(milliseconds: 1500),
//       vsync: this,
//     );
//
//     _captureAnimationController = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );
//
//     _focusAnimation = Tween<double>(begin: 1.0, end: 0.5).animate(
//       CurvedAnimation(
//         parent: _focusAnimationController,
//         curve: Curves.easeInOut,
//       ),
//     );
//
//     _captureAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
//       CurvedAnimation(
//         parent: _captureAnimationController,
//         curve: Curves.elasticOut,
//       ),
//     );
//   }
//
//   Future<void> _initCamera() async {
//     try {
//       _cameras = await availableCameras();
//
//       final rearCamera = _cameras!.firstWhere(
//             (camera) => camera.lensDirection == CameraLensDirection.back,
//       );
//
//       _cameraController = CameraController(
//         rearCamera,
//
//         ResolutionPreset.high,
//         enableAudio: false,
//         imageFormatGroup: ImageFormatGroup.jpeg,
//       );
//       await _cameraController!.initialize();
//
//       // Get zoom capabilities
//       _maxZoomLevel = await _cameraController!.getMaxZoomLevel();
//       _minZoomLevel = await _cameraController!.getMinZoomLevel();
//       // NEW: compute allowed zoom steps and apply 1x
//       _zoomSteps = _computeZoomSteps();
//       await _applyZoom(_zoomSteps.first);
//
//       if (!mounted) return;
//       setState(() {
//         _isCameraInitialized = true;
//       });
//     } catch (e) {
//       print('Error initializing camera: $e');
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Camera initialization failed: $e'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     }
//   }
//
//   void _onScaleStart(ScaleStartDetails details) {
//     // Store the initial zoom level when scaling starts
//   }
//
//   void _onScaleUpdate(ScaleUpdateDetails details) {
//     if (!_isCameraInitialized) return;
//
//     // Calculate new zoom level
//     final newZoomLevel = (_currentZoomLevel * details.scale).clamp(
//       _minZoomLevel,
//       _maxZoomLevel,
//     );
//
//     // Apply zoom
//     _cameraController!.setZoomLevel(newZoomLevel);
//
//     setState(() {
//       _currentZoomLevel = newZoomLevel;
//     });
//   }
//
//   void _onTapDown(TapDownDetails details) {
//     if (!_isCameraInitialized) return;
//
//     final RenderBox renderBox = context.findRenderObject() as RenderBox;
//     final tapPosition = renderBox.globalToLocal(details.globalPosition);
//
//     // Convert tap position to camera coordinates (0.0 to 1.0)
//     final double x = tapPosition.dx / renderBox.size.width;
//     final double y = tapPosition.dy / renderBox.size.height;
//
//     // Set focus and exposure point
//     _cameraController!.setFocusPoint(Offset(x, y));
//     _cameraController!.setExposurePoint(Offset(x, y));
//
//     // Show focus animation
//     setState(() {
//       _focusPoint = tapPosition;
//       _showFocusCircle = true;
//     });
//
//     _focusAnimationController.forward().then((_) {
//       _focusAnimationController.reset();
//       setState(() {
//         _showFocusCircle = false;
//       });
//     });
//   }
//
//   Future<void> _takePicture() async {
//     if (!_cameraController!.value.isInitialized || _isCapturing) return;
//
//     setState(() {
//       _isCapturing = true;
//     });
//
//     // Trigger capture animation
//     _captureAnimationController.forward().then((_) {
//       _captureAnimationController.reset();
//     });
//
//     try {
//       // Add haptic feedback
//       HapticFeedback.mediumImpact();
//
//       final image = await _cameraController!.takePicture();
//
//       final directory = await getTemporaryDirectory();
//       final fileName = 'IMG_${DateTime.now().millisecondsSinceEpoch}.jpg';
//       final imagePath = path.join(directory.path, fileName);
//       final File finalImage = File(imagePath);
//       await finalImage.writeAsBytes(await image.readAsBytes());
//
//       widget.onImageCaptured(finalImage);
//       Navigator.of(context).pop();
//     } catch (e) {
//       print('Error taking picture: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to capture image: $e'),
//           backgroundColor: Colors.red,
//           behavior: SnackBarBehavior.floating,
//         ),
//       );
//     } finally {
//       setState(() {
//         _isCapturing = false;
//       });
//     }
//   }
//
//   Widget _buildZoomIndicator() {
//     if (_currentZoomLevel <= 1.0) return const SizedBox.shrink();
//
//     return Positioned(
//       top: 80,
//       left: 20,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//         decoration: BoxDecoration(
//           color: Colors.black54,
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Text(
//           '${_currentZoomLevel.toStringAsFixed(1)}x',
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 14,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildFocusCircle() {
//     if (!_showFocusCircle || _focusPoint == null) {
//       return const SizedBox.shrink();
//     }
//
//     return Positioned(
//       left: _focusPoint!.dx - 40,
//       top: _focusPoint!.dy - 40,
//       child: AnimatedBuilder(
//         animation: _focusAnimation,
//         builder: (context, child) {
//           return Transform.scale(
//             scale: _focusAnimation.value,
//             child: Container(
//               width: 80,
//               height: 80,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 border: Border.all(color: Colors.white, width: 2),
//               ),
//               child: const Icon(
//                 Icons.center_focus_strong,
//                 color: Colors.white,
//                 size: 24,
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildGridOverlay() {
//     return CustomPaint(size: Size.infinite, painter: GridPainter());
//   }
//
//   Widget _buildZoomControls() {
//     if (_zoomSteps.isEmpty) return const SizedBox.shrink();
//     return Positioned(
//       right: 20,
//       // bottom: 20,
//       top: 20,
//       child: SafeArea(
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
//           decoration: BoxDecoration(
//             color: Colors.black54,
//             borderRadius: BorderRadius.circular(28),
//             border: Border.all(color: Colors.white24, width: 1),
//           ),
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children:
//             _zoomSteps.map((z) {
//               final selected = (z - _currentZoomLevel).abs() < 0.05;
//               return Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 4),
//                 child: GestureDetector(
//                   onTap: () => _applyZoom(z),
//                   child: AnimatedContainer(
//                     duration: const Duration(milliseconds: 180),
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 12,
//                       vertical: 12,
//                     ),
//                     decoration: BoxDecoration(
//                       color: selected ? Colors.white : Colors.transparent,
//                       borderRadius: BorderRadius.circular(20),
//                       border: Border.all(color: Colors.white24, width: 1),
//                     ),
//                     child: Text(
//                       '${z.toStringAsFixed(z.truncateToDouble() == z ? 0 : 1)}x',
//                       style: TextStyle(
//                         color: selected ? Colors.black : Colors.white,
//                         fontWeight: FontWeight.w700,
//                         fontSize: 12,
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             }).toList(),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // add under zoom fields
//   List<double> _zoomSteps = [1]; // will be recalculated after init
//
//   Future<void> _applyZoom(double level) async {
//     if (!_isCameraInitialized) return;
//     final clamped = level.clamp(_minZoomLevel, _maxZoomLevel);
//     await _cameraController!.setZoomLevel(clamped);
//     setState(() => _currentZoomLevel = clamped);
//   }
//
//   // build step list like [1x, 2x, 3x, 5x] but never above max
//   List<double> _computeZoomSteps() {
//     final candidates = <double>[1, 2, 3, 5, 10];
//     return candidates.where((z) => z <= _maxZoomLevel + 1e-6).toList()..sort();
//   }
//
//   @override
//   void dispose() {
//     _cameraController?.dispose();
//     _focusAnimationController.dispose();
//     _captureAnimationController.dispose();
//
//     // Reset system UI and orientation
//
//     if (widget.isFromVhiclePhotoScreen == null) {
//       SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
//       SystemChrome.setPreferredOrientations([
//         DeviceOrientation.portraitUp,
//         DeviceOrientation.portraitDown,
//       ]);
//     }
//
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body:
//       _isCameraInitialized
//           ? GestureDetector(
//         onScaleStart: _onScaleStart,
//         onScaleUpdate: _onScaleUpdate,
//         onTapDown: _onTapDown,
//         child: Stack(
//           children: [
//             // Full screen camera preview
//             Positioned.fill(
//               child: ClipRect(
//                 child: OverflowBox(
//                   alignment: Alignment.center,
//                   child: FittedBox(
//                     fit: BoxFit.fitWidth,
//                     child: SizedBox(
//                       width: MediaQuery.of(context).size.width,
//                       height:
//                       MediaQuery.of(context).size.width /
//                           _cameraController!.value.aspectRatio,
//                       child: CameraPreview(_cameraController!),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//
//             // Grid overlay
//             _buildGridOverlay(),
//
//             // Top controls
//             Positioned(
//               top: 0,
//               left: 0,
//               right: 0,
//               child: SafeArea(
//                 child: Padding(
//                   padding: const EdgeInsets.all(20),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       // Close button
//                       GestureDetector(
//                         onTap: () => Navigator.of(context).pop(),
//                         child: Container(
//                           padding: const EdgeInsets.all(10),
//                           decoration: BoxDecoration(
//                             color: Colors.black45,
//                             shape: BoxShape.circle,
//                             border: Border.all(
//                               color: Colors.white24,
//                               width: 1,
//                             ),
//                           ),
//                           child: const Icon(
//                             Icons.close,
//                             color: Colors.white,
//                             size: 24,
//                           ),
//                         ),
//                       ),
//
//                       // Instructions
//                       // Container(
//                       //   padding: const EdgeInsets.symmetric(
//                       //     horizontal: 16,
//                       //     vertical: 8,
//                       //   ),
//                       //   decoration: BoxDecoration(
//                       //     color: Colors.black45,
//                       //     borderRadius: BorderRadius.circular(25),
//                       //     border: Border.all(
//                       //       color: Colors.white24,
//                       //       width: 1,
//                       //     ),
//                       //   ),
//                       //   child: Row(
//                       //     mainAxisSize: MainAxisSize.min,
//                       //     children: [
//                       //       const Icon(
//                       //         Icons.pinch,
//                       //         color: Colors.white70,
//                       //         size: 16,
//                       //       ),
//                       //       const SizedBox(width: 6),
//                       //       const Text(
//                       //         'Tap to focus',
//                       //         style: TextStyle(
//                       //           color: Colors.white70,
//                       //           fontSize: 12,
//                       //           fontWeight: FontWeight.w500,
//                       //         ),
//                       //       ),
//                       //     ],
//                       //   ),
//                       // ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//
//             // Zoom level indicator
//             _buildZoomIndicator(),
//
//             // Focus circle
//             _buildFocusCircle(),
//
//             // Bottom capture button
//             Positioned(
//               top: 0,
//               bottom: 0,
//               // bottom: 0,
//               // left: 0,
//               right: 120,
//               // top: 0,
//               child: Center(
//                 child: AnimatedBuilder(
//                   animation: _captureAnimation,
//                   builder: (context, child) {
//                     return Transform.scale(
//                       scale: _captureAnimation.value,
//                       child: GestureDetector(
//                         onTap: _takePicture,
//                         child: Container(
//                           width: 80,
//                           height: 80,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: Colors.white,
//                             border: Border.all(
//                               color: Colors.white,
//                               width: 4,
//                             ),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black26,
//                                 blurRadius: 10,
//                                 offset: const Offset(0, 4),
//                               ),
//                             ],
//                           ),
//                           child: Container(
//                             margin: const EdgeInsets.all(6),
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               color:
//                               _isCapturing
//                                   ? Colors.red.shade400
//                                   : Colors.red,
//                             ),
//                             child:
//                             _isCapturing
//                                 ? const SizedBox(
//                               width: 24,
//                               height: 24,
//                               child: CircularProgressIndicator(
//                                 color: Colors.white,
//                                 strokeWidth: 2,
//                               ),
//                             )
//                                 : const Icon(
//                               Icons.camera_alt,
//                               size: 32,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),
//
//             // Zoom controls (1x, 2x, ...)
//             _buildZoomControls(),
//           ],
//         ),
//       )
//           : Container(
//         color: const Color.fromRGBO(0, 0, 0, 1),
//         child: SafeArea(
//           child: Column(
//             // mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Row(
//                 children: [
//                   // Container(
//                   //   margin: const EdgeInsets.all(8),
//                   //   decoration: BoxDecoration(
//                   //     color: Colors.grey[100],
//                   //     borderRadius: BorderRadius.circular(12),
//                   //   ),
//                   //   child: IconButton(
//                   //     icon: const Icon(
//                   //       Icons.arrow_back_ios_new,
//                   //       color: Colors.black87,
//                   //     ),
//                   //     onPressed: () => Navigator.of(context).pop(),
//                   //   ),
//                   // ),
//                   GestureDetector(
//                     onTap: () => Navigator.of(context).pop(),
//                     child: Container(
//                       padding: const EdgeInsets.all(10),
//                       decoration: BoxDecoration(
//                         color: Colors.black45,
//                         shape: BoxShape.circle,
//                         border: Border.all(
//                           color: Colors.white24,
//                           width: 1,
//                         ),
//                       ),
//                       child: const Icon(
//                         Icons.close,
//                         color: Colors.white,
//                         size: 24,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               Container(
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: Colors.white10,
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: Column(
//                   children: [
//                     const SizedBox(
//                       width: 40,
//                       height: 40,
//                       child: CircularProgressIndicator(
//                         color: Colors.white,
//                         strokeWidth: 3,
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     const Text(
//                       'Initializing Camera...',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       'Please keep device in landscape mode',
//                       style: TextStyle(
//                         color: Colors.white.withOpacity(0.7),
//                         fontSize: 14,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class GridPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint =
//     Paint()
//       ..color = Colors.white.withOpacity(0.3)
//       ..strokeWidth = 0.5;
//
//     // Draw vertical lines
//     final double thirdWidth = size.width / 3;
//     canvas.drawLine(
//       Offset(thirdWidth, 0),
//       Offset(thirdWidth, size.height),
//       paint,
//     );
//     canvas.drawLine(
//       Offset(thirdWidth * 2, 0),
//       Offset(thirdWidth * 2, size.height),
//       paint,
//     );
//
//     // Draw horizontal lines
//     final double thirdHeight = size.height / 3;
//     canvas.drawLine(
//       Offset(0, thirdHeight),
//       Offset(size.width, thirdHeight),
//       paint,
//     );
//     canvas.drawLine(
//       Offset(0, thirdHeight * 2),
//       Offset(size.width, thirdHeight * 2),
//       paint,
//     );
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }




import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:exif/exif.dart';

class CameraScreen extends StatefulWidget {
  bool? isFromVhiclePhotoScreen;
  final Function(File) onImageCaptured;
  final String? angleName; // Add angle name parameter

  CameraScreen({
    Key? key,
    required this.onImageCaptured,
    this.isFromVhiclePhotoScreen,
    this.angleName,
  }) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final ImagePicker _picker = ImagePicker();
  bool _isChecking = false;
  bool _cameraOpened = false; // Track if camera has opened

  // Check if this angle requires portrait orientation
  bool get _requiresPortrait {
    if (widget.angleName == null) return false;
    final angleNameLower = widget.angleName!.toLowerCase();
    // Check if angle name contains "center console gear infotainment" (case-insensitive)
    return angleNameLower.contains('center console gear infotainment') ||
           (angleNameLower.contains('center console') && 
            (angleNameLower.contains('gear') || angleNameLower.contains('infotainment')));
  }

  /// Fast image dimension reading using EXIF with fallback to full decode
  /// Returns null if image cannot be read, otherwise returns (width, height)
  /// EXIF reading is 10-20x faster than full decode for validation
  Future<({int width, int height})?> _getImageDimensions(File imageFile) async {
    try {
      // Try EXIF first (FAST - reads only metadata, 10-50ms)
      final bytes = await imageFile.readAsBytes();
      final exifData = await readExifFromBytes(bytes);
      
      if (exifData != null && exifData.isNotEmpty) {
        // Try to get dimensions from EXIF tags
        final pixelXDimension = exifData['EXIF PixelXDimension'] ?? exifData['Image ImageWidth'];
        final pixelYDimension = exifData['EXIF PixelYDimension'] ?? exifData['Image ImageLength'];
        
        if (pixelXDimension != null && pixelYDimension != null) {
          // Extract integer values from IfdTag
          int? width;
          int? height;
          
          try {
            // Access values from IfdTag - use the values property
            final widthValues = pixelXDimension.values;
            final heightValues = pixelYDimension.values;
            
            // Get first value if available - convert to list if needed
            final widthValuesList = widthValues.toList();
            final heightValuesList = heightValues.toList();
            
            if (widthValuesList.isNotEmpty) {
              final widthValue = widthValuesList[0];
              width = widthValue is int ? widthValue : widthValue.toInt();
            }
            
            if (heightValuesList.isNotEmpty) {
              final heightValue = heightValuesList[0];
              height = heightValue is int ? heightValue : heightValue.toInt();
            }
          } catch (_) {
            // If EXIF extraction fails, will fallback to decode below
          }
          
          if (width != null && height != null && width > 0 && height > 0) {
            // Check if image is rotated (EXIF orientation)
            final orientation = exifData['Image Orientation'];
            bool isRotated = false;
            if (orientation != null) {
              try {
                final orientationValues = orientation.values.toList();
                if (orientationValues.isNotEmpty) {
                  final orientationValue = orientationValues[0];
                  final orientationInt = orientationValue is int ? orientationValue : orientationValue.toInt();
                  // Orientation values 5, 6, 7, 8 indicate 90/270 degree rotations
                  isRotated = orientationInt >= 5 && orientationInt <= 8;
                }
              } catch (_) {
                // Ignore orientation parsing errors
              }
            }
            
            // Return dimensions (swap if rotated)
            return isRotated ? (width: height, height: width) : (width: width, height: height);
          }
        }
      }
      
      // Fallback: Full decode (slower but reliable - 500-2000ms)
      // This ensures compatibility with images that don't have EXIF data
      final decodedImage = img.decodeImage(bytes);
      if (decodedImage != null) {
        return (width: decodedImage.width, height: decodedImage.height);
      }
      
      return null;
    } catch (e) {
      // If EXIF reading fails, fallback to decode
      try {
        final bytes = await imageFile.readAsBytes();
        final decodedImage = img.decodeImage(bytes);
        if (decodedImage != null) {
          return (width: decodedImage.width, height: decodedImage.height);
        }
      } catch (_) {
        // Ignore fallback errors
      }
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    
    // Set orientation based on requirement
    if (_requiresPortrait) {
      // Portrait required - allow portrait orientations
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    } else {
      // Landscape required - allow landscape orientations (existing behavior)
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }

    // Open camera immediately
    _openCamera();
  }

  Future<void> _openCamera() async {
    try {
      setState(() {
        _cameraOpened = true;
      });

      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
        imageQuality: 85,
      );

      if (image == null) {
        // User cancelled
        if (mounted) {
          Navigator.of(context).pop();
        }
        return;
      }

      // Quick validation - check image dimensions
      await _validateAndSubmit(image);
      
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Camera error: $e'),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.of(context).pop();
      }
    }
  }

  Future<void> _validateAndSubmit(XFile image) async {
    setState(() {
      _isChecking = true;
    });

    try {
      final File imageFile = File(image.path);
      
      // Fast dimension reading using EXIF with fallback to full decode
      // EXIF is 10-20x faster than full decode for validation
      final dimensions = await _getImageDimensions(imageFile);
      
      if (dimensions == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: Unable to read image dimensions'),
              backgroundColor: Colors.red,
            ),
          );
          Navigator.of(context).pop();
        }
        return;
      }
      
      final width = dimensions.width;
      final height = dimensions.height;

      // Check if portrait is required for this angle
      if (_requiresPortrait) {
        // Require PORTRAIT: height must be > width
        if (height <= width) {
          // Landscape image - show error for portrait requirement
          if (mounted) {
            setState(() {
              _isChecking = false;
            });
            _showPortraitError(width, height);
          }
        } else {
          // Portrait image - success!
          if (mounted) {
            widget.onImageCaptured(imageFile);
            
            // Reset to landscape orientation immediately
            if (widget.isFromVhiclePhotoScreen == true) {
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.landscapeLeft,
                DeviceOrientation.landscapeRight,
              ]);
              
              // Give a short delay to ensure orientation change is applied before navigation
              await Future.delayed(const Duration(milliseconds: 300));
            }
            
            if (mounted) {
              Navigator.of(context).pop();
            }
          }
        }
      } else {
        // Require LANDSCAPE: width must be > height (existing behavior)
        if (width <= height) {
          // Portrait image - show error
          if (mounted) {
            setState(() {
              _isChecking = false;
            });
            _showLandscapeError(width, height);
          }
        } else {
          // Landscape image - success!
          if (mounted) {
            // Ensure landscape orientation is set before going back
            if (widget.isFromVhiclePhotoScreen == true) {
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.landscapeLeft,
                DeviceOrientation.landscapeRight,
              ]);
            }
            widget.onImageCaptured(imageFile);
            Navigator.of(context).pop();
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error validating image: $e'),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.of(context).pop();
      }
    }
  }

  void _showLandscapeError(int width, int height) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.screen_rotation, color: Colors.orange, size: 28),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Landscape Required',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Please take the photo in landscape mode.',
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.info_outline, color: Colors.orange, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'Image: ${width}x${height}',
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Close camera screen
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              _openCamera(); // Retry
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text('Retry', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showPortraitError(int width, int height) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.screen_rotation, color: Colors.orange, size: 28),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Portrait Required',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Please take the photo in portrait mode.',
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.info_outline, color: Colors.orange, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'Image: ${width}x${height}',
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Close camera screen
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              _openCamera(); // Retry
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text('Retry', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Reset orientation when leaving
    if (widget.isFromVhiclePhotoScreen == true) {
      // Reset to landscape for vehicle photo screen (expects landscape)
      // Use post-frame callback to ensure this happens after navigation completes
      WidgetsBinding.instance.addPostFrameCallback((_) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      });
      
      // Also set immediately as backup
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else if (widget.isFromVhiclePhotoScreen == null) {
      // Reset to portrait for other screens
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Only show the initial "tilt phone" message before camera opens
    // Once camera opens and we're checking, show a minimal or transparent UI
    if (_isChecking) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Colors.orange),
                SizedBox(height: 16),
                Text(
                  'Validating image...',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Show initial "tilt phone" message only before camera opens
    if (!_cameraOpened) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.screen_rotation,
                  color: Colors.orange,
                  size: 80,
                ),
                SizedBox(height: 30),
                Text(
                  'Please Tilt Your Phone',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    _requiresPortrait
                        ? 'Keep your device in portrait mode\nfor this photo'
                        : 'Rotate your device to landscape mode\nfor better photos',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 40),
                CircularProgressIndicator(color: Colors.orange),
                SizedBox(height: 16),
                Text(
                  'Opening camera...',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // After camera opens, show minimal UI (or could be completely transparent)
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(),
    );
  }
}