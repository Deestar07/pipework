import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:pipework/constants.dart';
import 'package:pipework/data/provider/storage_provider.dart';
import 'dart:convert';
import 'dart:math';

import '../../data/services/wallet_service.dart';


class WalletScreen extends StatefulWidget {
  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  int walletBalance = 0;
  int enteredAmount = 0;
  int? userId = 0;
  String? enteredEmail = '';
  String accesscode= '';
  var paystackPublicKey = Constants.YOUR_PAYSTACK_PUBLIC_KEY;
  final plugin = PaystackPlugin();
  TextEditingController amountController = new TextEditingController();

  @override
  void initState() {
    plugin.initialize(publicKey: paystackPublicKey);
    setState(() {
      if (StorageProvider.instance.containsKey('walletBalance')) {
      walletBalance =  StorageProvider.instance.getInt('walletBalance') ?? 0;
      userId =  StorageProvider.instance.getInt('userId');
      enteredEmail =  StorageProvider.instance.getString('email');

      } else {
      debugPrint("The walletBalance key does not exist in the local storage");
      }
      debugPrint("This is the current value of the storeWalletBalance $walletBalance");

    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: (){ Navigator.pop(context, true);},) ,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Wallet Balance: ₦ $walletBalance'),
          _createTextField(hintText: 'Amount' , controller: amountController),
          SizedBox(
            width:100,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    vertical: 16,
                  ),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                fixedSize: Size(MediaQuery.of(context).size.width, 50),
              ),
              onPressed: () async{
                Fluttertoast.showToast(
                  msg: "Loading....",
                  toastLength: Toast.LENGTH_SHORT,
                  timeInSecForIosWeb: 3,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
                await _checkout(context,userId!,amountController,plugin, enteredEmail!);
                var balance = await WalletService().getWalletBalance(userId!);
                await StorageProvider.instance.setInt('walletBalance', balance);
                setState(() {
                  walletBalance= balance;
                });
              },
              child: Text('Fund My Wallet'),
            ),
          )
        ],
      ),
    );
  }

  Widget _createTextField({
    required String hintText,
    TextEditingController? controller,
    bool obscureText = false,
    String? Function(String? value)? validator,
  }) {

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: TextFormField(
        keyboardType: TextInputType.number,
        obscureText: obscureText,
        validator: validator,
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(12),
          ),
          fillColor: Colors.white,
          hintText: hintText,
        ),
      ),
    );
  }
}

Future<void> _checkout(BuildContext context, int userId, TextEditingController amountController, PaystackPlugin plugin, String email ) async {
    String? generate_url = Constants.GENERATE_PAYSTACK_REFERENCE;
    var url= Uri.parse(generate_url);
    // Generate payment reference
    ;
    debugPrint('This is the userId in the local storage $userId');
    var response = await http.post(url,
        body: jsonEncode({
          'amount': int.parse(amountController.text)  ,
          //       ..amount = int.parse(_amountController.text) * 100
          'id' : userId,
          'email': userId,
          "metadata": userId,
        }),
        headers: {
          'Content-Type': 'application/json',
        }
    );
    var responseData = jsonDecode(response.body);
    print(responseData);
    String reference = responseData['data']['reference'] + Random().nextInt(1000).toString();


    try{
      // Open Paystack payment gateway
      Charge charge = Charge()
        ..amount = int.parse(amountController.text)  * 100
        ..reference = reference
        ..email = email;

      charge.putMetaData('userid', userId);
      CheckoutResponse checkoutResponse = await plugin.checkout(
        context,
        charge: charge,
        method: CheckoutMethod.card,
      );
      // Verify payment reference
      if (checkoutResponse.message == 'Success')  {

        var url= Uri.parse(Constants.VERIFY_PAYSTACK_REFERENCE +reference);
        var verificationResponse = await http.get(url);
        var verificationResponseData = jsonDecode(verificationResponse.body);
        debugPrint(verificationResponseData.toString());
        if (verificationResponseData['status'] == true) {
          Navigator.of(context).pushNamed('/payment2');
          Fluttertoast.showToast(
            msg: "You can now proceed to spray",
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      }
    }
    catch(e){
      debugPrint("Error here");
      debugPrint(e.toString());
    }
}




