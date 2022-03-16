// ignore_for_file: sized_box_for_whitespace

import 'package:anime_history/constants.dart';
import 'package:anime_history/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  const SignUp({ Key? key }) : super(key: key);

  static const double _spacing = 20;

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserProvider>();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // BACKGROUND
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Image.asset(kLoginBackgroundPath, fit: BoxFit.cover,),
            ),
            // BACKGROUND OPACTIY
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.black.withOpacity(0.5),
            ),
            // SIGN UP AREA
            Center(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width * 0.8,
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 80),
                      // APP LOGO
                      Container(
                        height: 150,
                        width: 150,
                        color: Colors.blue,
                      ),
                      const SizedBox(height: 50),
                      // USERNAME TEXT FIELD
                      TextFormField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: "Username",
                          prefixIcon: const Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Colors.white)
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Colors.white)
                          ),
                          errorStyle: TextStyle(color: Colors.redAccent[200], fontWeight: FontWeight.bold),
                          errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(color: Colors.redAccent[200]!, width: 3)),
                        ),
                        validator: (value) => value!.isNotEmpty
                          ? null
                          : "Missing Required Field",
                      ),
                      const SizedBox(height: SignUp._spacing,),
                      // EMAIL TEXT FIELD
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: "Email",
                          prefixIcon: const Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Colors.white)
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Colors.white)
                          ),
                          errorStyle: TextStyle(color: Colors.redAccent[200], fontWeight: FontWeight.bold),
                          errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(color: Colors.redAccent[200]!, width: 3)),
                        ),
                        validator: (value) => value!.isNotEmpty
                          ? null
                          : "Missing Required Field",
                      ),
                      const SizedBox(height: SignUp._spacing,),
                      // PASSWORD TEXT FIELD
                      TextFormField(
                        controller: passwordController,
                        obscureText: obscurePassword,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: "Password",
                          prefixIcon: const Icon(Icons.lock,),
                          suffixIcon: IconButton(
                            icon: obscurePassword
                              ? const Icon(Icons.visibility_off)
                              : const Icon(Icons.visibility),
                            onPressed: () {
                              setState(() {
                                obscurePassword = !obscurePassword;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Colors.white)
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Colors.white)
                          ),
                          errorStyle: TextStyle(color: Colors.redAccent[200], fontWeight: FontWeight.bold),
                          errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(color: Colors.redAccent[200]!, width: 3)),
                        ),
                        validator: (value) => value!.isNotEmpty
                          ? value.length < 5
                            ? "Minimum length is 6"
                            : null
                          : "Missing Required Field",
                      ),
                      const SizedBox(height: SignUp._spacing,),
                      // CONFIRM PASSWORD TEXT FIELD
                      TextFormField(
                        controller: confirmPasswordController,
                        obscureText: obscureConfirmPassword,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: "Confirm Password",
                          prefixIcon: const Icon(Icons.lock,),
                          suffixIcon: IconButton(
                            icon: obscureConfirmPassword
                              ? const Icon(Icons.visibility_off)
                              : const Icon(Icons.visibility),
                            onPressed: () {
                              setState(() {
                                obscureConfirmPassword = !obscureConfirmPassword;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Colors.white)
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Colors.white)
                          ),
                          errorStyle: TextStyle(color: Colors.redAccent[200], fontWeight: FontWeight.bold),
                          errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(color: Colors.redAccent[200]!, width: 3)),
                        ),
                        validator: (value) => passwordController.text == value!
                          ? null
                          : "Password does not match",
                      ),
                      const SizedBox(height: 50,),
                      // SIGN UP BUTTON
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: TextButton(
                          child: const Text("SIGN UP"),
                          onPressed: () async {
                            // VALIDATING THE FORM
                            if(formKey.currentState!.validate()){
                              var isSuccess = await user.signUp(usernameController.text, emailController.text, passwordController.text);
                              if(isSuccess) Navigator.pop(context);
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.blue),
                            foregroundColor: MaterialStateProperty.all(Colors.white),
                            padding: MaterialStateProperty.all( const EdgeInsets.symmetric(vertical: 15)),
                            textStyle: MaterialStateProperty.all(Theme.of(context).textTheme.button?.copyWith(fontSize: 16)),
                            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)
                            ))
                          ),
                        ),
                      ),
                      const SizedBox(height: SignUp._spacing / 2,),
                      // LOGIN BUTTON
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already have an Account?", style: Theme.of(context).textTheme.bodyText2?.copyWith(
                            color: Colors.white
                          ),),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("LOGIN"),
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all(Colors.white)
                            ),
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
      )
    );
  }
}