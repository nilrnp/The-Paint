import 'package:flutter/material.dart';
import 'package:the_paint/components/my_button.dart';
import 'package:the_paint/components/my_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:the_paint/pages/Registering/login_page.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;

  const RegisterPage({super.key, this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // sign user up method
  void signUserUp() async {
    // loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // try creating the user
    try {
      // check if password and confirm password are the same
      if (passwordController.text != confirmPasswordController.text) {
        Navigator.pop(context);
        wrongSignUpMessage("Passwords do not match");
        return;
      } else {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
      }

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
                'Account has been created',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          );
        },
      );
      // wait 2 seconds
      await Future.delayed(Duration(seconds: 5));
      // go back to login page
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return LoginPage();
      }));
    } on FirebaseAuthException catch (e) {
      // stop loading circle
      Navigator.pop(context);
      // show error message
      wrongSignUpMessage(e.code);
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
                  'Create an account',
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

                //password
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),

                const SizedBox(height: 10),

                //confirm password
                MyTextField(
                  controller: confirmPasswordController,
                  hintText: 'Confirm Password',
                  obscureText: true,
                ),

                const SizedBox(height: 25),

                //sign in button
                MyButton(
                  onTap: signUserUp,
                  text: 'Sign Up',
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
                    SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return LoginPage();
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
