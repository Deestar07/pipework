import 'package:flutter/material.dart';
import 'package:pipework/data/provider/storage_provider.dart';
import 'package:pipework/data/services/auth_service.dart';
import '../services/wallet_service.dart';

class AuthProvider extends ChangeNotifier {
  bool isLoggedIn = false;
  String? username;
  String? password;
  String? email;


  final service = AuthService();

  set isRegistered(bool isRegistered) {}


  Future login(String username,
      String password, {
        bool isRegistered = false,
      }) async {
    this.username = username;
    this.password = password;
    this.isRegistered = isRegistered;
    var result = await service.login(password: password, username: username);
    print('result: ');
    print(result);

    if (result['status'] == 200) {
    debugPrint('Before calling storagewallet balance function');
     await storeWalletBalance(result['user_id']);
    debugPrint('After calling storagewallet balance function');
      isLoggedIn = true;

      await StorageProvider.instance.setInt ('userId' , result['user_id']);

      notifyListeners();
      return 'user logged in';
    }

    if (result['status'] == 401) {
      throw Exception('login not successful');
    }

    return result;
  }

  //Getting and saving wallet balance in the local storage

     storeWalletBalance(int userId) async{
     var balance = await WalletService().getWalletBalance(userId);
     debugPrint("This is the current wallet balance ====>>>> ${balance}");
     // balance= int.parse(balance);
     if (balance.runtimeType == 'String' ) balance = int.parse(balance);
     await StorageProvider.instance.setInt('walletBalance' , balance);
     var getBalance= StorageProvider.instance.getInt('walletBalance');
     debugPrint("This is the wallet balance from the local storage====>>>> ${getBalance}");
  }

  Future register(String username,
      String email,
      String password, {
        bool isLoggedIn = false,
      }) async {
    this.username = username;
    this.password = password;
    this.isLoggedIn = isLoggedIn;
    var result = await service.register(
        email: email, password: password, username: username);
debugPrint('this is the result from the register function $result');
    if (result['code'] == 200) {
      notifyListeners();
      return result;
    }

    if (result['code'] == 406) {
      return result;
      //throw Exception('registration not successful');
    }
    return result;
  }

  logout() {
    username = null;
    password = null;
    isLoggedIn = false;
    notifyListeners();
  }
}
  final authProvider = AuthProvider();
