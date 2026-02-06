import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import '../../viewmodels/qr_view_model.dart';
import '../../core/utils/logger.dart';
import '../../core/responsive/size_tokens.dart';
import '../../app/app_theme.dart';

class QrShareProcessView extends StatefulWidget {
  final List<SharedMediaFile> sharedFiles;

  const QrShareProcessView({super.key, required this.sharedFiles});

  @override
  State<QrShareProcessView> createState() => _QrShareProcessViewState();
}

class _QrShareProcessViewState extends State<QrShareProcessView> {
  String _statusMessage = "İşlem başlatılıyor...";
  bool _isProcessing = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _processSharedFiles();
    });
  }

  void _updateStatus(String message) {
    if (mounted) {
      setState(() {
        _statusMessage = message;
      });
    }
  }

  Future<void> _processSharedFiles() async {
    // 1. Dosya Kontrolü
    if (widget.sharedFiles.isEmpty) {
      _showErrorAndExit("Paylaşılan dosya bulunamadı.");
      return;
    }

    final file = widget.sharedFiles.first;
    _updateStatus("Görsel analiz ediliyor...\n${file.path.split('/').last}");
    Logger.info("Processing shared file: ${file.path}");

    try {
      // 2. QR Analizi (OCR)
      final controller = MobileScannerController();
      final barcodes = await controller.analyzeImage(file.path);

      if (barcodes == null || barcodes.barcodes.isEmpty) {
        _showErrorAndExit(
          "Bu görselde geçerli bir QR kod bulunamadı.\nLütfen görselin net olduğundan emin olun.",
        );
        return;
      }

      final qrCode = barcodes.barcodes.first.rawValue;
      if (qrCode == null) {
        _showErrorAndExit("QR Kod içeriği okunamadı (Hasarlı veri).");
        return;
      }

      Logger.info("QR Code found: $qrCode");
      _updateStatus("QR Kod Bulundu!\nSunucu ile doğrulanıyor...");

      // 3. API İsteği
      if (!mounted) return;
      final qrViewModel = context.read<QrViewModel>();

      // ViewModel içindeki loading durumunu dinlemeye gerek yok, biz zaten loading gösteriyoruz.
      final success = await qrViewModel.verifyQr(qrCode);

      if (!mounted) return;

      // 4. Sonuç Gösterimi
      if (success) {
        final result = qrViewModel.lastScanResult;
        _showSuccessAndExit(result?.message ?? "İşlem başarıyla tamamlandı.");
      } else {
        _showErrorAndExit(qrViewModel.errorMessage ?? "Sunucu hatası oluştu.");
      }
    } catch (e) {
      Logger.error("Error processing shared QR", e.toString());
      _showErrorAndExit("Beklenmedik bir hata oluştu:\n$e");
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  void _showErrorAndExit(String message) {
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red),
            SizedBox(width: 8),
            Text("Hata"),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              SystemNavigator.pop();
            },
            child: const Text("Kapat"),
          ),
        ],
      ),
    );
  }

  void _showSuccessAndExit(String message) {
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text("Başarılı"),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              SystemNavigator.pop();
            },
            child: const Text("Tamam"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background.withOpacity(
        0.9,
      ), // Yarı saydam arka plan hissi
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          padding: EdgeInsets.all(SizeTokens.p32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(SizeTokens.r24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_isProcessing)
                const CircularProgressIndicator(color: AppColors.blue)
              else
                const Icon(Icons.info_outline, size: 48, color: AppColors.gray),

              SizedBox(height: SizeTokens.p24),

              Text(
                "QR İşlemi",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkBlue,
                ),
              ),

              SizedBox(height: SizeTokens.p16),

              Text(
                _statusMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.gray,
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
