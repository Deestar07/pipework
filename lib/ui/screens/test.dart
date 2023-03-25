// import 'dart:async';
// import 'dart:io';
// import 'dart:math';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_paystack/flutter_paystack.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
//
// import '../../constants.dart';
//
// class CheckOutPage extends StatefulWidget {
//   const CheckOutPage({Key? key}) : super(key: key);
//
//   @override
//   State<CheckOutPage> createState() => _CheckOutPageState();
// }
//
// class _CheckOutPageState extends State<CheckOutPage> {
//   final payStackClient = PaystackPlugin();
//
//
//   final _amountController = TextEditingController();
//
//   final String reference =
//       "unique_transaction_ref_${Random().nextInt(1000000)}";
//
//   void _makePayment() async {
//     final Charge charge = Charge()
//       ..email = 'paystackcustomer@qa.team'
//       ..amount = int.parse(_amountController.text) * 100
//       ..reference = reference;
//
//     final CheckoutResponse response = await payStackClient.checkout(context,
//         charge: charge, method: CheckoutMethod.card);
//
//     if (response.status && response.reference == reference) {
//       Fluttertoast.showToast(msg: 'Successful', backgroundColor: Colors.green);
//     } else {
//       Fluttertoast.showToast(
//           msg: "Unsuccessful",
//           backgroundColor: Colors.redAccent,
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.SNACKBAR);
//     }
//   }
//
//   void _startPaystack() async {
//     // await dotenv.load(fileName: '.env');
//     String? publicKey =  Constants.YOUR_PAYSTACK_PUBLIC_KEY;
//     payStackClient.initialize(publicKey: publicKey!);
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _startPaystack();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Checkout',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           _creatAmountTextField(
//             controller: _amountController,
//             hintText: 'Enter amount',
//             obscureText: false,
//           ),
//           checkOutCard(),
//         ],
//       ),
//     );
//   }
//
//   Widget _creatAmountTextField({
//     required String hintText,
//     TextEditingController? controller,
//     bool obscureText = false,
//   }) {
//     return Container(
//         margin: const EdgeInsets.only(bottom: 12),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: TextFormField(
//           obscureText: obscureText,
//           controller: controller,
//           decoration: InputDecoration(
//               border: OutlineInputBorder(
//                   borderSide: const BorderSide(color: Colors.white),
//                   borderRadius: BorderRadius.circular(12)),
//               hintText: hintText),
//         ));
//   }
//
//   Widget checkOutCard() {
//     return InkWell(
//       onTap: () {
//         _makePayment();
//       },
//       child: Card(
//         margin: const EdgeInsets.symmetric(horizontal: 10),
//         color: Colors.blueAccent,
//         elevation: 15,
//         child: Container(
//           height: 100,
//           child: Padding(
//             padding: const EdgeInsets.all(32.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: const <Widget>[
//                 Text(
//                   "Pay with Paystack",
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                 ),
//                 Icon(
//                   Icons.payment_rounded,
//                   size: 30,
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }








//tyujkjhgfdfghjkl



