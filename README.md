# Email verification for Flutter Apps using DART.

## Update : (Google turning off less secure apps / Switching to OAuth)🚀
https://github.com/saran-surya/email_auth/discussions/66#discussion-4027810

```diff
- Test servers will work fine, kindly use test servers for time being, Productions servers will recieve patch in the coming week
- Steps : 
-       1) Remove the variable to access remote server configuration and everything should be fine.
-       2) Current limits has been adjusted to 50 per session.
```

## 👀 Kindly add the repo to Watch list, to get latest updates regarding servers and packages.



<hr/>

## Key points :
  - This package allows developers to verify that the provided Email is valid and also an existing one,
  - It is confirmed by sending an OTP to the specified email ID and verify them.

## Features!
  - Has a test server by default, (has limitations of 30 mails : to match the other user needs for testing).
  - Easy setup of a custom server here : [Node version : email-auth-node](https://github.com/saran-surya/email_auth_node)
  - Detailed setup can be found here : [Detailed setup of email-auth production server](https://saran-surya.github.io/email-auth-node/)
  - Simple methods to send and verify the OTP, all you need as a mandatory parameter is the Email ID.

## Key changes:
  - No more static methods, All the methods are based on the class instance.
  - More reliable and understandable method names.
  - Change in parameters.
  - Session name is made mandatory.
  - Additional option to set the OTP length for production servers

## Steps
- ### Initialize the class
```dart
EmailAuth emailAuth =  new EmailAuth(sessionName: "Sample session");
```
- ### Pass in the remote server config if present
```dart
emailAuth.config(remoteServerConfiguration);

// remoteServerConfiguration : Signature
{
  "server": "server url",
  "serverKey": "serverKey"
}
```
- ### Sending an otp
    Have the method wrapped in a async funtion.
```dart
void sendOtp() async {
  bool result = await emailAuth.sendOtp(
      recipientMail: _emailcontroller.value.text, otpLength: 5
      );
  }
```
- ### Validating an otp
    Have the method wrapped in a funtion for better reusablity.
```dart
emailAuth.validateOtp(
        recipientMail: _emailcontroller.value.text,
        userOtp: _otpcontroller.value.text)
```


## Usage template example
```dart
import 'package:email_auth/email_auth.dart';
...
Inside your stateLess / Statefull widget class
  ...
  
  // Declare the object
  EmailAuth emailAuth;

  @override
  void initState() {
    super.initState();
    // Initialize the package
    emailAuth = new EmailAuth(
      sessionName: "Sample session",
    );

    /// Configuring the remote server
    emailAuth.config(remoteServerConfiguration);
  }

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  /// a Boolean function to verify if the Data provided is true
  bool verify() {
    print(emailAuth.validateOtp(
        recipientMail: _emailcontroller.value.text,
        userOtp: _otpcontroller.value.text));
  }

  /// a void funtion to send the OTP to the user
  /// Can also be converted into a Boolean function and render accordingly for providers
  void sendOtp() async {
    bool result = await emailAuth.sendOtp(
        recipientMail: _emailcontroller.value.text, otpLength: 5);
    if (result) {
      // using a void function because i am using a 
      // stateful widget and seting the state from here.
      setState(() {
        submitValid = true;
      });
    }
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

Property |   Type     | Description
-------- |------------| ---------------
EmailAuth|  Class | The parent Class|
EmailAuth.sessionName| String | The sessionName of the instance to be used |
EmailAuth.config| Boolean Function | Used to verify whether the remote server is valid|
EmailAuth.sendOtp| Boolean Function| Takes care of sending OTP to the mail id provided|
recipientMail | param of EmailAuth.sentOtp() method | email ID of the recipient
otpLength |  param of EmailAuth.sentOtp() method : Defaults to 6 | length of the otp
EmailAuth.validateOtp|Boolean Function|Takes care of verifying the OTP entered by the user|

## Notable issues / feature requests / Contributions
- [crankyvein - UI changes](https://github.com/saran-surya/email_auth/issues/7)
- [isarojdahal - OTP length feature](https://github.com/saran-surya/email_auth/issues/8)
- [arinagrawal05 - production server note](https://github.com/saran-surya/email_auth/issues/14)
- [GJJ2019 - support null safety](https://github.com/saran-surya/email_auth/issues/4)


## Privacy Policy 😸
We never share the email ID's we get to any service, nor do we use them for our purposes, we regularly clean up the sent mail section, and we never save any data on our servers, we work on the main motive to be **OPEN SOURCE** , If so you have any queries kindly mail me at the email ID provided Always happy to answer.

## ⭐ If you like the package, a star to the repo will mean a lot.
### Also feel free to fork the ***main*** branch and add some additional features, Will be eager to verify and add the updates.
# Thankyou ❤️
