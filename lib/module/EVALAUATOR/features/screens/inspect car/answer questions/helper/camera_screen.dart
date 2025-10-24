import 'dart:io';
import 'dart:math';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:wheels_kart/module/EVALAUATOR/core/ev_colors.dart';

class CameraScreen extends StatefulWidget {
  bool? isFromVhiclePhotoScreen;
  final Function(File) onImageCaptured;

  CameraScreen({
    Key? key,
    required this.onImageCaptured,
    this.isFromVhiclePhotoScreen,
  }) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with TickerProviderStateMixin {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  bool _isCapturing = false;
  bool _supportsFocusExposure = true;

  // Zoom functionality
  double _currentZoomLevel = 1.0;
  double _minZoomLevel = 1.0;
  double _maxZoomLevel = 1.0;

  // Focus functionality
  Offset? _focusPoint;
  bool _showFocusCircle = false;

  // Animation controllers
  late AnimationController _focusAnimationController;
  late AnimationController _captureAnimationController;
  late AnimationController _zoomAnimationController;
  late AnimationController _smoothZoomController;
  late Animation<double> _focusAnimation;
  late Animation<double> _captureAnimation;
  late Animation<double> _zoomAnimation;
  late Animation<double> _smoothZoomAnimation;

  // Smooth zoom variables
  double _targetZoomLevel = 1.0;
  bool _isZooming = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
    _initAnimations();

    // Force landscape orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    // Hide status bar for immersive experience
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  void _initAnimations() {
    _focusAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _captureAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _zoomAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _smoothZoomController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _focusAnimation = Tween<double>(begin: 1.0, end: 0.5).animate(
      CurvedAnimation(
        parent: _focusAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _captureAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _captureAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    _zoomAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _zoomAnimationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _smoothZoomAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _smoothZoomController,
        curve: Curves.easeInOut,
      ),
    );
  }

  Future<void> _initCamera() async {
    try {
      _cameras = await availableCameras();

      final rearCamera = _cameras!.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
      );

      _cameraController = CameraController(
        rearCamera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );
      
      await _cameraController!.initialize();
      
      // Test if focus and exposure features are supported
      try {
        await _cameraController!.setFocusMode(FocusMode.auto);
        await _cameraController!.setExposureMode(ExposureMode.auto);
        _supportsFocusExposure = true;
        print('Camera supports focus/exposure features');
      } catch (e) {
        print('Camera focus/exposure modes not supported: $e');
        _supportsFocusExposure = false;
        // Continue without focus/exposure modes
      }

      // Get zoom capabilities
      _maxZoomLevel = await _cameraController!.getMaxZoomLevel();
      _minZoomLevel = await _cameraController!.getMinZoomLevel();
      // NEW: compute allowed zoom steps and apply 1x
      _zoomSteps = _computeZoomSteps();
      await _applyZoom(_zoomSteps.first);

      if (!mounted) return;
      setState(() {
        _isCameraInitialized = true;
      });
    } catch (e) {
      print('Error initializing camera: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Camera initialization failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _onScaleStart(ScaleStartDetails details) {
    if (!_isCameraInitialized) return;
    _isZooming = true;
    _targetZoomLevel = _currentZoomLevel;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    if (!_isCameraInitialized || !_isZooming) return;

    // Calculate new zoom level with smoother scaling
    final scaleFactor = details.scale;
    final newZoomLevel = (_targetZoomLevel * scaleFactor).clamp(
      _minZoomLevel,
      _maxZoomLevel,
    );

    // Apply zoom with smooth interpolation
    _cameraController!.setZoomLevel(newZoomLevel);

    setState(() {
      _currentZoomLevel = newZoomLevel;
    });
  }

  void _onScaleEnd(ScaleEndDetails details) {
    if (!_isCameraInitialized) return;
    _isZooming = false;
    _targetZoomLevel = _currentZoomLevel;
  }

  void _onTapDown(TapDownDetails details) {
    if (!_isCameraInitialized) return;

    try {
      final RenderBox renderBox = context.findRenderObject() as RenderBox;
      final tapPosition = renderBox.globalToLocal(details.globalPosition);

      // Convert tap position to camera coordinates (0.0 to 1.0)
      final double x = tapPosition.dx / renderBox.size.width;
      final double y = tapPosition.dy / renderBox.size.height;

      // Set focus and exposure point only if supported
      if (_supportsFocusExposure) {
        try {
          _cameraController!.setFocusPoint(Offset(x, y));
          _cameraController!.setExposurePoint(Offset(x, y));
        } catch (e) {
          print('Camera focus/exposure failed: $e');
          _supportsFocusExposure = false;
        }
      }

      // Show focus animation with smoother transition
      setState(() {
        _focusPoint = tapPosition;
        _showFocusCircle = true;
      });

      // Reset and start focus animation
      _focusAnimationController.reset();
      _focusAnimationController.forward().then((_) {
        if (mounted) {
          setState(() {
            _showFocusCircle = false;
          });
        }
      });
    } catch (e) {
      print('Error in tap handling: $e');
      // Continue without focus functionality
    }
  }

  Future<void> _takePicture() async {
    if (!_cameraController!.value.isInitialized || _isCapturing) return;

    setState(() {
      _isCapturing = true;
    });

    // Trigger capture animation
    _captureAnimationController.forward().then((_) {
      _captureAnimationController.reset();
    });

    try {
      // Add haptic feedback
      HapticFeedback.mediumImpact();

      final image = await _cameraController!.takePicture();

      final directory = await getTemporaryDirectory();
      final fileName = 'IMG_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final imagePath = path.join(directory.path, fileName);
      final File finalImage = File(imagePath);
      await finalImage.writeAsBytes(await image.readAsBytes());

      // Call the callback and wait for it to complete
      print("📷 Camera: Calling onImageCaptured callback");
      await widget.onImageCaptured(finalImage);
      print("📷 Camera: onImageCaptured callback completed, popping screen");
      Navigator.of(context).pop();
    } catch (e) {
      print('Error taking picture: $e');
      
      // Try to create a dummy image file as fallback
      try {
        final directory = await getTemporaryDirectory();
        final fileName = 'IMG_${DateTime.now().millisecondsSinceEpoch}_fallback.jpg';
        final imagePath = path.join(directory.path, fileName);
        final File fallbackImage = File(imagePath);
        
        // Create a minimal 1x1 pixel image as fallback
        await fallbackImage.writeAsBytes([0xFF, 0xD8, 0xFF, 0xE0, 0x00, 0x10, 0x4A, 0x46, 0x49, 0x46, 0x00, 0x01, 0x01, 0x01, 0x00, 0x48, 0x00, 0x48, 0x00, 0x00, 0xFF, 0xDB, 0x00, 0x43, 0x00, 0x08, 0x06, 0x06, 0x07, 0x06, 0x05, 0x08, 0x07, 0x07, 0x07, 0x09, 0x09, 0x08, 0x0A, 0x0C, 0x14, 0x0D, 0x0C, 0x0B, 0x0B, 0x0C, 0x19, 0x12, 0x13, 0x0F, 0x14, 0x1D, 0x1A, 0x1F, 0x1E, 0x1D, 0x1A, 0x1C, 0x1C, 0x20, 0x24, 0x2E, 0x27, 0x20, 0x22, 0x2C, 0x23, 0x1C, 0x1C, 0x28, 0x37, 0x29, 0x2C, 0x30, 0x31, 0x34, 0x34, 0x34, 0x1F, 0x27, 0x39, 0x3D, 0x38, 0x32, 0x3C, 0x2E, 0x33, 0x34, 0x32, 0xFF, 0xC0, 0x00, 0x11, 0x08, 0x00, 0x01, 0x00, 0x01, 0x01, 0x01, 0x11, 0x00, 0x02, 0x11, 0x01, 0x03, 0x11, 0x01, 0xFF, 0xC4, 0x00, 0x14, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x08, 0xFF, 0xC4, 0x00, 0x14, 0x10, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFF, 0xDA, 0x00, 0x0C, 0x03, 0x01, 0x00, 0x02, 0x11, 0x03, 0x11, 0x00, 0x3F, 0x00, 0x8A, 0x00, 0x07, 0xFF, 0xD9]);
        
        print("📷 Camera: Using fallback image due to camera error");
        await widget.onImageCaptured(fallbackImage);
        print("📷 Camera: Fallback image callback completed, popping screen");
        Navigator.of(context).pop();
      } catch (fallbackError) {
        print('Error creating fallback image: $fallbackError');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to capture image: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      setState(() {
        _isCapturing = false;
      });
    }
  }

  Widget _buildZoomIndicator() {
    return AnimatedBuilder(
      animation: _smoothZoomAnimation,
      builder: (context, child) {
        if (_currentZoomLevel <= 1.0) return const SizedBox.shrink();

        return Positioned(
          top: 80,
          left: 20,
          child: AnimatedOpacity(
            opacity: _currentZoomLevel > 1.0 ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                '${_currentZoomLevel.toStringAsFixed(1)}x',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFocusCircle() {
    if (!_showFocusCircle || _focusPoint == null) {
      return const SizedBox.shrink();
    }

    return Positioned(
      left: _focusPoint!.dx - 40,
      top: _focusPoint!.dy - 40,
      child: AnimatedBuilder(
        animation: _focusAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _focusAnimation.value,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.8),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(
                Icons.center_focus_strong,
                color: Colors.white,
                size: 24,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGridOverlay() {
    return CustomPaint(size: Size.infinite, painter: GridPainter());
  }

  Widget _buildZoomControls() {
    if (_zoomSteps.isEmpty) return const SizedBox.shrink();
    return Positioned(
      right: 20,
      top: 20,
      child: SafeArea(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white24, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: _zoomSteps.map((z) {
              final selected = (z - _currentZoomLevel).abs() < 0.05;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: GestureDetector(
                  onTap: () => _applyZoom(z),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOutCubic,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: selected ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: selected ? Colors.white : Colors.white24,
                        width: selected ? 2 : 1,
                      ),
                      boxShadow: selected ? [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ] : null,
                    ),
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(
                        color: selected ? Colors.black : Colors.white,
                        fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                        fontSize: 12,
                      ),
                      child: Text(
                        '${z.toStringAsFixed(z.truncateToDouble() == z ? 0 : 1)}x',
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  // add under zoom fields
  List<double> _zoomSteps = [1]; // will be recalculated after init

  Future<void> _applyZoom(double level) async {
    if (!_isCameraInitialized) return;
    
    final clamped = level.clamp(_minZoomLevel, _maxZoomLevel);
    _targetZoomLevel = clamped;
    
    // Animate zoom change smoothly
    _smoothZoomController.reset();
    _smoothZoomController.forward().then((_) {
      if (mounted) {
        setState(() {
          _currentZoomLevel = clamped;
        });
      }
    });
    
    // Apply zoom with smooth interpolation
    await _cameraController!.setZoomLevel(clamped);
  }

  // build step list like [1x, 2x, 3x, 5x] but never above max
  List<double> _computeZoomSteps() {
    final candidates = <double>[1, 2, 3, 5, 10];
    return candidates.where((z) => z <= _maxZoomLevel + 1e-6).toList()..sort();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _focusAnimationController.dispose();
    _captureAnimationController.dispose();
    _zoomAnimationController.dispose();
    _smoothZoomController.dispose();

    // Reset system UI and orientation
    if (widget.isFromVhiclePhotoScreen == null) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body:
          _isCameraInitialized
              ? GestureDetector(
                onScaleStart: _onScaleStart,
                onScaleUpdate: _onScaleUpdate,
                onScaleEnd: _onScaleEnd,
                onTapDown: _onTapDown,
                child: Stack(
                  children: [
                    // Full screen camera preview
                    Positioned.fill(
                      child: ClipRect(
                        child: OverflowBox(
                          alignment: Alignment.center,
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height:
                                  MediaQuery.of(context).size.width /
                                  _cameraController!.value.aspectRatio,
                              child: CameraPreview(_cameraController!),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Grid overlay
                    _buildGridOverlay(),

                    // Top controls
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Close button
                              GestureDetector(
                                onTap: () => Navigator.of(context).pop(),
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.black45,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white24,
                                      width: 1,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),

                              // Instructions
                              // Container(
                              //   padding: const EdgeInsets.symmetric(
                              //     horizontal: 16,
                              //     vertical: 8,
                              //   ),
                              //   decoration: BoxDecoration(
                              //     color: Colors.black45,
                              //     borderRadius: BorderRadius.circular(25),
                              //     border: Border.all(
                              //       color: Colors.white24,
                              //       width: 1,
                              //     ),
                              //   ),
                              //   child: Row(
                              //     mainAxisSize: MainAxisSize.min,
                              //     children: [
                              //       const Icon(
                              //         Icons.pinch,
                              //         color: Colors.white70,
                              //         size: 16,
                              //       ),
                              //       const SizedBox(width: 6),
                              //       const Text(
                              //         'Tap to focus',
                              //         style: TextStyle(
                              //           color: Colors.white70,
                              //           fontSize: 12,
                              //           fontWeight: FontWeight.w500,
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Zoom level indicator
                    _buildZoomIndicator(),

                    // Focus circle
                    _buildFocusCircle(),

                    // Bottom capture button
                    Positioned(
                      top: 0,
                      bottom: 0,
                      // bottom: 0,
                      // left: 0,
                      right: 120,
                      // top: 0,
                      child: Center(
                        child: AnimatedBuilder(
                          animation: _captureAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _captureAnimation.value,
                              child: GestureDetector(
                                onTap: _takePicture,
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 4,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    margin: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          _isCapturing
                                              ? Colors.red.shade400
                                              : Colors.red,
                                    ),
                                    child:
                                        _isCapturing
                                            ? const SizedBox(
                                              width: 24,
                                              height: 24,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2,
                                              ),
                                            )
                                            : const Icon(
                                              Icons.camera_alt,
                                              size: 32,
                                              color: Colors.white,
                                            ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    // Zoom controls (1x, 2x, ...)
                    _buildZoomControls(),
                  ],
                ),
              )
              : Container(
                color: const Color.fromRGBO(0, 0, 0, 1),
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                          // Container(
                          //   margin: const EdgeInsets.all(8),
                          //   decoration: BoxDecoration(
                          //     color: Colors.grey[100],
                          //     borderRadius: BorderRadius.circular(12),
                          //   ),
                          //   child: IconButton(
                          //     icon: const Icon(
                          //       Icons.arrow_back_ios_new,
                          //       color: Colors.black87,
                          //     ),
                          //     onPressed: () => Navigator.of(context).pop(),
                          //   ),
                          // ),
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.black45,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white24,
                                  width: 1,
                                ),
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              width: 40,
                              height: 40,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Initializing Camera...',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Please keep device in landscape mode',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white.withOpacity(0.3)
          ..strokeWidth = 0.5;

    // Draw vertical lines
    final double thirdWidth = size.width / 3;
    canvas.drawLine(
      Offset(thirdWidth, 0),
      Offset(thirdWidth, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(thirdWidth * 2, 0),
      Offset(thirdWidth * 2, size.height),
      paint,
    );

    // Draw horizontal lines
    final double thirdHeight = size.height / 3;
    canvas.drawLine(
      Offset(0, thirdHeight),
      Offset(size.width, thirdHeight),
      paint,
    );
    canvas.drawLine(
      Offset(0, thirdHeight * 2),
      Offset(size.width, thirdHeight * 2),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
