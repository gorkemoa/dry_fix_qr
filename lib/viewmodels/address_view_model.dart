import 'package:flutter/foundation.dart';
import '../core/network/api_result.dart';
import '../models/address_model.dart';
import '../services/address_service.dart';
import '../core/utils/logger.dart';

class AddressViewModel extends ChangeNotifier {
  final AddressService _addressService;

  AddressViewModel(this._addressService);

  bool _isLoading = false;
  String? _errorMessage;
  List<Address> _addresses = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Address> get addresses => _addresses;

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

  void refresh() {
    fetchAddresses();
  }
}
