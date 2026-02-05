import 'package:flutter/foundation.dart';
import '../core/network/api_result.dart';
import '../models/address_model.dart';
import '../models/city_model.dart';
import '../models/district_model.dart';
import '../services/address_service.dart';
import '../core/utils/logger.dart';

class AddressViewModel extends ChangeNotifier {
  final AddressService _addressService;

  AddressViewModel(this._addressService);

  bool _isLoading = false;
  String? _errorMessage;
  List<Address> _addresses = [];
  List<City> _cities = [];
  List<District> _districts = [];
  City? _selectedCity;
  District? _selectedDistrict;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Address> get addresses => _addresses;
  List<City> get cities => _cities;
  List<District> get districts => _districts;
  City? get selectedCity => _selectedCity;
  District? get selectedDistrict => _selectedDistrict;

  Future<void> fetchAddresses() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _addressService.getAddresses();

    if (result is Success<List<Address>>) {
      _addresses = result.data;
      Logger.info(
        "Addresses fetched successfully: ${_addresses.length} addresses",
      );
    } else if (result is Failure<List<Address>>) {
      _errorMessage = result.errorMessage;
      Logger.error("Addresses fetch failed", _errorMessage ?? "Unknown error");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> createAddress(CreateAddressRequest request) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _addressService.createAddress(request);

    if (result is Success<Address>) {
      Logger.info("Address created successfully: ${result.data.title}");
      _isLoading = false;
      notifyListeners();
      return true;
    } else if (result is Failure<Address>) {
      _errorMessage = result.errorMessage;
      Logger.error("Address creation failed", _errorMessage ?? "Unknown error");
      _isLoading = false;
      notifyListeners();
      return false;
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> updateAddress(int id, CreateAddressRequest request) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _addressService.updateAddress(id, request);

    if (result is Success<Address>) {
      Logger.info("Address updated successfully: ${result.data.title}");
      _isLoading = false;
      notifyListeners();
      return true;
    } else if (result is Failure<Address>) {
      _errorMessage = result.errorMessage;
      Logger.error("Address update failed", _errorMessage ?? "Unknown error");
      _isLoading = false;
      notifyListeners();
      return false;
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> deleteAddress(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _addressService.deleteAddress(id);

    if (result is Success<bool>) {
      Logger.info("Address deleted successfully: ID $id");
      await fetchAddresses(); // Refresh list after delete
      return true;
    } else if (result is Failure<bool>) {
      _errorMessage = result.errorMessage;
      Logger.error("Address deletion failed", _errorMessage ?? "Unknown error");
      _isLoading = false;
      notifyListeners();
      return false;
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  void refresh() {
    fetchAddresses();
  }

  Future<void> fetchCities() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _addressService.getCities();

    if (result is Success<List<City>>) {
      _cities = result.data;
    } else if (result is Failure<List<City>>) {
      _errorMessage = result.errorMessage;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchDistricts(int cityId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _addressService.getDistricts(cityId);

    if (result is Success<List<District>>) {
      _districts = result.data;
    } else if (result is Failure<List<District>>) {
      _errorMessage = result.errorMessage;
    }

    _isLoading = false;
    notifyListeners();
  }

  void setSelectedCity(City? city) {
    _selectedCity = city;
    _selectedDistrict = null;
    _districts = [];
    if (city != null) {
      fetchDistricts(city.id);
    }
    notifyListeners();
  }

  void setSelectedDistrict(District? district) {
    _selectedDistrict = district;
    notifyListeners();
  }

  void resetSelection() {
    _selectedCity = null;
    _selectedDistrict = null;
    _districts = [];
    notifyListeners();
  }
}
