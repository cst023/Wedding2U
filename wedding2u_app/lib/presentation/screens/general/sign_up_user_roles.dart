import 'package:flutter/material.dart';
import 'package:wedding2u_app/presentation/screens/general/sign_up.dart';

class SignUpUserRoles extends StatefulWidget {
  const SignUpUserRoles({super.key});

  @override
  _SignUpUserRolesState createState() => _SignUpUserRolesState();
}

class _SignUpUserRolesState extends State<SignUpUserRoles> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      //backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo at the Top
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/wedding2u_logo.png',
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'SINCE 2010',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Sign Up Title
            const Text(
              'Sign Up as',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 36,
              ),
            ),

            const SizedBox(height: 24),

            // Sign In Options
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                children: [
                  // First row of clickable options
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const SignUp(role: "Client"),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/client_icon.jpg',
                              height: 140,
                              width: 140,
                            ),
                          ],
                        ),
                      ),
                      //SizedBox(width:5),

                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const SignUp(role: "Vendor"),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/vendor_icon.jpg',
                              height: 140,
                              width: 140,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Second row of clickable options
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUp(role: "Admin"),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/admin_icon.jpg',
                          height: 140,
                          width: 140,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Sign In Link
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, 'SignIn');
                },
                child: const Text(
                  "Already have an account? Sign In",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20.0),

            // "Continue as Guest" button
            SizedBox(
              width: 200,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'ContinueGuest');
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                      color: Colors.black, width: 1.5), // Black border
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  'Continue as Guest',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
