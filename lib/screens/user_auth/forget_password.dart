import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

class ForgetPassword extends StatefulWidget {
  ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final TextEditingController _email = TextEditingController();

  _resetSubmit() async {
    var _resetData = {
      'email': _email.text.toString(),
    };

    final resetApi =
        Uri.parse('https://c24apidev.accelx.net/auth/users/reset_password/');

    try {
      var responseReset = await http.post(
        resetApi,
        body: json.encode(_resetData),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      print('Password reset: ${responseReset.statusCode}');
      if (responseReset.statusCode == 201) {
        return ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Password reset instruction has send to the given mail'),
          ),
        );
      } else {
        return ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Can not find any ID associate with the given mail'),
          ),
        );
      }
    } catch (error) {
      print('password reset error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Center(
                child: Text(
                  'Enter your registered email address',
                  style: TextStyle(
                    fontSize: 2.3.h,
                    letterSpacing: 0.5.w,
                  ),
                ),
              ),
              SizedBox(
                height: 3.h,
              ),
              TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null) {
                    return 'This field is required';
                  } else if (!value.contains('@')) {
                    return 'Please enter a valid email address';
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.mail),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  labelText: 'Email',
                  hintText: 'Enter registered email address',
                ),
              ),
              SizedBox(
                height: 3.h,
              ),
              ElevatedButton(
                onPressed: _resetSubmit,
                child: Text(
                  'Submit',
                  style: TextStyle(
                    fontSize: 2.h,
                  ),
                ),
                // style: ElevatedButton.styleFrom(
                //   primary: Colors.indigo,
                // ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
