// built in package
import 'dart:async';

import 'package:consult_24/providers/auth_manage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sizer/sizer.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  String? username;
  bool _isObsecure = true;

  final GlobalKey<FormState> _formKey = GlobalKey();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final Map<String, String> _loginData = {
    "password": '',
    "email": '',
  };

// email validation
  String? emailValid(String? value) {
    if (value!.isEmpty) {
      return "Please insert your email address.";
    } else if (!value.contains('@')) {
      return 'Please insert a valid email address.';
    } else {
      return null;
    }
  }

  // password validation
  String? passwordValid(String? value) {
    if (value!.isEmpty) {
      return 'Please insert your password.';
    } else {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  // login details submit
  _submit() async {
    setState(() {
      _isLoading = true;
    });

    var _login = Provider.of<AuthManage>(context, listen: false);
    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      form.save();

      _login
          .login(
        email: _emailController.text,
        password: _passwordController.text,
      )
          .then((value) {
        if (value.statusCode == 200) {
          setState(() {
            _isLoading = false;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                duration: Duration(microseconds: 4000),
                content: Text('Login successful'),
              ),
            );
            Navigator.pushReplacementNamed(context, '/homeScreen');
          });
        } else {
          setState(() {
            _isLoading = false;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                duration: Duration(microseconds: 4000),
                content: Text('Invalid email or password. Please try again'),
              ),
            );
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    // final textSize = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                top: height * 0.15,
                left: 7.w,
                right: 7.w,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: height * .2,
                      child: const Image(
                        image: AssetImage('assets/images/login-screen-2.png'),
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.headline3,
                        children: [
                          TextSpan(
                            text: 'You are',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          TextSpan(
                            text: ' protected',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 2.5.h,
                    ),
                    TextFormField(
                      autofocus: false,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
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
                      controller: _emailController,
                      validator: (value) {
                        if (value == null) {
                          return 'This field is required';
                        } else if (!value.contains('@')) {
                          return 'Please enter a valid email address';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) {
                        _loginData['email'] = value.toString();
                      },
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
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
                      obscureText: _isObsecure,
                      controller: _passwordController,
                      validator: passwordValid,
                      onSaved: (value) {
                        _loginData['password'] = value.toString();
                      },
                    ),
                    SizedBox(
                      height: height * 0.020,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      child: Center(
                        child: _isLoading == true
                            ? Center(
                                child: CircularProgressIndicator(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              )
                            : Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      right: width * 0.005,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pushNamed('/forgetPassword');
                                          },
                                          child: Text(
                                            'Forgot password?',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6,
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: _submit,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: width * 0.007,
                                            ),
                                            child: Text(
                                              'Login',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1,
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.blueGrey,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * 0.010,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: width <= 450
                                        ? Column(
                                            children: [
                                              Text(
                                                'Don\'t have an account yet? ',
                                                softWrap: true,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline5,
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pushNamed(
                                                      context, '/signupScreen');
                                                },
                                                child: Text(
                                                  'create one',
                                                  softWrap: true,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline6,
                                                ),
                                              ),
                                            ],
                                          )
                                        : Row(
                                            children: [
                                              Text(
                                                'Don\'t have an account yet? ',
                                                softWrap: true,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline5,
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pushNamed(
                                                      context, '/signupScreen');
                                                },
                                                child: Text(
                                                  'create one',
                                                  softWrap: true,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline6,
                                                ),
                                              ),
                                            ],
                                          ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
