import 'package:flutter/material.dart';
import 'package:pipework/data/provider/auth_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final backgroundColor = const Color(0xFFF5F5F5);
  final formKey = GlobalKey<FormState>();
  final usernameTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  String? _validateEmail(String? value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  }

  @override
  void dispose() {
    passwordTextController.dispose();
    usernameTextController.dispose();
    super.dispose();
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
            const Icon(Icons.android, size: 70),
            Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Wa Se Faaji' ,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  ),),
                  
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text("Welcome back!",
                    style:TextStyle(
                      fontSize: 20,
                    ),
                    ),
                  ),
                  _createTextField(
                    controller: usernameTextController,
                      hintText: 'Email',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Username can't be empty";
                        }
                        return _validateEmail(value);
                      },),
                  _createTextField(
                    controller: passwordTextController,
                      hintText: 'Password',
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Password can't be empty";
                        }
                      }),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: (){
                _signIn();
            },
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),

              child:  const Text('Sign In'),

            ),

             Padding(
               padding: const EdgeInsets.all(12)
               ,
               child: Row(

                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   const Text('Not a member?',
                   style: TextStyle(
                     fontWeight: FontWeight.bold,
                         fontSize: 20,
                   ),),
                   InkWell(
                     onTap:(){
                       Navigator.of(context).pushNamed('/register');
                     },
                     child : Text('Register now' , style: TextStyle(color: Colors.blue,
                     fontWeight: FontWeight.bold,
                     fontSize: 18
                   ),)
                   ),
                 ],
               ),
             )
          ],
        ),
      ),
    );
  }

 Future _signIn() async {

   showDialog(
       context: context,
       builder: (context) {
         return const Center(
           child: CircularProgressIndicator(),
         );
       });
    if (!formKey.currentState!.validate()) {
      Navigator.pop(context);
      return;
    }
    try{

   var result = await authProvider.login(usernameTextController.text, passwordTextController.text);

   if (result == 'user logged in') {
     // Navigator.pop(context);

     Navigator.of(context).pushNamed('/homepage');
   }
  }
    on Exception catch(e){
      Navigator.pop(context);
      final message = (e as dynamic).message;
      ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(message)));
    }

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


