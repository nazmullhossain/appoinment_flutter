// @dart=2.9

// built in flutter packages

import 'dart:io';

import 'package:consult_24/providers/appointment.dart';
import 'package:consult_24/providers/local_storage.dart';
import 'package:consult_24/providers/provider_service.dart';
import 'package:consult_24/providers/search.dart';
import 'package:consult_24/providers/category_subcategory.dart';
import 'package:consult_24/providers/update_information.dart';
import 'package:consult_24/providers/user_bank_details.dart';
import 'package:consult_24/providers/user_profile_picture.dart';
import 'package:consult_24/screens/browse_by_categories.dart';
import 'package:consult_24/screens/browse_by_sub_category.dart';
import 'package:consult_24/screens/service/appointment_schedule.dart';
import 'package:consult_24/bot_nav_components/more/payment_method/provider_payment_info.dart';
import 'package:consult_24/screens/update_info/address_update.dart';
import 'package:consult_24/screens/update_info/update_bank_info.dart';
import 'package:consult_24/screens/update_info/profile_picture_update.dart';

import '../providers/auth_manage.dart';
import '../providers/pref_user.dart';
import '../providers/search_provider.dart';
import '../screens/searching/search_details_screen.dart';
import '../screens/searching/search_result_screen.dart';
import '../screens/user_auth/forget_password.dart';
import '../screens/user_details/provider_details_screen.dart';
import '../bot_nav_components/explore/categories/see_all.dart';
import '../bot_nav_components/more/for_provider/create_services.dart';
import '../bot_nav_components/profile_picture/update_profile_picture.dart';
import '../bot_nav_components/update_profile/provider_personal_information.dart';
import '../screens/providers_list_screen.dart';

import '../bot_nav_components/more/payment_method/customer_payment_method.dart';

import '../pages/more_page.dart';
// import 'package:to_resolve/screens/provider_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

// providers files
import './models/routes.dart';

// other files like screens
import './screens/home_screen.dart';
import './screens/user_auth/login_screen.dart';
import './screens/user_auth/signup_screen.dart';
import './screens/user_details/customer_profile_details.dart';
import 'screens/complete_pofile_screen.dart';
import './bot_nav_components/more/about_us.dart';
import './bot_nav_components/more/become_a_member.dart';
import './bot_nav_components/more/contact_us.dart';

