import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_app/controllers/auth_controller.dart';
import 'package:food_app/controllers/location_controller.dart';
import 'package:food_app/controllers/user_controller.dart';
import 'package:food_app/models/address_model.dart';
import 'package:food_app/models/user_model.dart';
import 'package:food_app/utils/colors.dart';
import 'package:food_app/utils/dimension.dart';
import 'package:food_app/widgets/app_text_field.dart';
import 'package:food_app/widgets/big_text.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../widgets/app_icon.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({super.key});

  @override
  State<AddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddressPage> {
  TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactPersonName = TextEditingController();
  final TextEditingController _contactPersonNumber = TextEditingController();
  late bool _isLogged;
  CameraPosition _cameraPosition = CameraPosition(target: LatLng(
      16.043909159314207, 108.2119319960475), zoom: 17);
  late LatLng _initialPosition = LatLng(
      16.043909159314207, 108.2119319960475);

  @override
  void initState() {
    super.initState();
    _isLogged = Get.find<AuthController>().userIsLoggedIn();
    if (_isLogged&&Get.find<UserController>().userModel==null) {
      print("user null");
      Get.find<UserController>().getUserData();
    }

    if (Get.find<LocationController>().addressList.isEmpty) {
      Get.find<LocationController>().getUserAddress();
      print("latitude: " + Get.find<LocationController>().getAddress["latitude"].toString());
      print("longitude: " + Get.find<LocationController>().getAddress["longitude"].toString());
      // Kiểm tra và sử dụng tọa độ mặc định nếu không có địa chỉ nào
      double latitude = Get.find<LocationController>().getAddress["latitude"] != null
          ? double.parse(Get.find<LocationController>().getAddress["latitude"])
          : 16.047079; // Giá trị mặc định
      double longitude = Get.find<LocationController>().getAddress["longitude"] != null
          ? double.parse(Get.find<LocationController>().getAddress["longitude"])
          : 108.206230; // Giá trị mặc định

      _cameraPosition = CameraPosition(target: LatLng(latitude, longitude));
      _initialPosition = LatLng(latitude, longitude);
    } else {
      print("addressList null");
      print("latitude: " + Get.find<LocationController>().getAddress["latitude"].toString());
      print("longitude: " + Get.find<LocationController>().getAddress["longitude"].toString());
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Address page", style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.mainColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: GetBuilder<UserController>(builder: (userController) {
        print("" + userController.userModel.toString() );
        if (userController.userModel != null && _contactPersonName.text.isEmpty) {
          _contactPersonName.text = userController.userModel.name;
          _contactPersonNumber.text = userController.userModel.phone;
          if (Get.find<LocationController>().addressList.isNotEmpty) {
            // _addressController.text =  Get.find<LocationController>().getUserAddress().address;
            _addressController.text = Get.find<LocationController>().addressList[0].address;
            print("_addressController.text: " + _addressController.text);
          }
        }
        return GetBuilder<LocationController>(builder: (locationController) {
          _addressController.text = '${locationController.placeMark.street?? 'street'}'
              ', ${locationController.placeMark.subAdministrativeArea?? 'subLocality'}'
              ', ${locationController.placeMark.administrativeArea?? 'administrativeArea'}'
              ', ${locationController.placeMark.country?? 'country'}';
          // print("_addressController: " + _addressController.text);
          // print(locationController.placeMark.toString());
          // print(locationController.placeMark.runtimeType); // Kiểm tra kiểu dữ liệu của placeMark
          // print(locationController.placeMark.toString()); // In tất cả các thuộc tính của Placemark
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    height: Dimension.height100*2,
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(left: Dimension.height5, right: Dimension.height5, top: Dimension.height5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            width: 2, color: AppColors.mainColor
                        )
                    ),
                    child: Stack(
                      children: [
                        RepaintBoundary(
                          child: GoogleMap(
                            initialCameraPosition: CameraPosition(target: _initialPosition, zoom: 17),
                            zoomControlsEnabled: false,
                            compassEnabled: false,
                            indoorViewEnabled: true,
                            mapToolbarEnabled: false,
                            myLocationButtonEnabled: true,
                            onCameraIdle: () {
                              Timer(const Duration(seconds: 2), () {
                                locationController.updatePosition(_cameraPosition, true);
                              });
                            },
                            onCameraMove: ((position) => _cameraPosition = position),
                            onMapCreated: (GoogleMapController controller) {
                              locationController.setMapController(controller);
                            },
                          ),
                        )
                        // CameraPosition(target: _initialPosition, zoom: 17)),
                      ],
                    )
                ),
                Padding(
                  padding: EdgeInsets.only(left: Dimension.height20, top: Dimension.height20),
                  child: SizedBox(height: 50, child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: locationController.addressTypeList.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            locationController.setAddressTypeIndex(index);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: Dimension.height20, vertical: Dimension.height20),
                            margin: EdgeInsets.only(right: Dimension.height20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimension.height20/4),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey[200]!,
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  // offset: Offset(0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  index == 0? Icons.home : index == 1 ? Icons.work : Icons.location_on,
                                  color: locationController.addressTypeIndex == index ? AppColors.mainColor : Theme.of(context).disabledColor,
                                )
                              ],
                            ),
                          ),
                        );
                      }),),
                ),
                SizedBox(height: Dimension.height20,),
                Padding(
                  padding: EdgeInsets.only(left: Dimension.height20),
                  child: BigText(text: "Delivery Address"),
                ),
                AppTextField(textEditingController: _addressController, hintText: "Your address", icon: Icons.map),
                SizedBox(height: Dimension.height5,),
                Padding(
                  padding: EdgeInsets.only(left: Dimension.height20),
                  child: BigText(text: "Your Name"),
                ),
                AppTextField(textEditingController: _contactPersonName, hintText: "Your name", icon: Icons.person),
                SizedBox(height: Dimension.height5,),
                Padding(
                  padding: EdgeInsets.only(left: Dimension.height20),
                  child: BigText(text: "Your Phone"),
                ),
                AppTextField(textEditingController: _contactPersonNumber, hintText: "Your phone", icon: Icons.phone),
              ],
            ),
          );
        });
      })

      ,
      bottomNavigationBar: GetBuilder<LocationController>(builder: (controller) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: Dimension.height120,
              padding: EdgeInsets.only(top: Dimension.height30, bottom: Dimension.height20),
              decoration: BoxDecoration(
                  color: AppColors.buttonBackgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(Dimension.height20*2),
                    topRight: Radius.circular(Dimension.height20*2),
                  )
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      print("addressTypeIndex: " + _addressController.text);
                      // print("address type" + controller.addressTypeList[controller.addressTypeIndex]);
                      AddressModel addressModel = AddressModel(
                          addressType: controller.addressTypeList[controller.addressTypeIndex],
                          contactPersonName: _contactPersonName.text,
                          contactPersonNumber: _contactPersonNumber.text,
                          address: _addressController.text,
                          latitude: controller.position.latitude.toString(),
                          longitude: controller.position.longitude.toString()

                      );
                      controller.addAddress(addressModel).then((response) {
                        if (response.isSuccess) {
                          Get.back();
                          Get.snackbar("Address", response.message);
                        } else {
                          Get.snackbar("Address", response.message);
                        }
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.only(top: Dimension.height20, bottom: Dimension.height20, left: Dimension.width20, right: Dimension.width20),
                      margin: EdgeInsets.only(right: Dimension.height20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimension.radius20),
                          color: AppColors.mainColor
                      ),

                      child: BigText(text: "Save", color: Colors.white, textOverflow: TextOverflow.clip, size: Dimension.font_size16,),
                    ),
                  )
                ],
              ),
            )
          ],
        );
      }),
    );
  }
}
