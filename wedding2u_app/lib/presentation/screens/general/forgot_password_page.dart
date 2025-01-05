import 'package:flutter/material.dart';
import 'package:wedding2u_app/application/forgot_password.dart';
import 'package:wedding2u_app/data/firebase_auth_service.dart';
import 'package:wedding2u_app/utils/input_validation.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  final ForgotPasswordLogic _forgotPasswordLogic =
      ForgotPasswordLogic(FirebaseAuthService());
  String email = "";
  final TextEditingController _controller = TextEditingController();

  void _resetPassword() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await _forgotPasswordLogic.resetPassword(email);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Password reset email sent! Check your inbox."),
            backgroundColor: Colors.green,
          ),
        );
        _controller.clear();
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushNamed(context, 'SignIn');
          },
        ),
        title: const Text(
          'Forgot Password',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 50.0),

                const Center(
                  child: Text(
                    'Enter your email to reset password',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ),

                const SizedBox(height: 30.0),

                // Email input
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Your Email',
                    icon: Icon(Icons.email),
                  ),
                  onChanged: (value) => email = value,
                  keyboardType: TextInputType.emailAddress,
                  validator: validateEmail, // Required for validation
                  controller: _controller,
                ),

                const SizedBox(height: 50.0),

                // Reset Password Button
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _resetPassword,
                    child: const Text('Reset Password'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
