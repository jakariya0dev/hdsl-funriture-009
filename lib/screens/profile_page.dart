import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hdsl_furniture/screens/login_page.dart';
import 'package:hdsl_furniture/user.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  late TextEditingController nameController;
  late TextEditingController phoneController;

  @override
  Widget build(BuildContext context) {
    nameController = TextEditingController(text: user_name);
    phoneController = TextEditingController(text: phone_number);

    return Scaffold(
        body: Container(
      constraints: const BoxConstraints.expand(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 40,
            child: Icon(
              Icons.person,
              size: 50,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.person),
                  const SizedBox(
                    width: 16,
                  ),
                  Text(
                    user_name ?? 'Null data',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.mail),
                  const SizedBox(
                    width: 16,
                  ),
                  Text(
                    email_id ?? 'Null data',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
          Card(
            margin:
                const EdgeInsets.only(left: 16, right: 16, top: 5, bottom: 24),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.phone),
                  const SizedBox(
                    width: 16,
                  ),
                  Text(
                    phone_number ?? 'Null data',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MaterialButton(
                  minWidth: 100,
                  color: Colors.blue,
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  child: const Text(
                    'Log out',
                    style: TextStyle(color: Colors.white),
                  )),
              MaterialButton(
                  minWidth: 100,
                  color: Colors.blue,
                  onPressed: () {
                    editProfile();
                  },
                  child: const Text(
                    'Edit profile',
                    style: TextStyle(color: Colors.white),
                  )),
            ],
          )
        ],
      ),
    ));
  }

  getUserData() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    var userData = await firestore.collection('users').doc(email_id).get();

    email_id = userData['email'];
    user_name = userData['name'];
    phone_number = userData['phone'];
    setState(() {});
  }

  editProfile() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update your profile'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(icon: Icon(Icons.person)),
              ),
              TextField(
                  controller: phoneController,
                  decoration: InputDecoration(icon: Icon(Icons.phone))),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                updateProfile();
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  updateProfile() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    await firestore.collection('users').doc(email_id).update({
      'name': nameController.text,
      'phone': phoneController.text
    }).then((value) => getUserData());
  }
}
