import 'dart:convert';
import 'dart:io';

import 'package:consult_24/models/call_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class ProPicUpdateDelete extends StatefulWidget {
  const ProPicUpdateDelete({Key? key}) : super(key: key);

  @override
  State<ProPicUpdateDelete> createState() => _ProPicUpdateDeleteState();
}

class _ProPicUpdateDeleteState extends State<ProPicUpdateDelete> {
  var userImgId = 0;
  var userImg = '';
  File? imgLink;
  @override
  void didChangeDependencies() async {
    SharedPreferences successLogin = await SharedPreferences.getInstance();
    var userImgIdJson = successLogin.getInt('proPicId');
    var userImageId = json.decode(json.encode(userImgIdJson));

    var userImgJson = successLogin.getString('proPicLink');
    var userImgDecode = json.decode(json.encode(userImgJson));

    setState(() {
      userImgId = userImageId;
      userImg = userImgDecode;
      print(userImgId);
      print(userImg);
    });

    super.didChangeDependencies();
  }

  _deleteImg(BuildContext context) async {
    var imgDeletation;

    try {
      var deleteImg =
          await CallApi().deleteData('/auth_api/profile_picture/$userImgId/');

      setState(() {
        imgDeletation = deleteImg.statusCode;
      });

      print(deleteImg.statusCode);

      if (imgDeletation == 204) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Your image has been deleted successfully..!'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Something went wrong. Try again later..!'),
          ),
        );
      }

      if (imgDeletation == 204) {
        SharedPreferences successLogin = await SharedPreferences.getInstance();
        successLogin.remove('proPicId');
        successLogin.remove('proPicLink');
      }
    } catch (error) {
      print(error);
    }
  }

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(
        source: source,
        imageQuality: 50,
      );
      if (image == null) return;
      final imageTemporary = File(
        image.path,
      );
      setState(() {
        imgLink = imageTemporary;
      });
      // try {
      //   var fileName = image.path.split('/').last;
      //   FormData formData = FormData.fromMap({});
      // }
    } on PlatformException catch (e) {
      return ('Failed to pick image: $e');
    }
  }

  _updateImg(BuildContext context) async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacementNamed(
              context,
              '/profilePage',
            );
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(
              vertical: 0.5.h,
              horizontal: 2.w,
            ),
            color: Colors.white,
            padding: EdgeInsets.symmetric(
              vertical: 1.h,
              horizontal: 3.w,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 20.h,
                  width: 50.w,
                  margin: EdgeInsets.only(
                    top: 2.h,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.shadow,
                    ),
                    image: DecorationImage(
                      image: NetworkImage(
                        userImg != '' ? userImg : 'No image to preview',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (builder) => _imagePickingOption(),
                        );
                      },
                      child: Padding(
                        child: const Text('Update'),
                        padding: EdgeInsets.symmetric(
                          horizontal: 5.w,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _deleteAlert(context);
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: const Text('Delete'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _deleteAlert(BuildContext context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Expanded(
            child: AlertDialog(
              title: const Text('Cofirm Deletation ?'),
              content: Text(
                'Are you sure ? \nN:B: [ You can update profile picture as your wish. But if you delete that can causes some serious issues...! ]',
                style: TextStyle(
                  fontSize: 2.h,
                  color: Theme.of(context).colorScheme.error,
                  letterSpacing: 0.3.w,
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _deleteImg(context);
                  },
                  child: const Text('Confirm'),
                ),
              ],
            ),
          );
        });
  }

  Widget _imagePickingOption() {
    return Container(
      color: Colors.white,
      height: 20.h,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Pic Image From",
              style: TextStyle(
                fontSize: 2.h,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 2.h,
            ),
            ElevatedButton(
              onPressed: () => {
                pickImage(ImageSource.gallery),
                // if (imagePicker != null) print(imgLink),
              },
              child: const Text('Gallery'),
            ),
            ElevatedButton(
              onPressed: () => {
                pickImage(ImageSource.camera),
                print(imgLink),
              },
              child: const Text('Camera'),
            ),
          ],
        ),
      ),
    );
  }
}
