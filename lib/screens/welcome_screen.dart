import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  //  navigateTo() {

  //  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textSize = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: width * 1,
          height: height * 1,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
          child: Column(
            children: [
              SizedBox(
                height: height * 0.09,
              ),
              SizedBox(
                height: height * 0.3,
                width: width * 1,
                child: const Image(
                  image: AssetImage(
                      'assets/images/share-knowledge-earn-money.jpg'),
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(
                height: height * 0.20,
                width: width * 0.8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.headline2,
                        children: [
                          TextSpan(
                            text: 'Consult',
                            style: Theme.of(context).textTheme.headline1,
                          ),
                          TextSpan(
                            text: ' 24',
                            style: Theme.of(context).textTheme.headline2,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: width * 0.070,
                      ),
                      child: Text(
                        'Share your knowledge,\nHelp others, Earn money.',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.015,
              ),
              SizedBox(
                height: height * 0.2,
                child: Column(
                  children: [
                    SizedBox(
                      height: height * 0.1,
                      width: width * 90,
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: width * 0.080),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'Is this your first visit ?',
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                SharedPreferences successLogin =
                                    await SharedPreferences.getInstance();
                                successLogin.remove('token');
                                Navigator.pushReplacementNamed(
                                  context,
                                  '/homeScreen',
                                );
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: height * 0.005,
                                ),
                                child: Text(
                                  'Take a look',
                                  softWrap: true,
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.1,
                      width: width * 90,
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: width * 0.080),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'Already have an account ?',
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                  context,
                                  '/loginScreen',
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                primary:
                                    Theme.of(context).colorScheme.secondary,
                              ),
                              child: Text(
                                'Login',
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
