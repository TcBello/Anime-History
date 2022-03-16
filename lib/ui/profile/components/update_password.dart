import 'package:anime_history/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdatePassword extends StatefulWidget {
  const UpdatePassword({ Key? key }) : super(key: key);

  @override
  _UpdatePasswordState createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();

  final double spacing = 20.0;
  
  bool obscureCurrentPassword = true;
  bool obscureNewPassword = true;
  bool obscureConfirmNewPassword = true;

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Password"),
        actions: [
          // APPLY BUTTON
          TextButton(
            child: Text("Apply", style: Theme.of(context).textTheme.headline6?.copyWith(color: Colors.white),),
            onPressed: () async {
              if(formKey.currentState!.validate()){
                var isSuccess = await user.updatePassword(currentPasswordController.text, newPasswordController.text);
                if(isSuccess) Navigator.pop(context);
              }
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.green)
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                SizedBox(height: spacing,),
                // CURRENT PASSWORD TEXT FIELD
                TextFormField(
                  controller: currentPasswordController,
                  obscureText: obscureCurrentPassword,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: "Current Password",
                      prefixIcon: const Icon(
                        Icons.lock,
                      ),
                      suffixIcon: IconButton(
                        icon: obscureCurrentPassword
                          ? const Icon(Icons.visibility_off)
                          : const Icon(Icons.visibility),
                        onPressed: () {
                          setState(() {
                            obscureCurrentPassword = !obscureCurrentPassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
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
                      : "Missing Field",
                ),
                SizedBox(height: spacing),
                // NEW PASSWORD TEXT FIELD
                TextFormField(
                  controller: newPasswordController,
                  obscureText: obscureNewPassword,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: "New Password",
                      prefixIcon: const Icon(
                        Icons.lock,
                      ),
                      suffixIcon: IconButton(
                        icon: obscureNewPassword
                          ? const Icon(Icons.visibility_off)
                          : const Icon(Icons.visibility),
                        onPressed: () {
                          obscureNewPassword = !obscureNewPassword;
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
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
                      : "Missing Field",
                ),
                SizedBox(height: spacing,),
                // CONFIRM NEW PASSWORD TEXT FIELD
                TextFormField(
                  controller: confirmNewPasswordController,
                  obscureText: obscureConfirmNewPassword,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: "Confirm New Password",
                      prefixIcon: const Icon(
                        Icons.lock,
                      ),
                      suffixIcon: IconButton(
                        icon: obscureConfirmNewPassword
                          ? const Icon(Icons.visibility_off)
                          : const Icon(Icons.visibility),
                        onPressed: () {
                          setState(() {
                            obscureConfirmNewPassword = !obscureConfirmNewPassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      errorStyle: TextStyle(color: Colors.redAccent[200], fontWeight: FontWeight.bold),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Colors.redAccent[200]!, width: 3)),
                    ),
                    validator: (value) => value!.isNotEmpty
                      ? newPasswordController.text == value
                        ? null
                        : "Password Don't Match"
                      : "Missing Field",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}