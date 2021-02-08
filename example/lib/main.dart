import 'package:email_auth/email_auth.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ///the boolean to handle the dynamic operations
  bool submitValid = false;

  ///testediting controllers to get the value from text fields
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _otpcontroller = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  ///a void function to verify if the Data provided is true
  void verify() {
    print(EmailAuth.validate(
        receiverMail: _emailcontroller.value.text,
        userOTP: _otpcontroller.value.text));
  }

  ///a void funtion to send the OTP to the user
  void sendOtp() async {
    EmailAuth.sessionName = "Company Name";
    bool result =
        await EmailAuth.sendOtp(receiverMail: _emailcontroller.value.text);
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

              ///A dynamically rendering text field
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
