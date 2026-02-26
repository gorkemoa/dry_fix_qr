import 'package:flutter/foundation.dart';
import '../core/utils/logger.dart';
import '../services/banner_service.dart';
import '../services/product_service.dart';
import '../models/banner_model.dart';
import '../models/product_model.dart';
import '../core/network/api_result.dart';

class BannerViewModel extends ChangeNotifier {
  final BannerService _bannerService;
  final ProductService _productService;

  List<BannerModel> _banners = [];
  bool _isLoading = false;
  String? _errorMessage;

  BannerViewModel(this._bannerService, this._productService);

  List<BannerModel> get banners => _banners;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> init() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    Logger.info('BannerViewModel: Fetching banners...');

    final result = await _bannerService.fetchBanners();

    if (result is Success<BannerResponse>) {
      _banners = result.data.data;
      Logger.info('BannerViewModel: Fetched ${_banners.length} banners.');
    } else if (result is Failure<BannerResponse>) {
      _errorMessage = result.errorMessage;
      Logger.error('BannerViewModel: Fetch banners failed', _errorMessage ?? '');
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Banner'a tıklanınca: click isteği atar (fire-and-forget) + ürünü çeker.
  Future<ProductModel?> onBannerTapped(BannerModel banner) async {
    // Click sayacı — yanıt beklenmez, ürün fetch'i geciktirmez
    _bannerService.clickBanner(banner.id);
    return fetchProductById(banner.productId);
  }

  Future<ProductModel?> fetchProductById(int productId) async {
    Logger.info('BannerViewModel: Fetching product id=$productId...');
    final result = await _productService.fetchProductById(productId);
    if (result is Success<ProductSingleResponse>) {
      Logger.info('BannerViewModel: Product fetched: ${result.data.data.name}');
      return result.data.data;
    } else if (result is Failure<ProductSingleResponse>) {
      Logger.error('BannerViewModel: fetchProductById failed', result.errorMessage);
      return null;
    }
    return null;
  }

  Future<void> refresh() async {
    await init();
  }

  void onRetry() {
    init();
  }
}
