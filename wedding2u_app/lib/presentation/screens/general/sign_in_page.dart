import 'package:flutter/material.dart';
import 'package:wedding2u_app/presentation/screens/general/forgot_password_page.dart';
import 'package:wedding2u_app/utils/input_validation.dart';
import 'package:wedding2u_app/application/sign_in.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final SignInService _signInService = SignInService();
  final _formKey = GlobalKey<FormState>();

  String email = "";
  String password = "";
  bool _isPasswordVisible = false;
  bool _isLoading = false; // To control the loading spinner
  TextEditingController _controller = TextEditingController();

  void _submitLoginForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true; // Show spinner
      });

      try {
        String uid = await _signInService.signIn(
          email: email,
          password: password,
        );

        String role = await _signInService.fetchRole(uid);

        Map<String, dynamic> userData = await _signInService.fetchUserData(uid);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Signed in successfully'),
            backgroundColor: Colors.green,
          ),
        );

        await Future.delayed(Duration(seconds: 1));

        _controller.clear();

        // Navigate based on user role
        if (role == "Client") {
          Navigator.pushNamed(context, 'ClientMainPage', arguments: userData);
        } else if (role == "Vendor") {
          Navigator.pushNamed(context, 'VendorDashboard');
        } else if (role == "Admin") {
          print("Admin Dashboard in construction..");
          Navigator.pushNamed(context, 'AdminDashboard2');
        } else {
          throw Exception("Invalid role");
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false; // Hide spinner
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 40.0),

                // Image at the top
                Container(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/images/wedding2u_logo.png',
                  ),
                ),

                SizedBox(height: 20.0),

                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      // Title
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                            fontSize: 36,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      SizedBox(height: 30.0),

                      // Form for validation
                      Form(
                        key: _formKey, // Add the form key here
                        child: Column(
                          children: <Widget>[
                            // Email Address
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Your Email',
                                icon: Icon(Icons.email),
                              ),
                              onChanged: (value) => email = value,
                              keyboardType: TextInputType.emailAddress,
                              validator: validateEmail, // Required
                            ),

                            SizedBox(height: 20.0),

                            // Password
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Password',
                                icon: Icon(Icons.lock),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  },
                                ),
                              ),
                              controller: _controller,
                              onChanged: (value) => password = value,
                              obscureText: !_isPasswordVisible, // Toggle visibility
                            ),

                            SizedBox(height: 30.0),

                            // Forgot Password Link
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ForgotPassword(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Forgot Password?",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 50.0),

                            // Sign In Button
                            Center(
                              child: Container(
                                width: 150,
                                child: ElevatedButton(
                                  onPressed: _submitLoginForm,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.pinkAccent,
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                  ),
                                  child: Text(
                                    "Sign In",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 70),

                // Sign Up Link
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, 'SignUpUserRoles');
                    },
                    child: Text(
                      "Don't have an account? Sign Up",
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
              ],
            ),
          ),

          // Loading spinner
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}

