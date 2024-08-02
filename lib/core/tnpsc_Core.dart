library gm_core;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
// import 'package:flowder/flowder.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
//import 'package:open_filex/open_filex.dart';
// import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tnpsc/core/constant.dart';
import 'package:tnpsc/core/meta.dart';
import 'package:tnpsc/login/login_page.dart';
import 'package:tnpsc/main.dart';
import 'package:url_launcher/url_launcher.dart';

import 'errorCode.dart';
import 'tnpsc_utils.dart';


class TNPSCService {
  static int connectionTimeOut = 30000;
  static int receiveTimeout = 30000;

  static Dio dio = new Dio();
  var log = new Logger();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  void configAPI() {
    // Set default configs
    dio = new Dio();
    dio.options.connectTimeout = connectionTimeOut;
    dio.options.receiveTimeout = receiveTimeout;
    dio.options.headers["content-type"] = "application/json";
    dio.options.headers["Accept"] = "application/json";
//    dio.options.headers["User-Agent"] = "Android";
//    dio.options.headers["Platform"] = "Android";
  }

  bool validateRequest(String url) {
    if (null != url && url.length > 0) {
      return true;
    }
    return false;
  }


  Future<Meta> processGetURL(String url, String authToken) async {
    // debugPrint(url);
    Meta meta = new Meta();
    if (validateRequest(url)) {
      bool isNetworkAvailable = await TNPSCUtils().isInternetConnected();
      if (isNetworkAvailable) {
        try {
          dio.options.headers["Authorization"] = "Bearer " + authToken;
          dio.options.headers['Content-Length'] = 0;

          Response response = await dio.get(url);

          return _getResponse(response);
        } catch (error) {
          return handleError(error);
        }
      } else {
        meta = new Meta(
            statusCode: ErrorCode.URL_NOT_VALID, statusMsg: "Not a valid URL");
        return meta;
      }
    }
    return meta;
  }

  void logPrinting(String response) {
    log.v(response);
  }

  Meta _getResponse(Response response) {
    // Meta data = new Meta();
    debugPrint("RESP"+response.statusCode.toString()+" "+response.data
        .toString());
    Meta data = new Meta();
    if (response.statusCode == 200) {
      if (response.data
          .toString()
          .isNotEmpty) {
        if(response.data
            .toString().startsWith("<!doctype html>")){
          _prefs.then((value){
            value.setString("AUTH_TOKEN", "");
            value.setString("USER_TYPE", "");
            value.setString("CENTER_CODE", "");
          });
          Constants.AUTH_TOKEN = "";
          Constants.USER_TYPE="";
          Constants.CENTER_CODE="";
          Constants.isChennaiCenter=false;
          Navigator.popUntil(navigatorKey.currentContext!,
              ModalRoute.withName('/login'));
          Navigator.push(navigatorKey.currentContext!,
              MaterialPageRoute(
                  builder: (context) =>
                      LoginPage()));
        }else{
          data.statusMsg = response.data.toString();
          data.response=response.data;
          data.statusCode = response.statusCode!;
        }
      }
    } else if (response.statusCode == 409 || response.statusCode == 422) {
      data.statusMsg = response.data.toString();
      data.response=jsonDecode(response.data);
      data.statusCode = response.statusCode!;
    } else if(response.statusCode==401){
      _prefs.then((value){
        value.setString("AUTH_TOKEN", "");
        value.setString("USER_TYPE", "");
        value.setString("CENTER_CODE", "");
      });
      Constants.AUTH_TOKEN = "";
      Constants.USER_TYPE="";
      Constants.CENTER_CODE="";
      Constants.isChennaiCenter=false;
      Navigator.popUntil(navigatorKey.currentContext!,
          ModalRoute.withName('/login'));
      Navigator.push(navigatorKey.currentContext!,
          MaterialPageRoute(
              builder: (context) =>
                  LoginPage()));
    }else {
      if (response.data != null && response.data
          .toString()
          .length > 0) {
        try {
          data.statusMsg = response.data.toString();
          data.statusCode = response.statusCode!;
          data.response = response.data;
        }catch(e){
          _prefs.then((value){
            value.setString("AUTH_TOKEN", "");
            value.setString("USER_TYPE", "");
            value.setString("CENTER_CODE", "");
          });
          Constants.AUTH_TOKEN = "";
          Constants.USER_TYPE="";
          Constants.CENTER_CODE="";
          Constants.isChennaiCenter=false;
          Navigator.popUntil(navigatorKey.currentContext!,
              ModalRoute.withName('/login'));
          Navigator.push(navigatorKey.currentContext!,
              MaterialPageRoute(
                  builder: (context) =>
                      LoginPage()));
        }
      } else {
        data.statusMsg = response.data.toString();
        data.statusCode = response.statusCode!;
        data.response=response.data;
      }
    }
    return data;
  }

