/// This file contais a class that has the options to set the session name and the serverUrl
/// - session name : will be the company name
/// - serverUrl : (defaults : 'default') OR the valid server url link provided by the user generated using the node package :

import 'dart:async';
import 'dart:convert' as convert;
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

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
    print(error);
    print("--- End Package Error ---");
    return false;
  }
}

/// This function will take care of converting the reponse data and verify the mail ID provided.
bool convertData(http.Response _response, String receiverMail) {
  try {
    Map<String, dynamic> _data = convert.jsonDecode(_response.body);
    if (_data["success"]) {
      _finalOTP = _data["OTP"].toString();
      print("OTP sent successfully !");
      return true;
    } else {
      print("OTP was not sent failure");
      return false;
    }
  } catch (error) {
    print("--- Package Error ---");
    print(error);
    print("--- End Package Error ---");
    return false;
  }
}

class EmailAuth {
  // The server
  late String server = "";
  late String serverKey = "";
  bool validRemote = false;

  // The session name
  String sessionName;

  // Path for the file

  // Contructing the Class with the server and the session Name
  EmailAuth({
    required this.sessionName,
  }) {
    print("Initialising");

    /// future patch
    // _init();
  }

  /// made for future patch
  // _init() {  }

  /// configuring the external server
  /// the Map should be of the pattern {"server" : "", "serverKey" : ""}
  void config(Map<String, String> data) async {
    try {
      // Check the existence of the keys
      // print(data);

      if (data.containsKey('server') && data.containsKey('serverKey')) {
        if (await _isValidServer(data['server']!)) {
          this.server = data['server']!;
          this.serverKey = data['serverKey']!;
          this.validRemote = true;
          print("email-auth >> The remote server configurations are valid");
        } else {
          throw new ErrorDescription(
              "email-auth >> The server is not a valid.\nemail-auth >> got \"${data['server']}\"");
        }
      } else {
        throw new ErrorDescription(
            "email-auth >> Server configurations are not valid");
      }
    } catch (error) {
      print("\n--- package Error ---\n");
      print(error);
      print("--- package Error ---");
    }
  }

  /// Takes care of sending the OTP to the server.
  Future<bool> sendOtp({required String recipientMail}) async {
    try {
      if (!_isEmail(recipientMail)) {
        print("email-auth >> email ID is INVALID");
        return false;
      }
      if (this.server.isEmpty) {
        print(
            "email-auth >> Remote server is not available -- using test server --");
        http.Response _response = await http.get(Uri.parse(
            "https://app-authenticator.herokuapp.com/dart/auth/${recipientMail}?CompanyName=${this.sessionName}"));

        return convertData(_response, recipientMail);
      } else if (validRemote) {
        print("remote server is valid");
        return true;
      }
      return false;
    } catch (error) {
      print("--- Package Error ---");
      print(error);
      print("--- End Package Error ---");
      return false;
    }
  }
}
