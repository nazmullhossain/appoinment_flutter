import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

class CameraUse extends StatefulWidget {
  CameraUse({
    this.imgLink,
    this.imageType,
    @required this.buttonName,
    this.serverImg,
  });

  File? imgLink;
  String? serverImg;

  String? buttonName;
  Image? imageType;

  @override
  State<CameraUse> createState() => _CameraUseState();
}

class _CameraUseState extends State<CameraUse> {
  bool isClicked = false;

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
        widget.imgLink = imageTemporary;
      });

      // try {
      //   var fileName = image.path.split('/').last;
      //   FormData formData = FormData.fromMap({});
      // }
    } on PlatformException catch (e) {
      return ('Failed to pick image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.end,
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 16.h,
          width: 28.w,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: const Color.fromARGB(255, 225, 225, 225),
            ),
          ),
          child: widget.imgLink == null && widget.serverImg == null
              ? Center(
                  child: Text(
                    'No prieview available',
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      letterSpacing: 0.03.w,
                    ),
                  ),
                )
              : widget.imgLink != null && widget.serverImg == null
                  ? Image.file(
                      widget.imgLink!,
                      fit: BoxFit.fitWidth,
                    )
                  : widget.serverImg != null && widget.imgLink == null
                      ? Image.network(
                          widget.serverImg.toString(),
                        )
                      : Image.file(
                          widget.imgLink!,
                          fit: BoxFit.fitWidth,
                        ),
        ),
        SizedBox(
          width: 30.w,
          child: Container(
            margin: EdgeInsets.only(
              top: 1.h,
            ),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                // color: isClicked == false
                //     ? Colors.grey[400]
                //     : Theme.of(context).colorScheme.primary,
                color: Colors.grey),
            child: InkWell(
              child: Text(
                widget.buttonName.toString(),
                style: TextStyle(
                  color: Colors.black,
                  letterSpacing: 0.03.w,
                ),
                textAlign: TextAlign.center,
              ),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: ((builder) => _imagePickingOption()),
                );
              },
              // style: ElevatedButton.styleFrom(
              //     primary: const Color.fromARGB(
              //         255, 241, 237, 237),),
            ),
          ),
        ),
      ],
    );
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
                debugPrint('${widget.imgLink}'),
              },
              child: const Text('Camera'),
            ),
          ],
        ),
      ),
    );
  }
}



// serverImg != null && imgLink == null
//                       ? Image.network(
//                           serverImg.toString(),
//                         )
//                       : serverImg != null && imgLink != null
//                           ? Image.file(
//                               imgLink!,
//                               fit: BoxFit.fitWidth,
//                             )
//                           : Center(
//                               child: Text(
//                                 'No prieview available',
//                                 softWrap: true,
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                   letterSpacing: 0.03.w,
//                                 ),
//                               ),
//                             ),