  Meta handleError(error) {
    if (error.type == DioErrorType.receiveTimeout ||
        error.type == DioErrorType.connectTimeout) {
      return throwError(ErrorCode.CONNECTION_TIMEOUT, "Connection Timeout!");
    } else if (error.type == DioErrorType.response) {
      if (error.response.statusCode == 401 &&
          error.response.data == 'TOKEN EXPIRED') {}
      return throwError(error.response.statusCode, error.response.toString());
    } else {
      return throwError(ErrorCode.COMMUNICATION_ERROR, "Communication Error");
    }
  }

  Meta throwError(int errorCode, String errorMsg) {
    Meta meta = new Meta(statusCode: errorCode, statusMsg: errorMsg);
    return meta;
  }

  Future<Meta> processPostURL(String url, Map<String, dynamic> data,
      String authToken) async {
    Meta meta = new Meta();
    bool isNetworkAvailable = await TNPSCUtils().isInternetConnected();
    if (isNetworkAvailable) {
      if (validateRequest(url)) {
        var formData = FormData.fromMap(data);
        //String bodyData = jsonEncode(data);
        if(authToken!="") {
          dio.options.headers["Authorization"] = "Bearer " + authToken;
        }
        //dio.options.headers['Content-Length'] = bodyData.length.toString();
        // dio.interceptors.add(LogInterceptor(responseBody: false));
        try {
          Response response = await dio.post(url, data: formData);

          return _getResponse(response);
        } catch (e) {
          debugPrint(e.toString());
          return handleError(e);
        }
      } else {
        meta = new Meta(
            statusCode: ErrorCode.URL_NOT_VALID, statusMsg: "Not a valid URL");
        return meta;
      }
    }
    return meta;
  }
  Future<String> _prepareSaveDir() async {
    String _path = (await _findLocalPath())!;
    String _localPath = _path + Platform.pathSeparator + 'tnpsc';
    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
    return _localPath;
  }

  Future<String?> _findLocalPath() async {
    var externalStorageDirPath;
    if (Platform.isAndroid) {
        final directory = await getApplicationDocumentsDirectory();
        externalStorageDirPath = directory?.path;
    } else if (Platform.isIOS) {
      externalStorageDirPath =
          (await getApplicationDocumentsDirectory()).absolute.path;
    }
    return externalStorageDirPath;
  }
  Future<void> downloadFile(String url,String fileName) async{
    // String localPath=await _prepareSaveDir();
    // debugPrint(localPath);
    // final taskId = await FlutterDownloader.enqueue(
    //   url: url,
    //   savedDir: localPath,
    //   showNotification: true,
    //   openFileFromNotification: true,
    // );

    /* commented for removing external storage access
    String localPath=await _prepareSaveDir();
    debugPrint(localPath);
    var options = DownloaderUtils(
      progressCallback: (current, total) {
        final progress = (current / total) * 100;
        print('Downloading: $progress');
      },
      file: File(localPath+Platform.pathSeparator+fileName),
      progress: ProgressImplementation(),
      onDone: () async{
        //final result = await OpenFilex.open(localPath+Platform.pathSeparator+fileName);
        // OpenFile.open(localPath+Platform.pathSeparator+fileName);
      },
      deleteOnCancel: true,
    );
    var core = await Flowder.download(
      url,
      options,
    );*/
    _launchInBrowser(url);
  }
  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<bool> checkPermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }
  void showDownloadProgress(received, total) {
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + "%");
    }
  }
  Future download2(String url,String fileName) async {
    String savePath="/storage/emulated/0/Download/";
    savePath=savePath+fileName;
    try {
      Response response = await dio.get(
        url,
        onReceiveProgress: showDownloadProgress,
        //Received data with List<int>
        options: Options(

            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }),
      );
      print(response.headers);
      print(savePath);
      File file = File(savePath);
      var raf = file.openSync(mode: FileMode.write);
      // response.data is List<int> type
      raf.writeFromSync(response.data);
      await raf.close();
    } catch (e) {
      print(e);
    }
  }

}