//
// import 'dart:convert';
// import 'dart:io';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:flutter_paystack/flutter_paystack.dart';
// import 'package:pipework/constants.dart';
// import 'package:http/http.dart' as http;
//
//
// class PaymentPage extends StatefulWidget {
//   const PaymentPage({Key? key}) : super(key: key);
//
//   @override
//   State<PaymentPage> createState() => _PaymentPageState();
// }
//
// class _PaymentPageState extends State<PaymentPage> {
//   var publicKey = Constants.YOUR_PAYSTACK_PUBLIC_KEY;// '[YOUR_PAYSTACK_PUBLIC_KEY]';
//   final plugin = PaystackPlugin();
//   var amount = 1000;
//   var reference =
//       "unique_transaction_ref_${Random().nextInt(1000000)}";
//   var email;
//   String verifyReference(String reference) => "http://3bee-41-184-177-9.ngrok.io/verify/:reference";
//
//
//   @override
//   void initState() {
//     plugin.initialize(publicKey: publicKey);
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context)  {
//     return FutureBuilder(
//       future: getCharge(),
//       builder: ((context, snapshot){
//         if(snapshot.hasError){
//           debugPrint("Snapshot has error ===> ${snapshot.error}");
//
//         }
//         if(snapshot.hasData){
//           debugPrint("Snapshot has data "+ snapshot.data.toString());
//           return snapshot.data;
//         }
//         return  Container();
//
//       }),
//     );
//   }
//
//
//   Future<String> getReference() async {
//
//     try{
//       var url= Uri.parse('http://3bee-41-184-177-9.ngrok.io/get-reference');
//       dynamic result;
//       var response = await http.post(url);
//       if (response.statusCode == 200) {
//         result = jsonDecode(response.body)["data"]["reference"];
//       }
//       return result;
//     }
//     catch (e) {
//       debugPrint(e.toString());
//       throw e;
//     }
//   }
//
//   //verify reference endpoint
//
//
//
//
//
//   Future<dynamic> getCharge() async {
//     Charge charge = Charge();
//     amount = amount * 100;
//     reference =  _getReference();
//     email = 'fun.ade@gmail.com';
//
//     CheckoutResponse response = await plugin.checkout(
//       context,
//       method: CheckoutMethod.card, // Defaults to CheckoutMethod.selectable
//       charge: charge,
//     );
//   }
//
//   String _getReference() {
//     String platform;
//     if (Platform.isIOS) {
//       platform = 'iOS';
//     } else {
//       platform = 'Android';
//     }
//     return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
//   }
// }







import 'package:flutter/material.dart';
import 'package:pipework/data/provider/auth_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({
    Key? key,
  }) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final usernameTextController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final backgroundColor = const Color(0xFFF5F5F5);

  bool isLoading= false;

  @override
  void dispose() {
    emailTextController.dispose();
    passwordTextController.dispose();
    usernameTextController.dispose();
    super.dispose();
  }

  Future _signUp(String password, String email, String username) async {
    setState(() {
      isLoading= false;
    });
    try {
      var result = await authProvider.register(username, email, password);
      var message= result['code']== 200 ? 'user succesfully registered': "user already registered ,proceed to login";
      Fluttertoast.showToast(msg: message , backgroundColor:Colors.green);
      if (result['code'] == 200) {
        Navigator.of(context).pushNamed('/homepage');
      }
    } on Exception catch(error){
      String message= (error as dynamic). message;

      Fluttertoast.showToast(msg: message , backgroundColor:Colors.red ,
          toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.SNACKBAR);
    }
    setState(() {
      isLoading= false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.android, size: 87),
            Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'HELLO THERE!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      "Register below with your details!",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  _createTextField(
                    controller: emailTextController,
                    hintText: 'Email',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Email can't be empty";
                      }
                    },
                  ),
                  _createTextField(
                    controller: passwordTextController,
                    hintText: 'Password',
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password can't be empty";
                      }
                    },
                  ),
                  _createTextField(
                    controller: usernameTextController,
                    hintText: 'username',
                    obscureText: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "fullname can't be empty";
                      }
                    },
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState((){
                  isLoading =true;
                });
                _signUp(passwordTextController.text, usernameTextController.text, emailTextController.text);
              },
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
              child: isLoading ? SizedBox(height:15, width: 15, child: CircularProgressIndicator(color: Colors.white,)): Text('Register'),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Not a member?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
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
        obscureText: obscureText,
        validator: validator,
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
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








// try {
// var result = await authProvider.register(username, email, password);
// Fluttertoast.showToast(msg: result , backgroundColor:Colors.green);
// Navigator.of(context).pushNamed('/homepage');
//
// } on Exception catch(error){
// String message= (error as dynamic). message;
//
// Fluttertoast.showToast(msg: message , backgroundColor:Colors.red ,
// toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.SNACKBAR);
// }