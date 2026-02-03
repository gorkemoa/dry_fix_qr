import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../app/app_theme.dart';
import '../../viewmodels/qr_view_model.dart';
import '../../core/responsive/size_config.dart';
import '../../core/responsive/size_tokens.dart';
import 'qr_success_view.dart';

class QrScannerView extends StatefulWidget {
  const QrScannerView({super.key});

  @override
  State<QrScannerView> createState() => _QrScannerViewState();
}

class _QrScannerViewState extends State<QrScannerView> {
  bool _hasPermission = false;
  bool _isScanning = true;
  final MobileScannerController _controller = MobileScannerController();

  @override
  void initState() {
    super.initState();
    _checkPermission();
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
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) =>
                    QrSuccessView(response: viewModel.lastScanResult!),
              ),
            );
            // After coming back from success screen, reset scanning
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
    final result = viewModel.lastScanResult;

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
              viewModel.errorMessage ?? result?.message ?? "İşlem tamamlandı.",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.gray),
            ),
            if (success && result?.qr != null) ...[
              SizedBox(height: SizeTokens.p16),
              const Divider(),
              SizedBox(height: SizeTokens.p16),
              Text(
                "Kazanılan Puan: ${result?.qr?.tokenValue}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.blue,
                  fontSize: SizeTokens.f16,
                ),
              ),
              if (result?.product != null)
                Text(
                  "Ürün: ${result?.product?.name}",
                  style: TextStyle(color: AppColors.darkBlue),
                ),
            ],
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
        appBar: AppBar(title: const Text("QR Tara")),
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
          // Scanner Overlay
          Center(
            child: Container(
              width: SizeTokens.p32 * 8,
              height: SizeTokens.p32 * 8,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.blue, width: 4),
                borderRadius: BorderRadius.circular(SizeTokens.r20),
              ),
            ),
          ),
          // Back Button
          Positioned(
            top: SizeTokens.p32,
            left: SizeTokens.p24,
            child: CircleAvatar(
              backgroundColor: Colors.black54,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          // Torch Button
          Positioned(
            top: SizeTokens.p32,
            right: SizeTokens.p24,
            child: CircleAvatar(
              backgroundColor: Colors.black54,
              child: IconButton(
                icon: const Icon(Icons.flash_on, color: Colors.white),
                onPressed: () => _controller.toggleTorch(),
              ),
            ),
          ),
          // Title
          Positioned(
            bottom: SizeTokens.p32 * 4,
            left: 0,
            right: 0,
            child: const Center(
              child: Text(
                "Lütfen ürün üzerindeki QR kodu okutun",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(blurRadius: 10, color: Colors.black)],
                ),
              ),
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
