import './lib/email_auth.dart';

void main() {
  EmailAuth.sessionName = "Sample";
  EmailAuth.sendOtp(recieverMail: "saransurya113@gmail.com");
}
