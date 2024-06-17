

import 'package:heathbridge_lao/package.dart';

class OtpScreen extends StatefulWidget {
  final String verificationId;
  const OtpScreen({
    super.key,
    required this.verificationId,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Verification",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 70),
            const Center(
              child: Text("OTP Verification",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500)),
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                controller: _otpController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    labelText: "Phone OTP"),
              ),
            ),
            const SizedBox(height: 16),
            InkWell(
                onTap: () async {
                  PhoneAuthCredential credential = PhoneAuthProvider.credential(
                      verificationId: widget.verificationId,
                      smsCode: _otpController.text);
                  print(_otpController.text);
                  await auth.signInWithCredential(credential);
                  context.go("/");
                  var user = context.read<UserProvider>().userModel;
                  context.read<UserProvider>().addUserHasura(user);
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.blue,
                  ),
                  child: const Text("Verify",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                )),
          ],
        ),
      ),
    );
  }
}
