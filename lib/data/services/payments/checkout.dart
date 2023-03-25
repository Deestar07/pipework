// import 'dart:convert';
// import 'dart:io';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:flutter_paystack/flutter_paystack.dart';
// import 'package:fluttertoast/fluttertoast.dart';
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
//   final payStackClient = PaystackPlugin();
//
//
//   final _amountController = TextEditingController();
//
//   final String _getReference =
//       "unique_transaction_ref_${Random().nextInt(1000000)}";
//
//   void _makePayment() async {
//     final Charge charge = Charge()
//       ..email = 'paystackcustomer@qa.team'
//       ..amount = int.parse(_amountController.text) * 100
//       ..reference = _getReference;
//
//
//        final CheckoutResponse response = await payStackClient.checkout(context,
//         charge: charge, method: CheckoutMethod.card);
//
//     if (response.status && response.reference == _getReference) {
//       Fluttertoast.showToast(msg: 'Successful', backgroundColor: Colors.green);
//     } else {
//       Fluttertoast.showToast(
//           msg: "Unsuccessful",
//           backgroundColor: Colors.redAccent,
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.SNACKBAR);
//     }
//   }
//   //
//   // void getReference() async {
//   //   await Constants.load(fileName: '.constants');
//   //   String? publicKey = Constants.YOUR_PAYSTACK_PUBLIC_KEY;;
//   //   payStackClient.initialize(publicKey: publicKey);
//   // }
//
//   Future<String> verifyReference(String reference) async {
//     try{
//       String? verify_url = Constants.VERIFY_PAYSTACK_REFERENCE + reference;
//       var url= Uri.parse(verify_url);
//       dynamic result;
//       var response = await http.post(url);
//       if (response.statusCode == 200) {
//         result = jsonDecode(response.body)["status"];
//       }
//       return result;
//     }
//     catch (e) {
//       debugPrint(e.toString());
//       throw e;
//     }
//   }
//
//
//   Future<String> generateReference(String reference) async {
//     try{
//       String? generate_url = Constants.GENERATE_PAYSTACK_REFERENCE + reference;
//       var url= Uri.parse(generate_url);
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
//
//
//
//
//   @override
//   void initState() {
//     super.initState();
//    //  verifyReference();
//    // generateReference();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Pay With Paystack',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           _createAmountTextField(
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
//   Widget _createAmountTextField({
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
//         color: Colors.purple,
//         elevation: 15,
//         child: Container(
//           height: 100,
//           child: Padding(
//             padding: const EdgeInsets.all(32.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: const <Widget>[
//                 Text(
//                   "Make Payment",
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