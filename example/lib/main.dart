import 'package:flutter/material.dart';
import 'package:email_auth/email_auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool submitValid = false;
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _otpcontroller = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  void verify() {
    print(EmailAuth.validate(
        recieverMail: _emailcontroller.value.text,
        userOTP: _otpcontroller.value.text));
  }

  void sendOtp() async {
    EmailAuth.sessionName = "Company Name";
    bool result =
        await EmailAuth.sendOtp(recieverMail: _emailcontroller.value.text);
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
                  : Container(
                      height: 1,
                    )
            ],
          ),
        )),
      ),
    );
  }
}
