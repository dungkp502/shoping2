import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:food_app/data/repository/location_repo.dart';
import 'package:food_app/models/response_model.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/address_model.dart';

class LocationController extends GetxController implements GetxService {
  LocationRepo locationRepo;

  LocationController({required this.locationRepo}) {
    // Khởi tạo _getAddress với giá trị mặc định
    _getAddress = {}; // Cung cấp giá trị mặc định cho _getAddress
  }

  bool _loading = false;
  late Position _position;
  late Position _pickedPosition;
  Placemark _placemark = Placemark();
  Placemark _pickedPlaceMark = Placemark();
  Placemark get placeMark => _placemark;
  Placemark get pickPlaceMark => _pickedPlaceMark;

  List<AddressModel> _addressList = [];
  List<AddressModel> get addressList => _addressList;

  late List<AddressModel> _allAddresList;
  List<AddressModel> get allAddressList => _allAddresList;

  final List<String> _addressTypeList = ['Home', 'Work', 'Other'];
  List<String> get addressTypeList => _addressTypeList;

  int _addressTypeIndex = 0;
  int get addressTypeIndex => _addressTypeIndex;

  late Map<String, dynamic> _getAddress;
  Map<String, dynamic> get getAddress => _getAddress;

  late GoogleMapController _mapController;
  GoogleMapController get mapController => _mapController;

  bool _updateAddressData = true;
  bool _changeAddress = true;

  bool get loading => _loading;
  Position get position => _position;
  Position get pickPosition => _pickedPosition;


  void setMapController(GoogleMapController mapController) {
    _mapController = mapController;
  }

  void updatePosition(CameraPosition cameraPosition, bool fromAddress) async {
    if (_updateAddressData) {
      _loading = true;
      update();
      try {
        if (fromAddress) {
          _position= Position(
              longitude: cameraPosition.target.longitude,
              latitude: cameraPosition.target.latitude,
              timestamp: DateTime.now(),
              accuracy: 1,
              altitude: 1,
              heading: 1,
              speed: 1,
              speedAccuracy: 1);
        } else {
          _pickedPosition= Position(
              longitude: cameraPosition.target.longitude,
              latitude: cameraPosition.target.latitude,
              timestamp: DateTime.now(),
              accuracy: 1,
              altitude: 1,
              heading: 1,
              speed: 1,
              speedAccuracy: 1);
        }
        if (_changeAddress) {

          // Sử dụng placemarkFromCoordinates để lấy thông tin địa chỉ chi tiết
          List<Placemark> placemarks = await placemarkFromCoordinates(
            cameraPosition.target.latitude,
            cameraPosition.target.longitude,
          );

          if (placemarks.isNotEmpty) {
            Placemark placemark = placemarks.first;
            if (fromAddress) {
              _placemark = placemark;  // Gán giá trị Placemark đầy đủ
            } else {
              _pickedPlaceMark = placemark;  // Gán giá trị Placemark đầy đủ
            }
          } else {
            print('Không tìm thấy placemark');
          }

        }
      } catch(e) {
        print(e);
      }
    }
  }

  // Có thể thêm phương thức để cập nhật địa chỉ
  void updateAddress(Map<String, dynamic> newAddress) {
    _getAddress = newAddress;
  }

  Future<String> getAddressFromGeocode() async {
    String _address = 'Unknown Address';

    // Lấy vị trí hiện tại của thiết bị
    Position? position = await getCurrentPosition();

    if (position != null) {
      // Sử dụng thư viện geocoding để chuyển tọa độ thành địa chỉ
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
        // Chọn địa chỉ đầu tiên và gán vào _address
        // Placemark placemark = placemarks.first;
        Placemark placemark = placemarks.first;

        // Gán địa chỉ vào _address từ các thông tin trong placemark
        // _address = '${placemark.name}, ${placemark.street}, ${placemark.subLocality}, ${placemark.country}';
        _address = placemark.toString();
      } catch (e) {
        print('Error while getting address: $e');
      }
    } else {
      print('Error: Could not retrieve position');
    }

    return _address;
  }

  Future<Position?> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Kiểm tra nếu dịch vụ vị trí đã bật
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Nếu dịch vụ chưa bật, hiển thị thông báo yêu cầu bật dịch vụ
      print('Location services are disabled.');
      return null;
    }

    // Kiểm tra nếu quyền đã được cấp
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied');
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('Location permissions are permanently denied, we cannot request permissions.');
      return null;
    }

    // Lấy vị trí hiện tại
    return await Geolocator.getCurrentPosition();
  }



  // AddressModel getUserAddress() {
  //   late AddressModel _addressModel;
  //
  //   _getAddress = jsonDecode(locationRepo.getUserAddress() as String);
  //   try {
  //     _addressModel = AddressModel.fromJson(_getAddress);
  //     // _addressList.add(addressModel);
  //   } catch (e) {
  //     print(e);
  //   }
  //   return _addressModel;
  // }
  Future<void> getUserAddress() async {
    String? addressData = await locationRepo.getUserAddress();
    if (addressData != null) {
      try {
        var decodedData = jsonDecode(addressData);
        AddressModel addressModel = AddressModel.fromJson(decodedData);
        addressList.add(addressModel); // Thêm vào addressList
        _getAddress = decodedData; // Cập nhật _getAddress
        print("controller addressList" + addressList[0].toJson().toString());
      } catch (e) {
        print("Error parsing address data: $e");
      }
    } else {
      print("Address data is null");
    }
  }



  void setAddressTypeIndex(int index) {
    _addressTypeIndex = index;
    update();
  }

  Future<ResponseModel> addAddress(AddressModel addressModel) async {
    _loading = true;
    update();
    Response response = await locationRepo.addUserAddress(addressModel);
    // print("response111: "+response.body.toString());
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      // print("Đã thêm thành công");
      await getAddressList();
      String message = response.body['message'];
      responseModel = ResponseModel(true, message);
      // print("save address"+ addressModel.toJson().toString()  );
      await saveUserAddress(addressModel);
    } else {
      String message = response.body['message'];
      responseModel = ResponseModel(false, message);
    }
    update();
    return responseModel;
  }

  Future<void> getAddressList() async {
    Response response = await locationRepo.getAllAddress();
    if (response.statusCode == 200) {
      _addressList = [];
      _allAddresList = [];
      response.body.forEach((address) {
        AddressModel addressModel = AddressModel.fromJson(address);
        _addressList.add(addressModel);
        _allAddresList.add(addressModel);
      });
    } else {
      _addressList = [];
      _allAddresList = [];
    }
    update();
  }

  Future<bool> saveUserAddress(AddressModel addressModel) async {
    String userAddress = jsonEncode(addressModel.toJson());
    return await locationRepo.saveAddress(userAddress);
  }

  void clearAddress() {
    locationRepo.clearLocation();
    update();
  }
}

