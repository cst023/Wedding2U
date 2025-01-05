import 'package:flutter/material.dart';
import 'package:wedding2u_app/presentation/screens/general/sign_up.dart';


class SignUpUserRoles extends StatefulWidget {

 @override
  _SignUpUserRolesState createState() => _SignUpUserRolesState();
}

class _SignUpUserRolesState extends State<SignUpUserRoles> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  SizedBox(height: 8),
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

            SizedBox(height: 24),

            // Sign Up Title
            Text(
              'Sign Up as',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 36,
              ),
            ),

            SizedBox(height: 24),

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
                              builder: (context) => SignUp(role: "Client"),
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
                              builder: (context) => SignUp(role: "Vendor"),
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

                  SizedBox(height: 16),

                  // Second row of clickable options
                  GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignUp(role: "Admin"),
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

            Spacer(),

            // Sign In Link
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, 'SignIn');
                },
                child: Text(
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

            SizedBox(height: 20.0),

            // "Continue as Guest" button
            Container(
              width: 200,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'ContinueGuest');
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                      color: Colors.black, width: 1.5), // Black border
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  'Continue as Guest',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ),

            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

}