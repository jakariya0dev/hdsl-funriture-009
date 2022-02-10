import 'package:flutter/material.dart';
import 'package:hdsl_furniture/screens/sign_up_page.dart';
import 'package:hdsl_furniture/screens/store_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hdsl_furniture/user.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController mailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        constraints: const BoxConstraints.expand(),
        // color: Colors.blue,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 100,
              width: 100,
            ),
            const SizedBox(
              height: 26,
            ),
            const Text(
              'User Login',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              controller: mailController,
              onChanged: (value) {
                setState(() {});
              },
              decoration: InputDecoration(
                  isDense: true,
                  hintText: 'User mail',
                  prefixIcon: const Icon(Icons.mail),
                  suffixIcon: mailController.text.isNotEmpty
                      ? InkWell(
                          onTap: () {
                            mailController.clear();
                          },
                          child: Icon(Icons.clear),
                        )
                      : null,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(35))),
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              controller: passwordController,
              obscureText: isVisible,
              decoration: InputDecoration(
                  isDense: true,
                  hintText: 'User password',
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: GestureDetector(
                      onTap: () {
                        isVisible = !isVisible;
                        setState(() {});
                      },
                      child: Icon(
                          isVisible ? Icons.visibility : Icons.visibility_off)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(35))),
            ),
            const SizedBox(
              height: 16,
            ),
            MaterialButton(
              minWidth: double.infinity,
              height: 50,
              shape: const StadiumBorder(),
              color: Colors.blueAccent,
              onPressed: () {
                userSignIn();
              },
              child: const Text('Log in'),
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Dont have an account?'),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignupPage()));
                    },
                    child: Text('Create one'))
              ],
            )
          ],
        ),
      ),
    );
  }

  userSignIn() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: mailController.text, password: passwordController.text);

      var user = userCredential.user;
      if (user != null) {
        // print(user.uid);
        user_id = user.uid;
        email_id = mailController.text;
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const StorePage()));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showMessage(msg: 'User found for that email.');
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        showMessage(msg: 'Wrong password provided for that user');
        print('Wrong password provided for that user.');
      }
    }
  }

  showMessage({required String msg}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(msg),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('ok'))
            ],
          );
        });
  }
}
