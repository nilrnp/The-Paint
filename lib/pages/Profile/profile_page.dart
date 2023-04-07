import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_paint/components/my_text_field.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late User _user;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser!;
    _emailController.text = _user.email!;
  }

  Future<void> _changeEmail() async {
    try {
      await _user.updateEmail(_emailController.text);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Email changed successfully'),
      ));
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message!),
      ));
    }
  }

  Future<void> _changePassword() async {
    try {
      await _user.updatePassword(_passwordController.text);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Password changed successfully'),
      ));
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message!),
      ));
    }
  }

  File? _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[900],
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 50),
              CircleAvatar(
                radius: 50,
                backgroundImage: _image != null ? FileImage(_image!) : null,
                child: _image == null
                    ? Icon(
                        Icons.person,
                        size: 75,
                        color: Colors.grey[400],
                      )
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: getImage,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.edit),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              const Text(
                'Email:',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: MyTextField(
                  controller: _emailController,
                  hintText: _user.uid,
                  obscureText: false,
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _changeEmail,
                child: Text('Change Email'),
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white),
              ),
              SizedBox(height: 20),
              const Text(
                'Password:',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: MyTextField(
                  controller: _passwordController,
                  obscureText: true,
                  hintText: 'New Password',
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _changePassword,
                child: Text('Change Password'),
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white),
              ),
              SizedBox(height: 20),
              const Text(
                'Account Created Date:',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              SizedBox(height: 5),
              Text(
                _user.metadata.creationTime.toString(),
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
