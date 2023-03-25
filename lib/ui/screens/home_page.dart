import 'package:flutter/material.dart';
import 'package:pipework/ui/widget/swipe_detector.dart';
import 'package:pipework/data/provider/storage_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  int? userId ;
  int? _balanceRetrieved = 0;
  int storeWalletBalance = 0;
  bool _refresh= false;
  int counter = 0;

  @override
  void initState() {

    setState(() {
      debugPrint('The keys in the storage provider ${StorageProvider.instance.getKeys()}');
      if (StorageProvider.instance.containsKey('walletBalance')) {
        // StorageProvider.instance.reload();
        debugPrint("This is homepage wallet balance ");
        storeWalletBalance =  StorageProvider.instance.getInt('walletBalance') ?? 0;
        counter = storeWalletBalance;
        userId =  StorageProvider.instance.getInt('userId');
      } else {
        debugPrint("The walletBalance key does not exist in the local storage");
      }
      debugPrint("This is the current value of the storeWalletBalance $storeWalletBalance");

    });
    super.initState();

  }

void _incrementCounter() {
  setState(() {
    storeWalletBalance--;
  });
  StorageProvider.instance.setInt('walletBalance', storeWalletBalance);
}
Future <SharedPreferences> getStorageProviderInstance()async{
   return await StorageProvider.instance;
}
@override
Widget build(BuildContext context) {
final Object? refresh  = ModalRoute.of(context)?.settings.arguments;
  if(refresh != null){
    _refresh = _refresh;
  }
  // var storeWalletBalance ;

  return Scaffold(backgroundColor: Colors.grey,

    appBar: AppBar(
      actions: [
        GestureDetector(
            child: Center(child: Text('logout')),
            onTap: ( ) async{
              bool userIsLoggedOut  =await StorageProvider.instance.clear();
              debugPrint('user currently logged out is $userIsLoggedOut');
              if (userIsLoggedOut ) Navigator.of(context).pushNamed('/login');
            }
        )
      ],

      automaticallyImplyLeading: false,
      title: Text(widget.title),
    ),
    body: SwipeDetector(
      onSwipeUp: () {
        debugPrint("swiped");
        _incrementCounter();
  },

  child: Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      const Text(
        'Wallet balance is:',

      ),
      Text(
      'N $storeWalletBalance',
        style: Theme.of(context).textTheme.headline4,

  ),

    ],

  ),
  )

    ),
    floatingActionButton: FloatingActionButton(
      onPressed: (){
    Navigator.of(context).pushNamed('/payment2');
    },
      tooltip: 'Fund Wallet',
      child: Center(child: SizedBox(child: const Icon(Icons.monetization_on_outlined)))

    ),
  );
}

Future<double?> getWalletBalanceFromSharedPreference()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var balance= preferences.getDouble('walletBalance');
    return balance;
}
}









// _balanceRetrieved = StorageProvider.instance.getInt('walletBalance') == null ? 0 :  StorageProvider.instance.getInt('walletBalance');
// storeWalletBalance = _balanceRetrieved!;