import './bot_nav_components/more/privacy_policy.dart';
import './bot_nav_components/more/terms_and_condition.dart';
import 'bot_nav_components/more/update_user_data.dart';
import 'screens/welcome_screen.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  // This widget is the root of your application.

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final height = MediaQuery.of(context).size.height;
    // final width = MediaQuery.of(context).size.width;
    // final textSize = MediaQuery.of(context).textScaleFactor;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: SearchProvider(),
        ),
        ChangeNotifierProvider.value(
          value: PrefUser(),
        ),
        ChangeNotifierProvider.value(
          value: AuthManage(),
        ),
        ChangeNotifierProvider.value(
          value: SearchHelper(),
        ),
        ChangeNotifierProvider.value(
          value: LocalData(),
        ),
        ChangeNotifierProvider.value(
          value: ProviderProfileDetails(),
        ),
        ChangeNotifierProvider.value(
          value: CategorySubCategory(),
        ),
        ChangeNotifierProvider.value(
          value: ProfilePicture(),
        ),
        ChangeNotifierProvider.value(
          value: Appointment(),
        ),
        ChangeNotifierProvider.value(
          value: UpdateInformation(),
        ),
        ChangeNotifierProvider.value(
          value: UserBankDetails(),
        ),
      ],
      child: MediaQuery(
        data: const MediaQueryData(
          alwaysUse24HourFormat: true,
        ),
        child: Sizer(
          builder: (context, orientation, deviceType) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Consult24',

              theme: ThemeData(
                primaryColor: const Color.fromARGB(255, 245, 245, 245),
                // set color
                colorScheme: ColorScheme.fromSwatch().copyWith(
                  secondary: const Color(0xFFedc001),
                  shadow: const Color.fromARGB(255, 0, 16, 3),
                  error: Colors.red[600],
                  primary: const Color(0xFF005a5b),
                  // primary: Color(0xFF30EDED),
                  brightness: Brightness.light,
                  outline: const Color.fromARGB(255, 141, 141, 141),
                  background: Colors.grey[100],
                ),

                iconTheme: IconThemeData(
                  color: const Color(0xFFedc001),
                  size: 4.5.h,
                ),

                // define the default font family
                // fontFamily: GoogleFonts.poppins().fontFamily,
                textTheme: TextTheme(
                  headline1: GoogleFonts.roboto(
                    fontSize: 6.h,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1.sp,
                    color: const Color(0xFF005a5b),
                  ),
                  headline2: GoogleFonts.roboto(
                    fontSize: 5.h,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.5.sp,
                    color: const Color(0xFFedc001),
                  ),
                  headline3: GoogleFonts.roboto(
                    fontSize: 4.5.h,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.25.sp,
                  ),
                  headline4: GoogleFonts.roboto(
                    fontSize: 3.5.h,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.15.sp,
                  ),
                  headline5: GoogleFonts.roboto(
                    fontSize: 2.8.h,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.15.sp,
                    color: const Color(0xFF005a5b),
                  ),
                  headline6: GoogleFonts.roboto(
                    fontSize: 2.2.h,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.15.sp,
                    color: const Color(0xFF525252),
                  ),
                  bodyText1: GoogleFonts.roboto(
                    fontSize: 2.2.h,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.875.sp,
                    color: const Color.fromARGB(255, 207, 207, 207),
                  ),
                  bodyText2: GoogleFonts.roboto(
                    fontSize: 2.2.h,
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.875.sp,
                    color: Colors.grey[800],
                  ),
                  caption: GoogleFonts.roboto(
                    fontSize: 2.1.h,
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.875.sp,
                    color: Colors.white,
                  ),
                ),
              ),
              // home: BrowseByCategory(),
              home: const WelcomeScreen(),
              routes: {
                MyRoutes.signupScreen: (context) => SignupScreen(),
                MyRoutes.homeScreen: (context) => HomeScreen(),
                MyRoutes.loginScreen: (context) => LoginScreen(),
                MyRoutes.customerDetails: (context) => CustomerDetailsScreen(),
                MyRoutes.providerDetails: (context) => ProviderDetailsScreen(),
                MyRoutes.completeProfileScreen: (context) =>
                    CompleteProfileScreen(),
                MyRoutes.becomeMember: (context) => BecomeMember(),
                MyRoutes.contactUs: (context) => ContactUs(),
                MyRoutes.aboutUs: (context) => const AboutUs(),
                MyRoutes.privacyPolicy: (context) => const PrivacyPolicy(),
                MyRoutes.termsCondition: (context) => const TermsCondition(),
                MyRoutes.welcomeScreen: (context) => const WelcomeScreen(),
                MyRoutes.providersList: (context) => ProvidersList(),
                MyRoutes.customerPaymentSetup: (context) =>
                    CustomerPaymentMethod(),
                MyRoutes.providerPaymentSetup: (context) =>
                    ProviderPaymentMethod(),
                MyRoutes.morePage: (context) => MorePage(),
                MyRoutes.proPicUpadateDelete: (context) =>
                    const ProPicUpdateDelete(),
                MyRoutes.createServices: (context) => CreateServices(),
                MyRoutes.allCategories: (context) => AllCategories(),
                MyRoutes.forgetPassword: (context) => ForgetPassword(),
                MyRoutes.searchResult: (context) => SearchResult(),
                MyRoutes.providerInfoUpdate: (context) =>
                    ProviderPersonalInformation(),
                MyRoutes.serviceBooking: (context) => ServiceDetailsScreen(),
                MyRoutes.appointmentSchedule: (context) =>
                    AppointmentSchedule(),
                MyRoutes.browseBySubCategory: (context) =>
                    BrowseBySubCategory(),
                MyRoutes.browseByCategory: (context) => BrowseByCategory(),
                MyRoutes.updateUserData: (context) => UpdateUserData(),
                MyRoutes.addressUpdate: (context) => AddressUpdate(),
                MyRoutes.profilePictureUpdate: (context) =>
                    ProfilePictureUpdate(),
                MyRoutes.bankInfoUpdate: (context) => UpdateBankInfo(),
              },
            );
          },
        ),
      ),
    );
  }
}
