import 'package:email_auth/email_auth.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('check failing validation', () {
    expect(
        new EmailAuth(sessionName: "")
            .validateOtp(recipientMail: "sample", userOtp: "15252"),
        false);
  });
}
