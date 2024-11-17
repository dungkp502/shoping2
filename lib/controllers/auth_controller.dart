import 'package:food_app/models/response_model.dart';
import 'package:food_app/models/signup_body_model.dart';
import 'package:get/get.dart';

import '../data/repository/auth_repo.dart';

class AuthController extends GetxController implements GetxService {
  final AuthRepo authRepo;
  AuthController({required this.authRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<ResponseModel> register(SignUpBody signUpBody) async {
    _isLoading = true;
    update();
    Response response = await authRepo.register(signUpBody);
    late ResponseModel responseModel;
    if (response.statusCode == 200) {
      authRepo.saveUserToken(response.body['token']);
      responseModel = ResponseModel(true, response.body['token']);
      // print(response.body['token'].toString());
    } else {
      responseModel = ResponseModel(false, response.statusText!);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> login(String phone, String password) async {
    // print("Sign in Token "+ authRepo.getUserToken().toString());
    _isLoading = true;
    update();
    Response response = await authRepo.login(phone, password);
    // print("token" + response.body['token'].toString());
    late ResponseModel responseModel;
    // print(authRepo.saveUserToken(response.body['token']));
    if (response.statusCode == 200) {
      print("Backend Token");
      authRepo.saveUserToken(response.body['token']);
      print(response.body['token'].toString());
      responseModel = ResponseModel(true, response.body['token']);
    } else {
      responseModel = ResponseModel(false, response.statusText!);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  void saveUserNumberAndPass(String number, String password)  {
    authRepo.saveUserNumberAndPass(number, password);
  }

  bool userIsLoggedIn() {
    return authRepo.userIsLoggedIn();
  }

  bool clearSharedPref() {
    return authRepo.clearSharedPref();
  }
}