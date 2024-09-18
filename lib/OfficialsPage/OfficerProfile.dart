import 'package:flutter/material.dart';
import 'package:smart_rto/Utility/Constants.dart';
class Profile extends StatefulWidget {
  static const String id = 'OfficeProfile';
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        title: kAppBarTitle,
        backgroundColor: kPrimaryColor,
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: kBackArrow),
      ),
      body: const Center(
        child: Column(
        children: [

        ],
      ),),
    ),);
  }
}
