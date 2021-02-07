// import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:email_auth/email_auth.dart';

void main() {
  test('check failing validation', () {
    expect(EmailAuth.validate(recieverMail: "sample", userOTP: "15252"), false);
  });
}
