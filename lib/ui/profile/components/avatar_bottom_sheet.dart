import 'package:anime_history/provider/user_provider.dart';
import 'package:anime_history/utils.dart';
import 'package:anime_history/widgets/load_popup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AvatarBottomSheet extends StatelessWidget {
  const AvatarBottomSheet({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserProvider>();

    return Container(
      height: 120,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: Colors.white
      ),
      child: Column(
        children: [
          // CHOOSE FROM GALLERY
          ListTile(
            leading: const Icon(Icons.photo, color: Colors.black,),
            title: const Text("Choose from gallery"),
            onTap: () async {
              showDialog(context: context, builder: (context) => const LoadPopup());
              await user.uploadPhotoFromGallery();
              Navigator.pop(context);
              Navigator.pop(context);
            }
          ),
          // TAKE A PHOTO
          ListTile(
            leading: const Icon(Icons.camera_alt, color: Colors.black,),
            title: const Text("Take a photo"),
            onTap: () async {
              showLoad(context);
              await user.uploadPhotoFromCamera();
              Navigator.pop(context);
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}