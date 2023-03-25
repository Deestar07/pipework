
import 'package:flutter/material.dart';
import 'dart:convert';
import '../../constants.dart';
import 'package:http/http.dart' as http;

class WalletService {

  Future getWalletBalance(int userId) async {
    debugPrint ('the user id $userId');
    var url = Uri.parse(
        '${Constants.GET_WALLET_BALANCE}?user_id=$userId');
    debugPrint ('the url $url');
    var response = await http.post(url);

    if (response.statusCode == 200) {
      dynamic result = jsonDecode(response.body);
      debugPrint ('this is the result from the api $result');
      var balance = result['balance'];
      debugPrint('Wallet balance $balance');
      return balance;
    }
    if (response.statusCode == 400) {
      dynamic result = jsonDecode(response.body);
      return result;
    }
  }
}










// Future<Balance> getWalletBalance(String userId) async {
//   var url = Uri.parse(
//       Constants.GET_WALLET_BALANCE);
//
//   var user_id;
//   final response = await http
//       .get(Uri.parse('https://celd.josephadegbola.com/wp-json/api/v2/faaji-wallet-balance/?userId= $user_id'));
//
//   if (response.statusCode == 200) {
//     return Balance.fromJson(jsonDecode(response.body));
//   } else {
//     throw Exception('Failed request');
//   }
// }
//
// class Balance {
//   final int userId;
//
//   const Balance({
//     required this.userId
//   });
//
//   factory Balance.fromJson(Map<String, dynamic> json) {
//     return Balance(
//         userId: json['user_id']
//     );
//   }
// }