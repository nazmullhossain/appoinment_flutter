import 'dart:async';

import 'package:consult_24/providers/update_information.dart';
import 'package:consult_24/reuse_similiar_code/widgets/camera_use.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../providers/local_storage.dart';

class ProfilePictureUpdate extends StatefulWidget {
  @override
  State<ProfilePictureUpdate> createState() => _ProfilePictureUpdateState();
}

class _ProfilePictureUpdateState extends State<ProfilePictureUpdate> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Provider.of<UpdateInformation>(context, listen: false)
        .getProviderImage(Provider.of<LocalData>(context, listen: false).userId)
        .then((value) {
      if (value.statusCode == 200) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: isLoading == true
              ? CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.secondary)
              : Container(
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                  child: Consumer<UpdateInformation>(
                    builder: (context, updateInfo, child) {
                      return CameraUse(
                        buttonName: 'Update',
                        serverImg: updateInfo.imageLink,
                      );
                    },
                  ),
                ),
        ),
      ),
    );
  }
}
