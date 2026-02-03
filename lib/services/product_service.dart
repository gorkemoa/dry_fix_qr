import '../core/network/api_client.dart';
import '../core/network/api_result.dart';
import '../core/network/api_exception.dart';
import '../app/api_constants.dart';
import '../models/product_model.dart';

class ProductService {
  final ApiClient _apiClient;

  ProductService(this._apiClient);

  Future<ApiResult<ProductResponse>> fetchProducts({
    int page = 1,
    int perPage = 20,
    String? query,
    bool? inStock,
  }) async {
    try {
      final Map<String, dynamic> queryParameters = {
        'page': page,
        'per_page': perPage,
      };

      if (query != null && query.isNotEmpty) {
        queryParameters['q'] = query;
      }

      if (inStock != null) {
        queryParameters['in_stock'] = inStock ? 1 : 0;
      }

      final response = await _apiClient.get(
        ApiConstants.products,
        queryParameters: queryParameters,
      );

      final productResponse = ProductResponse.fromJson(response);
      return Success(productResponse);
    } on ApiException catch (e) {
      return Failure(e.message);
    } catch (e) {
      return Failure(e.toString());
    }
  }
}
