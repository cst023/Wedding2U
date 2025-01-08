import 'package:flutter/material.dart';
import 'package:wedding2u_app/presentation/screens/general/forgot_password_page.dart';
import 'package:wedding2u_app/utils/input_validation.dart';
import 'package:wedding2u_app/application/sign_in.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

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
  final TextEditingController _controller = TextEditingController();

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
          const SnackBar(
            content: Text('Signed in successfully'),
            backgroundColor: Colors.green,
          ),
        );

        await Future.delayed(const Duration(seconds: 1));

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
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 40.0),

                // Image at the top
                Container(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/images/wedding2u_logo.png',
                  ),
                ),

                const SizedBox(height: 20.0),

                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      // Title
                      Container(
                        alignment: Alignment.center,
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                            fontSize: 36,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 30.0),

                      // Form for validation
                      Form(
                        key: _formKey, // Add the form key here
                        child: Column(
                          children: <Widget>[
                            // Email Address
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Your Email',
                                icon: Icon(Icons.email),
                              ),
                              onChanged: (value) => email = value,
                              keyboardType: TextInputType.emailAddress,
                              validator: validateEmail, // Required
                            ),

                            const SizedBox(height: 20.0),

                            // Password
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Password',
                                icon: const Icon(Icons.lock),
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
                              obscureText:
                                  !_isPasswordVisible, // Toggle visibility
                            ),

                            const SizedBox(height: 30.0),

                            // Forgot Password Link
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ForgotPassword(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "Forgot Password?",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 50.0),

                            // Sign In Button
                            Center(
                              child: SizedBox(
                                width: 150,
                                child: ElevatedButton(
                                  onPressed: _submitLoginForm,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(
                                        0xFF222D52), // Updated color
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                  ),
                                  child: const Text(
                                    "Sign In",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 70),

                // Sign Up Link
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, 'SignUpUserRoles');
                    },
                    child: const Text(
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
              ],
            ),
          ),

          // Loading spinner
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
