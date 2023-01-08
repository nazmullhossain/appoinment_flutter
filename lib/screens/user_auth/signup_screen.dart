import 'dart:async';

import 'package:consult_24/providers/auth_manage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:sizer/sizer.dart';

class SignupScreen extends StatefulWidget {
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  String? roleValue;
  bool _isObsecure = true;
  bool _isConfirmPassObs = true;

  bool _isLoading = false;

  String? videoToken;
  int? id;

  final GlobalKey<FormState> _formKey = GlobalKey();

  final TextEditingController _emailController = TextEditingController();
  // final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  // error handling of email
  String? emailValid(String? value) {
    final emailRegEx = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (value!.isEmpty) {
      return 'Please insert an email address.';
    } else if (!emailRegEx.hasMatch(value)) {
      return 'Please insert a valid email address.';
    } else {
      return null;
    }
  }

  // error handling of username
  String? usernameValid(String? value) {
    if (value!.isEmpty) {
      return 'Please insert a username';
    } else if (value.length < 4) {
      return 'Username must be greater than 4 character.';
    } else {
      return null;
    }
  }

  // password validation
  String? passwordValid(String? value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';

    RegExp regExp = RegExp(pattern);

    if (value!.isEmpty) {
      return 'Please enter a password';
    } else if (!regExp.hasMatch(value)) {
      return 'Your password must contain Uppercase, Lowercase, Numeric, Special character and must be at least 8 characters.';
    } else if (value.toLowerCase().contains('password')) {
      return 'You cannot use a common password';
    } else {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  // complete signup proccess
  _submit() async {
    _isLoading = true;

    var _signup = Provider.of<AuthManage>(context, listen: false);

    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      form.save();

      _signup.signUp(
        userName: _emailController.text.toString(),
        roleId: roleValue.toString(),
        email: _emailController.text.toString(),
        password: _passwordController.text.toString(),
        rePassword: _confirmPassController.text.toString(),
      );

      Timer(const Duration(milliseconds: 3000), () {
        if (_signup.tokenStoreStatus == 201) {
          setState(() {
            _isLoading = false;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Sign up successfull. Please check your mail.'),
              ),
            );
          });
        } else {
          setState(() {
            _isLoading = false;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Registration failed.'),
              ),
            );
          });
        }
      });
    } else {
      _isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Signup screen widgets');
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    // final textSize = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                top: height * 0.12,
                left: 7.w,
                right: 7.w,
              ),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child:
                      Consumer<AuthManage>(builder: (context, _signup, child) {
                    return Column(
                      children: [
                        Container(
                          height: height * 0.2,
                          width: width * .85,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/signup.png'),
                            ),
                          ),
                        ),
                        Text(
                          'Welcome to',
                          style: TextStyle(
                            fontSize: 3.h,
                            color: Colors.grey[800],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 3.7.h,
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                            children: [
                              const TextSpan(text: 'Consult'),
                              TextSpan(
                                text: '24',
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Text(
                          'Your value is always high to us',
                          softWrap: true,
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        //  email field
                        TextFormField(
                          autofocus: false,
                          controller: _emailController,
                          validator: emailValid,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.mail),
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            labelText: 'Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                5,
                              ),
                            ),
                          ),
                          textAlignVertical: TextAlignVertical.center,
                        ),
                        SizedBox(
                          height: 1.h,
                        ),

                        TextFormField(
                          autofocus: false,
                          controller: _passwordController,
                          validator: passwordValid,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isObsecure = !_isObsecure;
                                });
                              },
                              icon: Icon(
                                _isObsecure
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            labelText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                5,
                              ),
                            ),
                          ),
                          obscureText: _isObsecure ? true : false,
                          textAlignVertical: TextAlignVertical.center,
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        // retype password
                        TextFormField(
                          autofocus: false,
                          controller: _confirmPassController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'This field can not be empty.';
                            } else if (value != _passwordController.text) {
                              return 'Password doesn\'t match';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isConfirmPassObs = !_isConfirmPassObs;
                                });
                              },
                              icon: Icon(
                                _isConfirmPassObs
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                            filled: true,
                            labelText: 'Confirm password',
                            prefixIcon: const Icon(Icons.lock),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                5,
                              ),
                            ),
                          ),
                          obscureText: _isConfirmPassObs ? true : false,
                          textAlignVertical: TextAlignVertical.center,
                        ),
                        SizedBox(
                          height: 2.5.h,
                        ),
                        _isLoading == true
                            ? CircularProgressIndicator(
                                color: Theme.of(context).colorScheme.secondary)
                            : Center(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 1.w,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                            ),
                                            onPressed: (() {
                                              setState(() {
                                                roleValue = '3';
                                                _submit();
                                              });
                                            }),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 5.w,
                                                vertical: 1.h,
                                              ),
                                              child: Text(
                                                'Join as a\n Provider',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .caption,
                                              ),
                                            ),
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                roleValue = '2';
                                                _submit();
                                              });
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: width * 0.007,
                                                vertical: height * 0.005,
                                              ),
                                              child: Text(
                                                'Join as a\nCustomer',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .caption,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * 0.030,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(height * 0.020),
                                      child: width <= 400
                                          ? Column(
                                              children: [
                                                Text(
                                                  'Already have an account?',
                                                  softWrap: true,
                                                  style: TextStyle(
                                                    fontFamily:
                                                        GoogleFonts.poppins()
                                                            .fontFamily,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                    fontSize: 1.2.h,
                                                    decoration: TextDecoration
                                                        .underline,
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pushNamed(context,
                                                        '/loginScreen');
                                                  },
                                                  child: Text(
                                                    'Login',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          GoogleFonts.poppins()
                                                              .fontFamily,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .secondary,
                                                      fontSize: 1.h,
                                                      decoration: TextDecoration
                                                          .underline,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Already have an account?',
                                                  softWrap: true,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText2,
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pushNamed(context,
                                                        '/loginScreen');
                                                  },
                                                  child: Text(
                                                    'Login',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          GoogleFonts.poppins()
                                                              .fontFamily,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .secondary,
                                                      fontSize: 1.8.h,
                                                      decoration: TextDecoration
                                                          .underline,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
