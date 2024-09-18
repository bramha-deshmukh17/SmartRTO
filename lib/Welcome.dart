import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'UserLogin.dart';
import 'OfficialsPage/OfficerLogin.dart';
import 'Utility/MyCard.dart';
import 'Utility/Constants.dart';
import 'UserPages/UserRegister.dart';

class Welcome extends StatelessWidget {
  static const String id = 'Welcome';

  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.add,color: Colors.transparent,),
          backgroundColor: kPrimaryColor,
          title: kAppBarTitle,
        ),
        body: Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomCard(
                cardTitle: 'User',
                icon: FontAwesomeIcons.userLarge,

                button1: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, UserRegister.id);
                    },
                    child: Text('Register',style: TextStyle(color: kSecondaryColor,fontSize: 18,),)),
              ),
              CustomCard(
                cardTitle: 'Officials',
                icon: Icons.local_police,
                button2: SizedBox(),
                button1: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, OfficerLogin.id);
                    },
                    child: Text('Login',style: TextStyle(color: kSecondaryColor,fontSize: 18,),),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
