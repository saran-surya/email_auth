/// This file contains a Class to handle the process of sending OTP
/// There are no static methods like the previous one, and they are all instance members
///
/// ------------- Remote server config --------------
/// requires a auth.config.dart pacakge
/// should follow the variable conventions as follows :
/// var remoteServerConfig = {"server" : "serverUrl", "serverKey" : "Key generted from the email-auth-node package"}
/// You can pass "remoteServerConfig" to the emailAuth instance.config() and generate them.

import 'dart:async';
import 'dart:convert' as convert;
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

late String _finalOTP;
late String _finalEmail;

/// This function will check if the provided email ID is valid or not
bool _isEmail(String email) {
  String p =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  RegExp regExp = new RegExp(p);
  return regExp.hasMatch(email);
}

Future<bool> _isValidServer(String url) async {
  try {
    /// Performs a get request to the dummy end of the server :
    /// Expected result : {"message" : "success"}
    http.Response _serverResponse = await http.get(Uri.parse("$url/test/dart"));
    Map<String, dynamic> _jsonResponse =
        convert.jsonDecode(_serverResponse.body);
    return (_jsonResponse.containsKey("message") &&
        _jsonResponse['message'] == 'success');
  } catch (error) {
    print("--- Package Error ---");
    if (error.runtimeType == FormatException) {
      print("Unable to access remote server. 😑");
    } else {
      print(error);
    }
    // print(error);
    print("--- End Package Error ---");
    return false;
  }
}

/// This function will take care of converting the reponse data and verify the mail ID provided.
bool _convertData(http.Response _response, String recipientMail) {
  try {
    Map<String, dynamic> _data = convert.jsonDecode(_response.body);
    // print(_data); // : For future verification

    /// On Success get the data from the message and store them in the variables for the final verification
    if (_data["success"]) {
      _finalEmail = recipientMail;
      _finalOTP = _data["OTP"].toString();
      print("email-auth >> OTP sent successfully ✅");
      return true;
    } else {
      print("email-auth >> Failed to send OTP ❌");
      print("email-auth >> Message from server :: ${_data["error"]}");
      return false;
    }
  } catch (error) {
    print("--- Package Error ---");
    if (error.runtimeType == FormatException) {
      print("Unable to access server. 😑");
    } else {
      print(error);
    }
    // print(error);
    print("--- End Package Error ---");
    return false;
  }
}

class EmailAuth {
  // The server
  late String _server = "";
  late String _serverKey = "";
  bool _validRemote = false;

  // The session name
  String sessionName;

  // Contructing the Class with the server and the session Name
  EmailAuth({
    required this.sessionName,
  }) {
    print("email-auth >> Initialising Email-Auth server");

    // future patch
    // _init();
  }

  // made for future patch
  // _init() {  }

  /// configuring the external server
  /// the Map should be of the pattern {"server" : "", "serverKey" : ""}
  Future<bool> config(Map<String, String> data) async {
    try {
      // Check the existence of the keys
      // print(data);

      if (data.containsKey('server') &&
          data.containsKey('serverKey') &&
          data['server'] != null &&
          data['server']!.length > 0 &&
          data['serverKey'] != null &&
          data['serverKey']!.length > 0) {
        /// Only proceed further if the server is valid as per the function _isValidServer
        if (await _isValidServer(data['server']!)) {
          this._server = data['server']!;
          this._serverKey = data['serverKey']!;
          this._validRemote = true;
          print("email-auth >> The remote server configurations are valid");
          return true;
        } else {
          throw new ErrorDescription(
              "email-auth >> The remote server is not a valid.\nemail-auth >> configured server : \"${data['server']}\"");
        }
      } else {
        throw new ErrorDescription(
            "email-auth >> Remote server configurations are not valid");
      }
    } catch (error) {
      print("\n--- package Error ---\n");
      print(error);
      print("--- package Error ---");
      return false;
    }
  }

  /// Takes care of sending the OTP to the server.
  /// returns a Boolean.
  Future<bool> sendOtp(
      {required String recipientMail, int otpLength = 6}) async {
    try {
      if (!_isEmail(recipientMail)) {
        print("email-auth >> email ID provided is INVALID");
        return false;
      }

      /// Defaults to the test server (reverts) : if the remote server is provided
      if (this._server.isEmpty) {
        print(
            "email-auth >> Remote server is not available -- using test server --");
        print("email-auth >> ❗ Warning this is not reliable on production");
        http.Response _response = await http.get(Uri.parse(
            // ignore: unnecessary_brace_in_string_interps
            "https://app-authenticator.herokuapp.com/dart/auth/${recipientMail}?CompanyName=${this.sessionName}"));

        return _convertData(_response, recipientMail);
      } else if (_validRemote) {
        http.Response _response = await http.get(Uri.parse(
            "${this._server}/dart/auth/$recipientMail?CompanyName=${this.sessionName}&key=${this._serverKey}&otpLength=$otpLength"));
        return _convertData(_response, recipientMail);
      }
      return false;
    } catch (error) {
      print("--- Package Error ---");
      print(error);
      print("--- End Package Error ---");
      return false;
    }
  }

  /// Boolean function to verify that the provided OTP and the user Email Ids, are all same.
  bool validateOtp({required String recipientMail, required String userOtp}) {
    if (_finalEmail.isEmpty || _finalOTP.isEmpty) {
      print(
          "email-auth >> The OTP should be sent before performing validation");
      return false;
    }

    if (_finalEmail.trim() == recipientMail.trim() &&
        _finalOTP.trim() == userOtp.trim()) {
      print("email-auth >> Validation success ✅");
      return true;
    }

    print("email-auth >> Validation failure ❌");
    return false;
  }
}
