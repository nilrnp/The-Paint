import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_paint/pages/Registering/login_page.dart';
import '../../components/my_button.dart';
import '../../components/my_text_field.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();

  // send password reset link method
  Future sendPasswordResetLink() async {
    // loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // try sending reset password link
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      // stop loading circle
      Navigator.pop(context);
      // show confirmed message
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            backgroundColor: Colors.blueAccent,
            title: Center(
              child: Text(
                'Password reset link sent to email',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          );
        },
      );
      // wait 2 seconds
      await Future.delayed(const Duration(seconds: 5));
      // go back to login page
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const LoginPage();
      }));
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message!),
      ));
    }
  }

  // wrong login message
  void wrongSignUpMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.blueAccent,
          title: Center(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),

                //logo
                const Image(
                  image: AssetImage('lib/images/Logo_Transparent.png'),
                  width: 275,
                  height: 290,
                  fit: BoxFit.fill,
                ),

                const SizedBox(height: 50),

                //welcome back text
                const Text(
                  'Enter email to get password reset link',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),

                const SizedBox(height: 25),

                //email
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                const SizedBox(height: 10),

                const SizedBox(height: 25),

                //sign in button
                MyButton(
                  onTap: sendPasswordResetLink,
                  text: 'Reset Password',
                ),

                const SizedBox(height: 10),

                // Divider
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    children: const [
                      Expanded(
                        child: Divider(
                          thickness: .5,
                          color: Colors.white,
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: .5,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                //create an account
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account?',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const LoginPage();
                        }));
                      },
                      child: const Text(
                        'Login now!',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
