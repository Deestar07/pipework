import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pipework/app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';
import 'data/services/wallet_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:isolate';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> backgroundFetchHeadlessTask(task) async {
  print('Call to backgroundFetchHeadlessTask');
  final prefs = await SharedPreferences.getInstance();
  await prefs.reload();

// You can can also directly ask the permission about its status.
//   if (await Permission.location.isRestricted) {
//     // The OS restricts access, for example because of parental controls.
//   }
  final userId=prefs.getInt('userId') ==null? null: prefs.getInt('userId');
  if (userId != null) {
    try{
      var balanceRemote = await WalletService().getWalletBalance(userId);
      final balanceLocal = prefs.getInt('walletBalance');
      if (balanceRemote > balanceLocal) {
        var difference = (balanceRemote - balanceLocal);
        var url = Uri.parse(
            Constants.UPDATE_WALLET_BALANCE);
        Map body = {
          "action": "difference",
          "userId": userId.toString(),
          "amount": difference.toString()
        };
        print('this is the url for wallet balance update $url');
        print('this is the update wallet balance  body $body');
        http.Response response = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(body),
        );
        print('this is the response from update wallet');
        dynamic result = (response.body.toString());

        print(result);
        if (response.statusCode == 200) {
          print(
              'successfully updated wallet balance at the background $response');
          Fluttertoast.showToast(
            msg: "Wallet balance successfully synchronized with the server.",
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
        else {
          print(
              'failed to update wallet balance at the background $response');
        }
      }
    }
    catch(Error){
      print('this is the error from attempting to update wallet balance $Error');
    }
  }
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await AndroidAlarmManager.initialize();
  // var status = await Permission.scheduleExactAlarm.status;
  var status = await Permission.scheduleExactAlarm.request();

  if (status.isGranted) {
    // Schedule the alarm to run the backgroundFetchHeadlessTask function every hour
     AndroidAlarmManager.periodic(
      const Duration(seconds: 30),
      0, // Unique alarm ID
      backgroundFetchHeadlessTask,
      exact: true,
      wakeup: true,
    );
    // We didn't ask for permission yet or the permission has been denied before but not permanently.
  }
  else{
    print('scheduled alarm permission denied');
  }

  runApp(const App());
}
