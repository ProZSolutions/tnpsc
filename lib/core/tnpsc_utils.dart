import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TNPSCUtils {
  Future<bool> isInternetConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }
  customGetSnackBarWithOutActionButton(titlemsg, contentmsg, context) {
    return Get.snackbar(
      titlemsg,
      contentmsg,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      isDismissible: true,
      duration: Duration(seconds: 3),
    );
  }
}
