import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:smart_rto/Welcome.dart';
import './Chatbot/chatbot.dart';
import '../Utility/Constants.dart';

class HomePage extends StatelessWidget {
  static const String id = 'Homepage';
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    late String apiKey = dotenv.env['CHATGPT_API'] ?? 'No API Key';
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: const SizedBox(width: 10.0,),
            backgroundColor: kPrimaryColor,
            title: kAppBarTitle,
            actions: [
              IconButton(
                onPressed: () async{
                  await FirebaseAuth.instance.signOut();
                  Navigator.pop(context);
                  Navigator.pushNamed(context, Welcome.id);
                },
                icon: Icon(Icons.logout),
              ),
            ],
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [

              Align(
                alignment: Alignment.bottomRight, // Align the button to the bottom-right
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, ChatBot.id);
                  },
                  child: const Text('Assistant'),
                ),
              ),
              const SizedBox(height: 10.0,)
            ],
          ),
        ),
      ),
    );
  }
}
