import 'package:flutter/material.dart';
import 'package:pipework/main.dart';
import 'package:pipework/ui/screens/home_page.dart';
import 'package:pipework/ui/screens/landing_page.dart';
import 'package:pipework/ui/screens/register_page.dart';
import 'package:pipework/ui/screens/login_page.dart';
import 'data/provider/storage_provider.dart';
import 'package:pipework/ui/screens/payment2.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: <String, WidgetBuilder>{
        '/register': (BuildContext context) {
          return RegisterPage();

        },

        '/login': (BuildContext context) {
          return LoginPage();

        },

        '/homepage': (BuildContext context) {
          return const HomePage(title: 'welcome!',);

        },
        '/payment2': (BuildContext context) {
          return WalletScreen();

        },
      },
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.purple,
      ),
      home: FutureBuilder(
        builder: (context, snapshot) =>
        snapshot.connectionState == ConnectionState.done
            ? LandingPage()
            : const Center(
          child: CircularProgressIndicator(),
        ),
        future: StorageProvider.initialize(),
      ),
      // home:LandingPage(),
    );
  }
}


