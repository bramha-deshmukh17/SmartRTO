import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_rto/OfficialsPage/Fine/ConfirmFine.dart';
import 'package:smart_rto/OfficialsPage/Grievance/OfficerGrievanceList.dart';
import 'package:smart_rto/OfficialsPage/OfficerProfile.dart';
import 'package:smart_rto/UserPages/Grievance/GrievanceList.dart';
import 'package:smart_rto/UserPages/Profile/EditProfile.dart';
import 'package:smart_rto/UserPages/Profile/UserProfile.dart';
import 'package:smart_rto/UserPages/UserRegister.dart';
import 'package:smart_rto/Utility/Constants.dart';
import 'Authentication/Authenticate.dart';
import 'OfficialsPage/Fine/GenerateFine.dart';
import 'OfficialsPage/OfficerLogin.dart';
import 'OfficialsPage/HomeScreen.dart';
import 'OfficialsPage/Fine/ViewDetails.dart';
import 'SplashScreen.dart';
import 'UserPages/Chatbot/chatbot.dart';
import 'UserPages/LicenseInfoPage.dart';
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
        Grievancelist.id: (context)=> const Grievancelist(),

        //officer pages
        OfficerLogin.id: (context)=> const OfficerLogin(),
        HomeScreen.id: (context)=> const HomeScreen(),
        Profile.id:  (context)=> const Profile(),
        GenerateFines.id: (context)=> const GenerateFines(),
        Confirmfine.id: (context)=> const Confirmfine(),
        ViewDetails.id: (context)=> const ViewDetails(),
        OfficerGrievanceList.id: (context)=> const OfficerGrievanceList(),

      },
      initialRoute: '/',

    );
  }
}