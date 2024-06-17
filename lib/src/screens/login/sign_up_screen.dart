import 'package:heathbridge_lao/package.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController telController = TextEditingController();
  String? gender;
  bool isCheckedTermsOfService = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Back',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Sign up',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: firstnameController,
                decoration: InputDecoration(
                  hintText: 'First Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: lastnameController,
                decoration: InputDecoration(
                  hintText: 'Last Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButton<String>(
                      underline: const SizedBox(),
                      value: '+856',
                      items: [
                        DropdownMenuItem(
                          value: '+856',
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/images/lao_flag.png',
                                width: 24,
                              ),
                              const SizedBox(width: 5),
                              const Text('+856'),
                            ],
                          ),
                        ),
                      ],
                      onChanged: (String? newValue) {},
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: telController,
                      decoration: InputDecoration(
                        hintText: '205XXXXXXX',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Gender',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Male',
                    child: Text('Male'),
                  ),
                  DropdownMenuItem(
                    value: 'Female',
                    child: Text('Female'),
                  ),
                  DropdownMenuItem(
                    value: 'Other',
                    child: Text('Other'),
                  ),
                ],
                onChanged: (String? value) {
                  setState(() {
                    gender = value;
                  });
                },
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Checkbox(
                    value: isCheckedTermsOfService,
                    onChanged: (bool? value) {
                      setState(() {
                        isCheckedTermsOfService = value ?? false;
                      });
                    },
                  ),
                  Flexible(
                    child: RichText(
                      text: TextSpan(
                        text: 'By signing up, you agree to the ',
                        style: const TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                            text: 'Terms of service',
                            style: const TextStyle(
                              color: ConstantColor.colorMain,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // Handle Terms of service link tap
                              },
                          ),
                          const TextSpan(
                            text: ' and ',
                            style: TextStyle(color: Colors.black),
                          ),
                          TextSpan(
                            text: 'Privacy policy',
                            style: const TextStyle(
                              color: ConstantColor.colorMain,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // Handle Privacy policy link tap
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final firstname = firstnameController.text;
                  final lastname = lastnameController.text;
                  final email = emailController.text;
                  final tel = telController.text;
                  if (firstname.isNotEmpty &&
                      lastname.isNotEmpty &&
                      tel.isNotEmpty &&
                      isCheckedTermsOfService) {
                    print('Name: $firstname');
                    print('Email: $email');
                    print('tel: $tel');
                    print('Gender: $gender');
                    print('Terms Accepted: $isCheckedTermsOfService');

                    context
                        .push('/setpassword/$firstname/$lastname/$email/$tel/$gender');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      ConstantColor.colorMain, // Use your constant color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Expanded(child: Divider(thickness: 1)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text('or'),
                  ),
                  Expanded(child: Divider(thickness: 1)),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: IconButton(
                      icon: SvgPicture.asset("assets/icons/gmail-icon.svg"),
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: IconButton(
                      icon: SvgPicture.asset("assets/icons/facebook-icon.svg"),
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: IconButton(
                      icon: SvgPicture.asset("assets/icons/apple-icon.svg"),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account?",
                  ),
                  TextButton(
                    onPressed: () {
                      context.push("/signin");
                    },
                    child: const Text(
                      'Sign in',
                      style: TextStyle(
                          color: ConstantColor.colorMain,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
