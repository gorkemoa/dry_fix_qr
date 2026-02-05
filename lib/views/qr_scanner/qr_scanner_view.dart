import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../app/app_theme.dart';
import '../../viewmodels/qr_view_model.dart';
import '../../viewmodels/home_view_model.dart';
import '../../viewmodels/history_view_model.dart';
import '../../core/responsive/size_config.dart';
import '../../core/responsive/size_tokens.dart';
import 'qr_success_view.dart';

class QrScannerView extends StatefulWidget {
  const QrScannerView({super.key});

  @override
  State<QrScannerView> createState() => _QrScannerViewState();
}

class _QrScannerViewState extends State<QrScannerView>
    with SingleTickerProviderStateMixin {
  bool _hasPermission = false;
  bool _isScanning = true;
  bool _isTorchOn = false;
  final MobileScannerController _controller = MobileScannerController();
  late AnimationController _animationController;
  String _version = "";

  @override
  void initState() {
    super.initState();
    _checkPermission();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _getAppVersion();
  }

  Future<void> _getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _version = packageInfo.version;
    });
  }

  Future<void> _checkPermission() async {
    final status = await Permission.camera.request();
    setState(() {
      _hasPermission = status.isGranted;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) async {
    if (!_isScanning) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      final String? code = barcodes.first.rawValue;
      if (code != null) {
        setState(() {
          _isScanning = false;
        });

        final viewModel = context.read<QrViewModel>();
        final success = await viewModel.verifyQr(code);

        if (mounted) {
          if (success && viewModel.lastScanResult != null) {
            // Proactively refresh home and history data
            context.read<HomeViewModel>().init();
            context.read<HistoryViewModel>().fetchHistory();

            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) =>
                    QrSuccessView(response: viewModel.lastScanResult!),
              ),
            );
            if (mounted) {
              setState(() {
                _isScanning = true;
                viewModel.reset();
              });
            }
          } else {
            _showResultDialog(context, false, viewModel);
          }
        }
      }
    }
  }

  void _showResultDialog(
    BuildContext context,
    bool success,
    QrViewModel viewModel,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SizeTokens.r20),
        ),
        title: Icon(
          success ? Icons.check_circle_outline : Icons.error_outline,
          color: success ? Colors.green : Colors.red,
          size: SizeTokens.p32 * 2,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              success ? "Başarılı!" : "Hata",
              style: TextStyle(
                fontSize: SizeTokens.f20,
                fontWeight: FontWeight.bold,
                color: AppColors.darkBlue,
              ),
            ),
            SizedBox(height: SizeTokens.p16),
            Text(
              viewModel.errorMessage ??
                  viewModel.lastScanResult?.message ??
                  "İşlem tamamlandı.",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.gray),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _isScanning = true;
              });
            },
            child: const Text("Yeniden Tara"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("Kapat"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    if (!_hasPermission) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.camera_alt_outlined,
                size: 64,
                color: AppColors.gray,
              ),
              SizedBox(height: SizeTokens.p16),
              const Text("Kamera izni gerekiyor."),
              SizedBox(height: SizeTokens.p24),
              ElevatedButton(
                onPressed: _checkPermission,
                child: const Text("İzin Ver"),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(controller: _controller, onDetect: _onDetect),

          // Unified Custom Overlay (Hole, Corners, Dots, Laser)
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return CustomPaint(
                  painter: ScannerOverlayPainter(
                    animationValue: _animationController.value,
                  ),
                );
              },
            ),
          ),

          // Content Layer
          SafeArea(
            child: Column(
              children: [
                // Top Bar
                Padding(
                  padding: EdgeInsets.all(SizeTokens.p16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _CircleActionButton(
                        icon: Icons.close,
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text(
                        "QR Kodunu Taratın",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: SizeTokens.f20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      _CircleActionButton(
                        icon: _isTorchOn ? Icons.flash_on : Icons.flash_off,
                        onPressed: () {
                          _controller.toggleTorch();
                          setState(() {
                            _isTorchOn = !_isTorchOn;
                          });
                        },
                      ),
                    ],
                  ),
                ),

                // This Spacer pushes the following content below the scanner hole
                const SizedBox(height: 400),

                // Bottom Content
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: SizeTokens.p32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Kamerayı boya kutusunun üzerindeki\nQR koduna doğrultun",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: SizeTokens.f16,
                        ),
                      ),
                      SizedBox(height: SizeTokens.p100),
                      // Manual Input Button

                      // Gallery Button
                      _CircleActionButton(
                        icon: Icons.image_outlined,
                        size: 56,
                        onPressed: () {},
                      ),
                      SizedBox(height: SizeTokens.p24),
                      // Version Text
                      Text(
                        "Dryfix v$_version",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: SizeTokens.f12,
                        ),
                      ),
                      SizedBox(height: SizeTokens.p16),
                    ],
                  ),
                ),
              ],
            ),
          ),

          if (context.watch<QrViewModel>().isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.blue),
              ),
            ),
        ],
      ),
    );
  }
}

