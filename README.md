# ** Currently on Maintanence, No worries the package will work fine, We are updating to match the user requests 😸🚀

# Email verification for Flutter Apps using DART.

##### Key points :
  - This package allows developers to verify that the provided Email is valid and also an existing one,
  - We confirmit by sending an OTP to the specified email ID and verify them.

## Features!
  - It has Email ID by default, just call the function and voila... 
  - **Verifying an email** again call a function and that's it.. 

## Next Plans
  - Making the availablity of custom Email Ids.
  - Supporting different formats.

## Usage
```dart
import 'package:email_auth/email_auth.dart';
...
Inside your stateLess / Statefull widget class
  ...
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  ///create a method to send the Emails
  void sendOtp()async{
    ///Accessing the EmailAuth class from the package
       EmailAuth.sessionName = "Sample";
    ///a boolean value will be returned if the OTP is sent successfully
    var data =
        await EmailAuth.sendOtp(receiverMail: _emailController.value.text);
    if(!data){
        ///have your error handling logic here, like a snackbar or popup widget
    }
  }
  ///create a bool method to validate if the OTP is true
  bool verify(){
    return(EmailAuth.validate(
        receiverMail: _emailController.value.text, //to make sure the email ID is not changed
        userOTP: _otpController.value.text)); //pass in the OTP typed in
    ///This will return you a bool, and you can proceed further after that, add a fail case and a success case (result will be true/false)
  }
  ...
   Widget build(BuildContext context) {
   /// have your controllers assigned to textFields or textFormFields
   ...
    body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _emailController,
            ),
            TextField(
              controller: _otpController,
            ),
          ],
        ),
      ),
      ...
```

## Reference

Property |   Type     | Desciption
-------- |------------| ---------------
EmailAuth |   `class`     | <sub>The main wrapper class for all the methods and variables</sub>
EmailAuth.sessionName|   `STATIC value`     | <sub>Call this method to set the CompanyName / Org Name => "sessionName"</sub>
EmailAuth.sendOtp(receiverMail : "") |   `boolean function`     | <sub>Takes the Email ID and sends OTP returns a boolean</sub>
EmailAuth.validate(receiverMail : "", userOTP: "")|   `boolean function`     | <sub>Verifies if the provided OTP and mail ID are correct and returns a boolean</sub>
receiverMail |   `String : method parameter`     | <sub>Takes in the user entered Email ID</sub>
userOTP |   `String : method parameter`     | <sub>Takes in the user entered OTP that was sent through mail</sub>

## Privacy Policy
We never share the email ID's we get to any service, nor do we use them for our purposes, we regularly clean up the sent mail section, and we never save any data on our servers, we work on the main motive to be **OPEN SOURCE** , If so you have any queries kindly mail me at the email ID provided Always happy to answer :)
# Thankyou ❤️
