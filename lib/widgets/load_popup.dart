import 'package:flutter/material.dart';

class LoadPopup extends StatelessWidget {
  const LoadPopup({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        content: const SizedBox(
          height: 150,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}