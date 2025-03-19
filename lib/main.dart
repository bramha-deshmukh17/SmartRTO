import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'officials_page/license/license_list.dart';
import 'officials_page/fines/confirm_fine.dart';
import 'officials_page/grievance/view_grievances.dart';
import 'officials_page/license/view_application.dart';
import 'officials_page/officer_profile.dart';
import 'officials_page/puc/puc_application.dart';
import 'officials_page/puc/puc_list.dart';
import 'user_pages/grievance/grievance_list.dart';
import 'user_pages/license/license_application.dart';
import 'user_pages/license/phone_authenticate.dart';
import 'user_pages/profile/edit_profile.dart';
import 'user_pages/profile/profile.dart';
import 'user_pages/puc/phone_authentication.dart';
import 'user_pages/puc/puc_application.dart';
import 'user_pages/user_register.dart';
import 'Utility/Constants.dart';
import 'authentication/authenticate.dart';
import 'officials_page/fines/generate_fine.dart';
import 'officials_page/officer_login.dart';
import 'officials_page/home_screen.dart';
import 'officials_page/fines/view_details.dart';
import 'splash_screen.dart';
import 'user_pages/chatbot/chatbot.dart';
import 'user_pages/license/license.dart';
import 'user_pages/vehicle/vehicles.dart';
import 'welcome.dart';
import 'user_pages/home_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
// ...
void main() async{
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: kPrimaryColor), // Set globally
  ); 
  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'InriaSans'),
      routes: <String, WidgetBuilder>{
        '/': (context) => SplashScreen(),
        '/authenticate': (context)=> const Authenticate(),
        Welcome.id: (context)=> const Welcome(),

        //User pages
        UserRegister.id: (context)=> const UserRegister(),
        HomePage.id : (context)=> const HomePage(),
        UserProfile.id : (context)=> const UserProfile(),
        EditUserProfile.id: (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return EditUserProfile(
            userName: args['userName'],
            userEmail: args['userEmail'],
            userImg: args['userImg'],
            userMobile: args['userMobile'],
          );
        },
        ViewVehicle.id: (context)=> const ViewVehicle(),
        Grievancelist.id: (context)=> const Grievancelist(),
        ChatBot.id: (context)=> const ChatBot(),
        LicenseInfoPage.id: (context)=> const LicenseInfoPage(),
        PhoneAuthenticate.id: (context)=> const PhoneAuthenticate(),
        LicenseApplication.id: (context)=> const LicenseApplication(),
        PhoneAuthentication.id: (context)=> PhoneAuthentication(),
        PucApplication.id: (context)=> const PucApplication(),

        //officer pages
        OfficerLogin.id: (context)=> const OfficerLogin(),
        HomeScreen.id: (context)=> const HomeScreen(),
        Profile.id:  (context)=> const Profile(),
        GenerateFines.id: (context)=> const GenerateFines(),
        Confirmfine.id: (context)=> const Confirmfine(),
        ViewDetails.id: (context)=> const ViewDetails(),
        OfficerGrievanceList.id: (context)=> const OfficerGrievanceList(),
        LearnerLicenseList.id: (context)=> const LearnerLicenseList(),
        ViewApplication.id: (context)=> const ViewApplication(),
        PucList.id: (context)=>  PucList(),
        ViewPucApplication.id: (context)=> ViewPucApplication(),


      },
      initialRoute: '/',

    );
  }
}