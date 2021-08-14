/// This file contais a class that has the options to set the session name and the serverUrl
/// - session name : will be the company name
/// - serverUrl : (defaults : 'default') OR the valid server url link provided by the user generated using the node package :

import 'dart:async';
import 'dart:convert' as convert;
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

bool _isValidServer(String url) {
  String reg = r".*/dart/auth/";
  return RegExp(reg).hasMatch(url);
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

// class EmailAuth {
//   /// A class to handle the OTP operations
//   /// Assign your session Name / Company name here using the static method
//   static late String sessionName;

//   /// SERVER : defaults to default
//   static String serverUrl = 'default';

//   /// This functions returns a future of boolean stating if the OTP was sent.
//   static Future<bool> sendOtp({required String receiverMail}) async {
//     try {
//       /// Setting the final Email email for validation purposes
//       _finalEmail = receiverMail;

//       if (!_isEmail(receiverMail)) {
//         print("email ID is not valid");
//         return false;
//       }
//       print("Email ID is valid");
//       http.Response _response;

//       /// Constant ending for every url
//       String constantEnd =
//           "${receiverMail.toLowerCase()}?CompanyName=$sessionName";

//       if (serverUrl != 'default' && _isValidServer(serverUrl)) {
//         _response = await http.get(
//           Uri.parse(serverUrl + constantEnd),
//         );

//         /// Return the boolean data from the converted function
//         return convertData(_response, receiverMail);
//       } else if (serverUrl == 'default') {
//         /// This will use your API and contact with your server on heroku.
//         _response = await http.get(
//           Uri.parse(
//             "https://app-authenticator.herokuapp.com/dart/auth/" + constantEnd,
//           ),
//         );

//         /// Return the boolean data from the converted function
//         return convertData(_response, receiverMail);
//       }

//       /// Defaults false by default
//       print("--- The server URL is not valid ---");
//       return false;
//     } catch (error) {
//       print("--- This error is from the package ---");
//       print(error);
//       print("--- End package error message ---");
//       return false;
//     }
//   }

//   /// This functions returns a future of boolean stating if the user provided data is correct
//   static bool validate(
//       {required String receiverMail, required String userOTP}) {
//     if (_finalEmail.length > 0 && _finalOTP.length > 0) {
//       if (receiverMail.trim() == _finalEmail.trim() &&
//           userOTP.trim() == _finalOTP.trim()) {
//         print("Validation success the user can be validated");
//         return true;
//       } else {
//         print("Validation Falied");
//         return false;
//       }
//     }
//     print("Missing Data");
//     return false;
//   }
// }

/// Finds the location of the configuration file,
/// and returns the complete path of the file.
String findConfig(Directory rootDir) {
  // print(rootDir.path);
  if (!rootDir.path.contains("lib")) {
    print("File not found");
    return "";
  }
  List<FileSystemEntity> entries = rootDir.listSync(recursive: false).toList();
  for (var file in entries) {
    if (file is File && file.path.contains("auth.config")) {
      return (file.path);
    }
  }
  return findConfig(rootDir.parent);
}

class EmailAuth {
  // The server
  String server;
  // The session name
  String sessionName;

  late String _remoteServer;
  late String _remoteServerKey;

  // Contructing the Class with the server and the session Name
  EmailAuth({
    required this.server,
    required this.sessionName,
  }) {
    /// initializing the configuration
    _init();
  }

  /// Used to verify the presence of the server configurations
  _init() {
    if (this.server == 'config') {
      // find the path of the configuration file
      String filePath = findConfig(Directory.current);
      if (filePath != "") {
        print(filePath);
        String contents = new File(filePath).readAsStringSync();
        Map<String, String> serverData = convert.json.decode(contents);
        if (serverData.containsKey('server') &&
            _isValidServer(serverData['server']!)) {
          print("The configurations are perfect.");
          this._remoteServer = serverData['server']!;
          this._remoteServerKey = serverData['key']!;
        }
      } else {
        print("email-auth >> The config file is missing");
      }
    }
  }

  Future<bool> sendOtp({required String recipientMail}) async {
    try {
      if (!_isEmail(recipientMail)) {
        print("email-auth >> email ID is INVALID");
        return false;
      }
      if (this._remoteServer.isEmpty) {
        print(
            "email-auth >> Remote server is not available -- using test server --");
        http.Response _response = await http.get(Uri.parse(
            "https://app-authenticator.herokuapp.com/dart/auth/${recipientMail}?CompanyName=${this.sessionName}"));

        return convertData(_response, recipientMail);
      } else if (_isValidServer(this._remoteServer)) {
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
