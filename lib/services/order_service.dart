import '../core/network/api_client.dart';
import '../core/network/api_result.dart';
import '../core/network/api_exception.dart';
import '../app/api_constants.dart';
import '../models/order_model.dart';

class OrderService {
  final ApiClient _apiClient;

  OrderService(this._apiClient);

  Future<ApiResult<OrderResponse>> fetchOrders({
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      final response = await _apiClient.get(
        ApiConstants.orders,
        queryParameters: {'page': page, 'per_page': perPage},
      );

      final orderResponse = OrderResponse.fromJson(response);
      return Success(orderResponse);
    } on ApiException catch (e) {
      return Failure(e.message);
    } catch (e) {
      return Failure(e.toString());
    }
  }
}
