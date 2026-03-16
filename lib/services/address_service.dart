import '../core/network/api_client.dart';
import '../core/network/api_result.dart';
import '../core/network/api_exception.dart';
import '../app/api_constants.dart';
import '../models/address_model.dart';
import '../models/city_model.dart';
import '../models/district_model.dart';

class AddressService {
  final ApiClient _apiClient;

  AddressService(this._apiClient);

  Future<ApiResult<List<Address>>> getAddresses({String? addressType}) async {
    try {
      final url = addressType != null
          ? ApiConstants.addressesByType(addressType)
          : ApiConstants.addresses;
      final response = await _apiClient.get(url);
      final addressListResponse = AddressListResponse.fromJson(response);
      return Success(addressListResponse.data);
    } on ApiException catch (e) {
      return Failure(e.message);
    } catch (e) {
      return Failure(e.toString());
    }
  }

  Future<ApiResult<Address>> createAddress(CreateAddressRequest request) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.addresses,
        data: request.toJson(),
      );
      final addressResponse = AddressResponse.fromJson(response);
      return Success(addressResponse.data);
    } on ApiException catch (e) {
      return Failure(e.message);
    } catch (e) {
      return Failure(e.toString());
    }
  }

  Future<ApiResult<Address>> updateAddress(
    int id,
    CreateAddressRequest request,
  ) async {
    try {
      final response = await _apiClient.put(
        ApiConstants.addressDetail(id),
        data: request.toJson(),
      );
      final addressResponse = AddressResponse.fromJson(response);
      return Success(addressResponse.data);
    } on ApiException catch (e) {
      return Failure(e.message);
    } catch (e) {
      return Failure(e.toString());
    }
  }

  Future<ApiResult<bool>> deleteAddress(int id) async {
    try {
      await _apiClient.delete(ApiConstants.addressDetail(id));
      return const Success(true);
    } on ApiException catch (e) {
      return Failure(e.message);
    } catch (e) {
      return Failure(e.toString());
    }
  }

  Future<ApiResult<bool>> setDefaultAddress(int id) async {
    try {
      await _apiClient.post(ApiConstants.setAddressDefault(id));
      return const Success(true);
    } on ApiException catch (e) {
      return Failure(e.message);
    } catch (e) {
      return Failure(e.toString());
    }
  }

  Future<ApiResult<List<City>>> getCities() async {
    try {
      final response = await _apiClient.get(ApiConstants.cities());
      final cityListResponse = CityListResponse.fromJson(response);
      return Success(cityListResponse.data);
    } on ApiException catch (e) {
      return Failure(e.message);
    } catch (e) {
      return Failure(e.toString());
    }
  }

  Future<ApiResult<List<District>>> getDistricts(int cityId) async {
    try {
      final response = await _apiClient.get(ApiConstants.districts(cityId));
      final dynamicListResponse = DistrictListResponse.fromJson(response);
      return Success(dynamicListResponse.data);
    } on ApiException catch (e) {
      return Failure(e.message);
    } catch (e) {
      return Failure(e.toString());
    }
  }
}
