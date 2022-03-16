// ignore_for_file: sized_box_for_whitespace

import 'package:anime_history/constants.dart';
import 'package:anime_history/provider/user_provider.dart';
import 'package:anime_history/ui/sign_up/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool obscure = true;

  double spacing = 20;

  double imageSize = 150;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserProvider>();

    return Scaffold(
        body: SingleChildScrollView(
          child: SingleChildScrollView(
            child: Stack(
              children: [
                // BACKGROUND
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Image.asset(
                    kLoginBackgroundPath,
                    fit: BoxFit.cover,
                  ),
                ),
                // BACKGROUND OPACITY
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.black.withOpacity(0.5),
                ),
                // LOGIN AREA
                Center(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // APP LOGO
                          Container(
                            height: imageSize,
                            width: imageSize,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: const Image(
                                image: ResizeImage(AssetImage(kAppIconImagePath), width: 400, height: 400),
                              ),
                            )
                          ),
                          const SizedBox(height: 80),
                          // EMAIL TEXT FIELD
                          TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              labelText: "Email",
                              prefixIcon: const Icon(Icons.mail),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(color: Colors.white)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(color: Colors.white)),
                              errorStyle: TextStyle(color: Colors.redAccent[200], fontWeight: FontWeight.bold),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(color: Colors.redAccent[200]!, width: 3)),
                            ),
                            validator: (value) => value!.isNotEmpty
                              ? null
                              : "Missing Field",
                          ),
                          SizedBox(
                            height: spacing,
                          ),
                          // PASSWORD TEXT FIELD
                          TextFormField(
                            controller: passwordController,
                            obscureText: obscure,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              labelText: "Password",
                              prefixIcon: const Icon(
                                Icons.lock,
                              ),
                              suffixIcon: IconButton(
                                icon: obscure
                                  ? const Icon(Icons.visibility_off)
                                  : const Icon(Icons.visibility),
                                onPressed: () {
                                  setState(() {
                                    obscure = !obscure;
                                  });
                                },
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(color: Colors.white)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(color: Colors.white)),
                              errorStyle: TextStyle(color: Colors.redAccent[200], fontWeight: FontWeight.bold),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(color: Colors.redAccent[200]!, width: 3)),
                            ),
                            validator: (value) => value!.isNotEmpty
                              ? null
                              : "Missing Field",
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          // LOGIN BUTTON
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: TextButton(
                              child: const Text("LOGIN"),
                              onPressed: (){
                                if(formKey.currentState!.validate()) user.login(emailController.text, passwordController.text);
                              },
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.blue),
                                  foregroundColor:
                                      MaterialStateProperty.all(Colors.white),
                                  padding: MaterialStateProperty.all(
                                      const EdgeInsets.symmetric(vertical: 15)),
                                  textStyle: MaterialStateProperty.all(
                                      Theme.of(context)
                                          .textTheme
                                          .button
                                          ?.copyWith(fontSize: 16)),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30)))),
                            ),
                          ),
                          SizedBox(
                            height: spacing / 2,
                          ),
                          // SIGN UP BUTTON
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an Account?",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    ?.copyWith(color: Colors.white),
                              ),
                              TextButton(
                                onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const SignUp())),
                                child: const Text("SIGN UP"),
                                style: ButtonStyle(
                                    foregroundColor:
                                        MaterialStateProperty.all(Colors.white)),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
