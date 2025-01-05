import 'package:flutter/material.dart';
import 'package:wedding2u_app/utils/input_validation.dart';
import 'package:wedding2u_app/presentation/screens/general/sign_in_page.dart';
import 'package:wedding2u_app/application/sign_up.dart';

class SignUp extends StatefulWidget {
  final String role;

  SignUp({required this.role});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Form Key
  String email = "";
  String password = "";
  String confirmPassword = "";
  String name = "";
  String phoneNumber = "";
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false; // To control the loading spinner

  final SignUpService _signUpService = SignUpService();

  void _submitRegisterForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Show spinner
      });

      try {
        // Call SignUpService
        await _signUpService.registerUser(
          email: email,
          password: password,
          name: name,
          phoneNumber: phoneNumber,
          role: widget.role,
        );

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Account created successfully'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to the Sign-In page after a short delay
        await Future.delayed(Duration(seconds: 2));

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SignIn(),
          ),
        );
      } catch (e) {
        // Handle errors (e.g., email already in use, weak password, etc.)
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
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey, // Assign the form key to the form
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Back Button
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () {
                        Navigator.pushNamed(context, 'SignUpUserRoles');
                      },
                    ),
                    SizedBox(height: 20.0),

                    // Title
                    Center(
                      child: Text(
                        'Sign Up as ${widget.role}',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 50.0),

                    // Name input
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Your Name',
                        icon: Icon(Icons.person),
                      ),
                      onChanged: (value) => name = value,
                      validator: validateName,
                    ),
                    SizedBox(height: 10.0),

                    // Phone Number input
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Your Phone Number',
                        icon: Icon(Icons.phone),
                      ),
                      onChanged: (value) => phoneNumber = value,
                      keyboardType: TextInputType.phone,
                      validator: validatePhone,
                    ),
                    SizedBox(height: 10.0),

                    // Email input
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Your Email',
                        icon: Icon(Icons.email),
                      ),
                      onChanged: (value) => email = value,
                      keyboardType: TextInputType.emailAddress,
                      validator: validateEmail,
                    ),
                    SizedBox(height: 10.0),

                    // Password input
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
                      onChanged: (value) => password = value,
                      obscureText: !_isPasswordVisible, // Toggle visibility
                      validator: validatePassword,
                    ),
                    SizedBox(height: 20.0),

                    // Confirm Password input
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        icon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isConfirmPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _isConfirmPasswordVisible =
                                  !_isConfirmPasswordVisible;
                            });
                          },
                        ),
                      ),
                      onChanged: (value) => confirmPassword = value,
                      obscureText: !_isConfirmPasswordVisible,
                      validator: (value) =>
                          validateConfirmPassword(value, password),
                    ),
                    SizedBox(height: 30.0),

                    // Sign Up Button
                    Center(
                      child: ElevatedButton(
                        onPressed: _submitRegisterForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pinkAccent,
                        ),
                        child: Text(
                          "Create an account",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(height: 220),

                    // Already have an account? Sign In Link
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, 'SignIn');
                      },
                      child: Center(
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
                  ],
                ),
              ),
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