class _CircleActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final double size;

  const _CircleActionButton({
    required this.icon,
    required this.onPressed,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: size * 0.5),
        onPressed: onPressed,
        padding: EdgeInsets.zero,
      ),
    );
  }
}

class ScannerOverlayPainter extends CustomPainter {
  final double animationValue;

  ScannerOverlayPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.65)
      ..style = PaintingStyle.fill;

    final backgroundPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final cutOutPadding = 48.0;
    final cutOutWidth = size.width - (cutOutPadding * 2);
    final cutOutHeight = cutOutWidth;
    final cutOutRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: cutOutWidth,
      height: cutOutHeight,
    );

    final cutOutPath = Path()
      ..addRRect(
        RRect.fromRectAndRadius(cutOutRect, const Radius.circular(24)),
      );

    canvas.drawPath(
      Path.combine(PathOperation.difference, backgroundPath, cutOutPath),
      paint,
    );

    // Everything inside this block is clipped to the scanner hole
    canvas.save();
    canvas.clipPath(cutOutPath);

    // 1. Draw Dot Grid
    final dotPaint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..style = PaintingStyle.fill;

    const double spacing = 24.0;
    const double dotSize = 2.0;

    for (
      double x = cutOutRect.left + spacing / 2;
      x < cutOutRect.right;
      x += spacing
    ) {
      for (
        double y = cutOutRect.top + spacing / 2;
        y < cutOutRect.bottom;
        y += spacing
      ) {
        canvas.drawCircle(Offset(x, y), dotSize / 2, dotPaint);
      }
    }

    // 2. Draw Laser Line

    final laserY = cutOutRect.top + (animationValue * cutOutHeight);
    final shadowPaint = Paint()
      ..color = Colors.blue.withOpacity(0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    canvas.drawRect(
      Rect.fromLTWH(cutOutRect.left + 10, laserY, cutOutWidth - 20, 2),
      shadowPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(cutOutRect.left + 10, laserY, cutOutWidth - 20, 2),
      Paint()..color = Colors.blue,
    );

    canvas.restore();

    // 3. Draw Corners
    final cornerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    const cornerLength = 40.0;
    const cornerRadius = 24.0;

    // Top Left
    canvas.drawPath(
      Path()
        ..moveTo(cutOutRect.left, cutOutRect.top + cornerLength)
        ..lineTo(cutOutRect.left, cutOutRect.top + cornerRadius)
        ..arcToPoint(
          Offset(cutOutRect.left + cornerRadius, cutOutRect.top),
          radius: const Radius.circular(cornerRadius),
        )
        ..lineTo(cutOutRect.left + cornerLength, cutOutRect.top),
      cornerPaint,
    );

    // Top Right
    canvas.drawPath(
      Path()
        ..moveTo(cutOutRect.right - cornerLength, cutOutRect.top)
        ..lineTo(cutOutRect.right - cornerRadius, cutOutRect.top)
        ..arcToPoint(
          Offset(cutOutRect.right, cutOutRect.top + cornerRadius),
          radius: const Radius.circular(cornerRadius),
        )
        ..lineTo(cutOutRect.right, cutOutRect.top + cornerLength),
      cornerPaint,
    );

    // Bottom Left
    canvas.drawPath(
      Path()
        ..moveTo(cutOutRect.left, cutOutRect.bottom - cornerLength)
        ..lineTo(cutOutRect.left, cutOutRect.bottom - cornerRadius)
        ..arcToPoint(
          Offset(cutOutRect.left + cornerRadius, cutOutRect.bottom),
          radius: const Radius.circular(cornerRadius),
          clockwise: false,
        )
        ..lineTo(cutOutRect.left + cornerLength, cutOutRect.bottom),
      cornerPaint,
    );

    // Bottom Right
    canvas.drawPath(
      Path()
        ..moveTo(cutOutRect.right - cornerLength, cutOutRect.bottom)
        ..lineTo(cutOutRect.right - cornerRadius, cutOutRect.bottom)
        ..arcToPoint(
          Offset(cutOutRect.right, cutOutRect.bottom - cornerRadius),
          radius: const Radius.circular(cornerRadius),
          clockwise: false,
        )
        ..lineTo(cutOutRect.right, cutOutRect.bottom - cornerLength),
      cornerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant ScannerOverlayPainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}
