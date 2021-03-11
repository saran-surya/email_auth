import 'dart:async';
import 'dart:convert' as convert;

import 'package:http/http.dart' as http;

class EmailAuth {
  /// A class to handle the operations
  ///
  /// Assign your session Name / Company name here using the static method
  static late String sessionName;
  static late String _finalOTP;
  static late String _finalEmail;

  static bool _isEmail(String email) {
    String p = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regExp = new RegExp(p);
    print(regExp.hasMatch(email));
    return regExp.hasMatch(email);
  }

  ///This functions returns a future of boolean stating if the OTP was sent.
  static Future<bool> sendOtp({required String receiverMail}) async {
    try {
      if (!_isEmail(receiverMail)) {
        print("email ID is not valid");
        return false;
      }
      http.Response _response = await http.get(
        Uri.parse(
          "https://app-authenticator.herokuapp.com/auth/${receiverMail.toLowerCase()}?CompanyName=$sessionName",
        ),
      );
      Map<String, dynamic> _data = convert.jsonDecode(_response.body);
      if (_data["success"]) {
        _finalEmail = receiverMail;
        _finalOTP = _data["OTP"].toString();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  ///This functions returns a future of boolean stating if the user provided data is correct
  static bool validate({required String receiverMail, required String userOTP}) {
    if (_finalEmail.length > 0 && _finalOTP.length > 0) {
      if (receiverMail.trim() == _finalEmail.trim() && userOTP.trim() == _finalOTP.trim()) {
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
