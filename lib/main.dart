import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'OfficialsPage/License/LernerLicense/LearnerLicenseList.dart';
import 'OfficialsPage/Fine/ConfirmFine.dart';
import 'OfficialsPage/Grievance/OfficerGrievanceList.dart';
import 'OfficialsPage/OfficerProfile.dart';
import 'UserPages/Grievance/GrievanceList.dart';
import 'UserPages/License/LicenseApplication.dart';
import 'UserPages/License/PhoneAuthenticate.dart';
import 'UserPages/Profile/EditProfile.dart';
import 'UserPages/Profile/UserProfile.dart';
import 'UserPages/UserRegister.dart';
import 'Utility/Constants.dart';
import 'Authentication/Authenticate.dart';
import 'OfficialsPage/Fine/GenerateFine.dart';
import 'OfficialsPage/OfficerLogin.dart';
import 'OfficialsPage/HomeScreen.dart';
import 'OfficialsPage/Fine/ViewDetails.dart';
import 'SplashScreen.dart';
import 'UserPages/Chatbot/chatbot.dart';
import 'UserPages/License/LicenseInfoPage.dart';
import 'UserPages/Vehicle/Vehicles.dart';
import 'Welcome.dart';
import 'UserPages/HomePage.dart';
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
        ChatBot.id: (context)=> const ChatBot(),
        LicenseInfoPage.id: (context)=> const LicenseInfoPage(),
        PhoneAuthenticate.id: (context)=> const PhoneAuthenticate(),
        LicenseApplication.id: (context)=> const LicenseApplication(),
        Grievancelist.id: (context)=> const Grievancelist(),

        //officer pages
        OfficerLogin.id: (context)=> const OfficerLogin(),
        HomeScreen.id: (context)=> const HomeScreen(),
        Profile.id:  (context)=> const Profile(),
        GenerateFines.id: (context)=> const GenerateFines(),
        Confirmfine.id: (context)=> const Confirmfine(),
        ViewDetails.id: (context)=> const ViewDetails(),
        OfficerGrievanceList.id: (context)=> const OfficerGrievanceList(),
        LearnerLicenseList.id: (context)=> const LearnerLicenseList(),

      },
      initialRoute: '/',

    );
  }
}