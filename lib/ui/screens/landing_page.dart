import 'package:flutter/material.dart';
import 'package:pipework/data/provider/auth_provider.dart';
import 'login_page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  void initState(){
    authProvider.addListener(onChangeNotify);
    super.initState();
  }

  @override
  void dispose(){
    authProvider.removeListener(onChangeNotify);
    super.dispose();
  }
   onChangeNotify(){
    setState(() {

    });
   }

  @override
  Widget build(BuildContext context) {
    if (!authProvider.isLoggedIn){
      return LoginPage();
    }

   return Center();
  }
}
