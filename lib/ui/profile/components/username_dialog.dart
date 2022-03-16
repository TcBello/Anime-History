import 'package:anime_history/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UsernameDialog extends StatefulWidget {
  const UsernameDialog({
    Key? key,
  }) : super(key: key);

  @override
  State<UsernameDialog> createState() => _UsernameDialogState();
}

class _UsernameDialogState extends State<UsernameDialog> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserProvider>();

    return AlertDialog(
      title: const Text("Update Username"),
      content: Form(
        key: formKey,
        // USERNAME TEXT FIELD
        child: TextFormField(
          controller: usernameController,
          decoration: const InputDecoration(
            hintText: "Username"
          ),
          validator: (value) => value!.isNotEmpty
            ? null
            : "Missing Field"
        ),
      ),
      actions: [
        // CANCEL BUTTON
        TextButton(
          child: const Text("CANCEL"),
          onPressed: () => Navigator.pop(context),
        ),
        // APPLY BUTTON
        TextButton(
          child: const Text("APPLY"),
          onPressed: () async {
            if(formKey.currentState!.validate()){
              var isSuccess = await user.updateUsername(usernameController.text);
              if(isSuccess) Navigator.pop(context);
            }
          },
        )
      ],
    );
  }
}