import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_rto/OfficialsPage/ConfirmFine.dart';
import 'package:smart_rto/OfficialsPage/OfficerProfile.dart';
import 'package:smart_rto/UserPages/UserRegister.dart';
import 'package:smart_rto/Utility/Constants.dart';
import 'Authentication/Authenticate.dart';
import 'OfficialsPage/GenerateFine.dart';
import 'OfficialsPage/OfficerLogin.dart';
import 'OfficialsPage/HomeScreen.dart';
import 'Welcome.dart';
import 'UserPages/HomePage.dart';
import 'Chatbot/chatbot.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
// ...
void main() async{
  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: kPrimaryColor,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context)=> const Authenticate(),
        Welcome.id: (context)=> const Welcome(),

        UserRegister.id: (context)=> const UserRegister(),
        HomePage.id : (context)=> const HomePage(),
        ChatBot.id: (context)=> const ChatBot(),

        OfficerLogin.id: (context)=> const OfficerLogin(),
        HomeScreen.id: (context)=> const HomeScreen(),
        Profile.id:  (context)=> const Profile(),
        GenerateFines.id: (context)=> const GenerateFines(),
        Confirmfine.id: (context)=> const Confirmfine(),

      },
      initialRoute: '/',

    );
  }
}