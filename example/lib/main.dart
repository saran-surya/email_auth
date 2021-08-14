import 'package:email_auth/email_auth.dart';
import 'package:flutter/material.dart';

/// Importing the configuration file to pass them to the EmailAuth instance
/// You can have a custom path and a variable name,
/// but the Map should be in the pattern {server : "", serverKey : ""}
import 'package:email_auth_example/auth.config.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  /// The boolean to handle the dynamic operations
  bool submitValid = false;

  /// Text editing controllers to get the value from text fields
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _otpcontroller = TextEditingController();

  EmailAuth emailAuth;

  @override
  void initState() {
    super.initState();

    emailAuth = new EmailAuth(
      sessionName: "Sample session",
    );
    // emailAuth.config(remoteServerConfiguration);

    /// Setting the session name or the Company name
    // EmailAuth.sessionName = "Company Name";

    /// Set your custom server URL
    // EmailAuth.serverUrl = "server URL";
  }

  /// a void function to verify if the Data provided is true
  void verify() {
    print("Inside validate");
    // print(EmailAuth.validate(
    //     receiverMail: _emailcontroller.value.text,
    //     userOTP: _otpcontroller.value.text));
  }

  /// a void funtion to send the OTP to the user
  void sendOtp() async {
    bool result =
        await emailAuth.sendOtp(recipientMail: _emailcontroller.value.text);
    if (result) {
      setState(() {
        submitValid = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Email Auth sample'),
        ),
        body: Center(
            child: Center(
          child: Column(
            children: <Widget>[
              TextField(
                controller: _emailcontroller,
              ),
              Card(
                margin: EdgeInsets.only(top: 20),
                elevation: 6,
                child: Container(
                  height: 50,
                  width: 200,
                  color: Colors.green[400],
                  child: GestureDetector(
                    onTap: sendOtp,
                    child: Center(
                      child: Text(
                        "Request OTP",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              /// A dynamically rendering text field
              (submitValid)
                  ? TextField(
                      controller: _otpcontroller,
                    )
                  : Container(height: 1),
              (submitValid)
                  ? Container(
                      margin: EdgeInsets.only(top: 20),
                      height: 50,
                      width: 200,
                      color: Colors.green[400],
                      child: GestureDetector(
                        onTap: verify,
                        child: Center(
                          child: Text(
                            "Verify",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    )
                  : SizedBox(height: 1)
            ],
          ),
        )),
      ),
    );
  }
}
