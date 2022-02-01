import 'package:flutter/material.dart';
import 'package:hdsl_furniture/screens/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController mailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
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
              'User Sign Up',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              controller: nameController,
              onChanged: (value) {
                setState(() {});
              },
              decoration: InputDecoration(
                  isDense: true,
                  hintText: 'User name',
                  prefixIcon: const Icon(Icons.person),
                  suffixIcon: nameController.text.isNotEmpty
                      ? InkWell(
                          onTap: () {
                            nameController.clear();
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
              controller: mailController,
              obscureText: isVisible,
              decoration: InputDecoration(
                  isDense: true,
                  hintText: 'User mail',
                  prefixIcon: Icon(Icons.mail),
                  suffixIcon: GestureDetector(
                      onTap: () {
                        mailController.clear();
                        setState(() {});
                      },
                      child: Icon(Icons.clear)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(35))),
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              controller: phoneController,
              onChanged: (value) {
                setState(() {});
              },
              decoration: InputDecoration(
                  isDense: true,
                  hintText: 'User Phone',
                  prefixIcon: const Icon(Icons.phone),
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
                userSignUp();
              },
              child: const Text('Sign Up'),
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Al ready have an account?'),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()));
                    },
                    child: const Text('Sign in'))
              ],
            )
          ],
        ),
      ),
    );
  }

  void userSignUp() async {
    // FirebaseAuth auth = FirebaseAuth.instance;
    if (nameController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        mailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: mailController.text, password: passwordController.text);
        saveUserData();
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginPage()));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          showErrorDialog('The password provided is too weak.');
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          showErrorDialog('The account already exists for that email.');
          print('The account already exists for that email.');
        }
      } catch (e) {
        showErrorDialog(e.toString());
        print(e);
      }
    } else {
      showErrorDialog('Please fill all fields');
    }
  }

  showErrorDialog(String errorMsg) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Warning!'.toUpperCase(),
              style: const TextStyle(color: Colors.red),
            ),
            content: Text(errorMsg),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Ok'))
            ],
          );
        });
  }

  saveUserData() {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    firestore.collection('users').doc(mailController.text).set({
      'email': mailController.text,
      'phone': phoneController.text,
      'name': nameController.text
    });
  }
}
