import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pipework/constants.dart';
import 'package:pipework/data/provider/storage_provider.dart';

class AuthService {
  Future<dynamic> register({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      var url = Uri.parse(
          Constants.REGISTER_USER);
      Map body = {
        "email": email,
        "password": password,
        "username": username,
      };
debugPrint('this is the register request body $body');
      http.Response response = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(body)
      );

      if (response.statusCode == 200) {
        dynamic result = jsonDecode(response.body);
        return result;
      }
      if (response.statusCode == 400) {
        dynamic result = jsonDecode(response.body);
        return result;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }


  login({required String password, required String username}) async {
    try {
      var url = Uri.parse(
      Constants.LOGIN_USER);

      Map body = {
        "user_login": username,
        "user_password": password,
      };


      var response = await http.post(url, body: body);


      if (response.statusCode == 200) {
        dynamic result = jsonDecode(response.body);
        await StorageProvider.instance.setString('email', username);
        return result;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }


  //  walletbalance

  Future getWalletBalance(String email) async {
    var url = Uri.parse(
        Constants.GET_WALLET_BALANCE);

    var response = await http.get(url);
    if (response.statusCode == 200) {
      dynamic result = jsonDecode(response.body);
      return result;
    }
    if (response.statusCode == 400) {
      dynamic result = jsonDecode(response.body);
      return result;
    }
  }
}




