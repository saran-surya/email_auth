import 'dart:async';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class EmailAuth {
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

  static Future<bool> sendOtp({@required String receiverMail}) async {
    try {
      if (!_isEmail(receiverMail)) {
        print("email ID is not valid");
        return false;
      }
      http.Response _response = await http.get(
          "https://app-authenticator.herokuapp.com/auth/${receiverMail.toLowerCase()}?CompanyName=$sessionName");
      Map<String, dynamic> _data = convert.jsonDecode(_response.body);
      if (_data["success"]) {
        _finalEmail = receiverMail;
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

  static bool validate({
    @required String receiverMail,
    @required String userOTP,
  }) {
    if (_finalEmail.length > 0 && _finalOTP.length > 0) {
      if (receiverMail.trim() == _finalEmail.trim() &&
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
