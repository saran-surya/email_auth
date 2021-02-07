// You have generated a new plugin project without
// specifying the `--platforms` flag. A plugin project supports no platforms is generated.
// To add platforms, run `flutter create -t plugin --platforms <platforms> .` under the same
// directory. You can also find a detailed instruction on how to add platforms in the `pubspec.yaml` at https://flutter.dev/docs/development/packages-and-plugins/developing-packages#plugin-platforms.

import 'dart:async';
// import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class EmailAuth {
  // static const MethodChannel _channel = const MethodChannel('email_auth');
  // static Future<String> get platformVersion async {
  //   final String version = await _channel.invokeMethod('getPlatformVersion');
  //   return version;
  // }

  static String sessionName;
  static String _finalOTP;
  static String _finalEmail;

  static bool _isEmail(String email) {
    String p =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regExp = new RegExp(p);
    print(regExp.hasMatch(email));
    return regExp.hasMatch(email);
  }

  static Future<bool> sendOtp({String recieverMail}) async {
    try {
      if (!_isEmail(recieverMail)) {
        print("email ID is not valid");
        return false;
      }
      http.Response _response = await http.get(
          "https://app-authenticator.herokuapp.com/auth/${recieverMail.toLowerCase()}?CompanyName=$sessionName");
      Map<String, dynamic> _data = convert.jsonDecode(_response.body);
      if (_data["success"]) {
        _finalEmail = recieverMail;
        _finalOTP = _data["OTP"].toString();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e.message);
      return false;
    }
  }

  static bool validate({String recieverMail, String userOTP}) {
    if (_finalEmail.length > 0 && _finalOTP.length > 0) {
      if (recieverMail.trim() == _finalEmail.trim() &&
          userOTP.trim() == _finalOTP.trim()) {
        print("Validation success");
        return true;
      } else {
        print("Validation Falied");
        return false;
      }
    }
    print("Missing Data");
    return false;
  }
}
