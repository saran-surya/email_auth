import 'dart:async';
import 'dart:convert' as convert;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

late String _finalOTP;
late String _finalEmail;

Map<String, String> _serverRuntime = {"validRemote": "false"};

/// Validates the email ID provided.
bool _isEmail(String email) {
  return (new RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")).hasMatch(email);
}

/// Checks the feasiblity of the server provided for matching
/// url patterns, GET POST request patterns
Future<bool> _isValidServer(String serverUrl) async {
  try {
    /// Performs a get request to the dummy end of the server :
    /// Expected result : {"message" : "success"}
    http.Response _serverResponse = await http.get(Uri.parse("$serverUrl/test/dart"));

    Map<String, dynamic> _jsonResponse = convert.jsonDecode(_serverResponse.body);

    if (_jsonResponse.containsKey("status") && _jsonResponse['status'].toString().toLowerCase() == "true") {
      _serverRuntime["get-request-check"] = "TRUE";
      _serverRuntime["server-active"] = "TRUE";
    } else {
      _serverRuntime["get-request-check"] = "FALSE";
      throw new ErrorDescription("email-auth >> Server returned the following data :: $_jsonResponse");
    }

    return true;
  } catch (error) {
    if (kDebugMode) {
      if (error.runtimeType == FormatException || error.toString().contains("timed out")) {
        _serverRuntime["server-active"] = "FALSE";
        _serverRuntime["server-error"] = error.toString();
        print("Unable to access remote server. 😑");
      } else {
        print("--- Package Error ---");
        print(error);
        print("--- End Package Error ---");
      }
    }
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

/// Class EmailAuth
/// requires a auth.config.dart pacakge
/// should follow the variable conventions as follows :
/// var remoteServerConfig = {"server" : "serverUrl", "serverKey" : "Key generted from the email-auth-node package"}
/// You can pass "remoteServerConfig" to the emailAuth instance.config() and generate them.
class EmailAuth {
  // The server
  // late String _server = "";
  // late String _serverKey = "";
  // bool _validRemote = false;

  // The session name
  String sessionName;

  // Contructing the Class with the server and the session Name
  EmailAuth({required this.sessionName}) {
    print("email-auth >> Initialising Email-Auth server");
    _serverRuntime["sessionName"] = sessionName;
  }

  /// configuring the external server
  /// the Map should be of the pattern {"server" : "", "serverKey" : ""}
  Future<bool> config(Map<String, String> data) async {
    try {
      // Check the existence of the keys
      if (kDebugMode) {
        print(data);
      }

      if (data.containsKey('server') &&
          data.containsKey('serverKey') &&
          data['server'] != null &&
          data['server']!.length > 0 &&
          data['serverKey'] != null &&
          data['serverKey']!.length > 0) {
        if (data['server']![data['server']!.length - 1] == "/") {
          data['server'] = data['server']!.substring(0, data['server']!.length - 1);
        }
        _serverRuntime["server"] = data['server']!;
        _serverRuntime["serverKey"] = data['serverKey']!;

        /// Only proceed further if the server is valid as per the function _isValidServer
        if (await _isValidServer(data['server']!)) {
          _serverRuntime["validRemote"] = "true";

          print("email-auth >> The remote server configurations are valid");
          return true;
        } else {
          String errorMsg = "email-auth >> Remote server configuration is not valid," +
              "\t server configuration :\n" +
              "\t\t server URL : randomData\n" +
              "\t\t server KEY : randomKey\n\n" +
              "\t server validity (checks) :\n" +
              "\t\t GET REQUESTS  : FAIL\n" +
              "\t\t POST REQUESTS : FAIL\n\n" +
              "\t fallback server\n" +
              "\t\t NONE PROVIDED";

          throw new ErrorDescription("email-auth >> Error accessing the server \n $errorMsg");
        }

        // Fallback to handle missing keys in the configuration data
      } else {
        throw new ErrorDescription("email-auth >> Remote server configurations are not valid");
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
  Future<bool> sendOtp({required String recipientMail, int otpLength = 6}) async {
    try {
      if (!_isEmail(recipientMail)) {
        print("email-auth >> email ID provided is INVALID");
        return false;
      }

      /// Defaults to the test server (reverts) : if the remote server is provided
      if (_serverRuntime["validRemote"]!.toLowerCase() == "false" || _serverRuntime["server"]!.length <= 0) {
        print("email-auth >> Remote server is not available -- using test server --");
        print("email-auth >> ❗ Warning this is not reliable on production");
        print("email-auth >> Test servers are marked obselete, Kindly set up a production server");
        return false;
        // http.Response _response = await http.get(Uri.parse(
        //     // ignore: unnecessary_brace_in_string_interps
        //     "https://app-authenticator.herokuapp.com/dart/auth/${recipientMail}?CompanyName=${this.sessionName}"));

        // return _convertData(_response, recipientMail);
      } else if (_serverRuntime["validRemote"] != null && _serverRuntime["validRemote"]!.toLowerCase() == "true") {
        http.Response _response = await http.get(Uri.parse(
            // "${this._server}/dart/auth/$recipientMail?CompanyName=${this.sessionName}&key=${this._serverKey}&otpLength=$otpLength"));
            "${_serverRuntime["server"]}/dart/auth/$recipientMail?CompanyName=${_serverRuntime["sessionName"]}&key=${_serverRuntime["serverKey"]}&otpLength=$otpLength"));

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
      print("email-auth >> The OTP should be sent before performing validation");
      return false;
    }

    if (_finalEmail.trim() == recipientMail.trim() && _finalOTP.trim() == userOtp.trim()) {
      print("email-auth >> Validation success ✅");
      return true;
    }

    print("email-auth >> Validation failure ❌");
    return false;
  }
}
