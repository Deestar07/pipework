
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
      debugPrint('this is the result code ${result['code']}');

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
                _signUp(passwordTextController.text, emailTextController.text,usernameTextController.text);
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