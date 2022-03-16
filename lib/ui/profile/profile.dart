import 'package:anime_history/provider/user_provider.dart';
import 'package:anime_history/ui/profile/components/avatar_bottom_sheet.dart';
import 'package:anime_history/ui/profile/components/update_password.dart';
import 'package:anime_history/ui/profile/components/username_dialog.dart';
import 'package:anime_history/widgets/popup_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatelessWidget {
  const Profile({ Key? key }) : super(key: key);

  final double _spacing = 10.0;
  final double _buttonLeftSpacing = 20.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          // LOGOUT BUTTON
          Consumer<UserProvider>(
            builder: (context, user, child) {
              return TextButton.icon(
                icon: const Icon(Icons.logout, color: Colors.white,),
                label: Text("Log Out", style: Theme.of(context).textTheme.headline6?.copyWith(color: Colors.white),),
                onPressed: () => showDialog(context: context, builder: (context) => PopupDialog(
                  title: "Are You Sure You Want To Log Out?",
                  onDeny: () => Navigator.pop(context),
                  onAccept: (){
                    user.logout();
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }
                )),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red)
                ),
              );
            }
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Consumer<UserProvider>(
          builder: (context, user, child) {
            // ignore: sized_box_for_whitespace
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1,),
                  // AVATAR
                  Stack(
                    children: [
                      SizedBox(
                        height: 150,
                        width: 150,
                        child: CircleAvatar(
                          backgroundImage: user.avatar != null
                            ? NetworkImage(user.avatar!)
                            : null,
                          child: user.avatar == null
                            ? const Icon(Icons.person, size: 120, color: Colors.white,)
                            : null,
                          backgroundColor: user.avatar != null
                            ? Colors.white
                            : Colors.blue
                        )
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.grey,
                            shape:  BoxShape.circle
                          ),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            color: Colors.white,
                            icon: const Icon(Icons.camera_alt),
                            onPressed: (){
                              showModalBottomSheet(context: context, builder: (context) => const AvatarBottomSheet());
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: _spacing,),
                  // USERNAME
                  Text(user.username, style: Theme.of(context).textTheme.headline5,),
                  SizedBox(height: _spacing,),
                  // EMAIL
                  Text(user.email, style: Theme.of(context).textTheme.headline5,),
                  const SizedBox(height: 50,),
                  // UPDATE USERNAME BUTTON
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: _buttonLeftSpacing),
                      child: SizedBox(
                        height: 50,
                        width: 150,
                        child: TextButton(
                          child: const Text("UPDATE USERNAME"),
                          onPressed: (){
                            showDialog(context: context, builder: (context) => const UsernameDialog());
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.green),
                            foregroundColor: MaterialStateProperty.all(Colors.white)
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: _spacing,),
                  // UPDATE PASSWORD BUTTON
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: _buttonLeftSpacing),
                      child: SizedBox(
                        height: 50,
                        width: 150,
                        child: TextButton(
                          child: const Text("UPDATE PASSWORD"),
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const UpdatePassword())),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.orange),
                            foregroundColor: MaterialStateProperty.all(Colors.white)
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          }
        ),
      ),
    );
  }
}