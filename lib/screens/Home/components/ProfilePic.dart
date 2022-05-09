import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bricolage_app/constants.dart';

class ProfilePic extends StatefulWidget {
  const ProfilePic({Key? key}) : super(key: key);

  @override
  _ProfilePicState createState() => _ProfilePicState();
}


class _ProfilePicState extends State<ProfilePic> {
  File? _image;
  String? networkImage;
  @override
  void initState() {
   getImage();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    final darkMode = Theme.of(context).brightness==Brightness.dark;
    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
           CircleAvatar(
            backgroundImage :_image != null?Image.file(_image!).image
                : networkImage!=null?
                  Image.network(networkImage!).image
                 :const AssetImage("assets/images/avatar.png")
          ),
          Positioned(
            right: -16,
            bottom: 0,
            child: SizedBox(
              height: 46,
              width: 46,
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: const BorderSide(color: Colors.white),
                  ),
                  primary: Colors.white,
                  backgroundColor: Colors.black38,
                ),
                onPressed: () {
                  pickImage();
                },
                child: const Icon(Icons.camera_alt),
              ),
            ),
          )
        ],
      ),
    );
  }

  void pickImage()async{
    final pickedImage= await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedImage!= null) {
        _image = File(pickedImage.path);
        uploadImage(_image!);
      }
    });

  }
  void uploadImage(File image) async{
   TaskSnapshot snap=await fireStorage.ref().child("ProfilePics").child(auth.currentUser!.uid).putFile(image);
  }
  void getImage() async{
    String? image = await fireStorage.ref().child("ProfilePics").child(auth.currentUser!.uid).getDownloadURL();
    setState(() {
      networkImage=image;
    });
  }
}