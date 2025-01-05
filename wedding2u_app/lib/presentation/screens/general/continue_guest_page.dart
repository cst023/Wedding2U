import 'package:flutter/material.dart';
import 'package:wedding2u_app/application/guest_list_controller.dart';
import 'package:wedding2u_app/presentation/screens/guest/accept_reject_screen.dart';
import 'package:wedding2u_app/presentation/screens/guest/home_screen.dart';

class ContinueGuest extends StatefulWidget {
  @override
  _ContinueGuestState createState() => _ContinueGuestState();
}

class _ContinueGuestState extends State<ContinueGuest> {
  String phoneNumber = "";
  String invitationCode = "";
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Phone number validation
  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    } else if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  // Invitation code validation
  String? _validateInvitationCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the invitation code';
    }
    return null;
  }
/*
  void _validateAndProceed() async {
  if (_formKey.currentState?.validate() ?? false) {
    setState(() {
      _isLoading = true;
    });

    try {
      final controller = GuestListController();
      final isValid = await controller.validateGuestAndCode(
        invitationCode: invitationCode,
        phoneNumber: phoneNumber,
      );

      if (isValid) {
       Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AcceptRejectScreen(invitationCode: invitationCode, guestPhone: phoneNumber),
          ),
        );
      } else {
        // Show error if validation fails
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Invalid phone number or invitation code."),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
*/
void _validateAndProceed() async {
  if (_formKey.currentState?.validate() ?? false) {
    setState(() {
      _isLoading = true;
    });

    try {
      final controller = GuestListController();
      final isValid = await controller.validateGuestAndCode(
        invitationCode: invitationCode,
        phoneNumber: phoneNumber,
      );

      if (isValid) {
        // Fetch guest details to check RSVP status
        final guestDetails = await controller.getGuestDetails(
          invitationCode: invitationCode,
          phoneNumber: phoneNumber,
        );

        if (guestDetails['rsvp_status'] == "Confirmed") {
          // Navigate to HomeScreen for confirmed guests
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(
                invitationCode: invitationCode,
              ),
            ),
          );
        } else {
          // Navigate to Accept/Reject Screen for pending or declined guests
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AcceptRejectScreen(
                invitationCode: invitationCode,
                guestPhone: phoneNumber,
              ),
            ),
          );
        }
      } else {
        // Show error if validation fails
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Invalid phone number or invitation code."),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          :Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 40.0),

              // Logo
              Container(
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/images/wedding2u_logo.png',
                  height: 100,
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
                        'Continue As Guest',
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
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          // Phone Number Field
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Phone Number',
                              icon: Icon(Icons.phone),
                            ),
                            keyboardType: TextInputType.phone,
                            onChanged: (value) => phoneNumber = value,
                            validator: _validatePhoneNumber,
                          ),

                          SizedBox(height: 20.0),

                          // Invitation Code Field
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Invitation Code',
                              icon: Icon(Icons.code),
                            ),
                            onChanged: (value) => invitationCode = value,
                            validator: _validateInvitationCode,
                          ),

                          SizedBox(height: 20.0),

                          // Enter Button
                          Center(
                            child: Container(
                              width: 150,
                              child: ElevatedButton(
                                onPressed: _validateAndProceed,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.pinkAccent,
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                ),
                                child: Text(
                                  "Enter",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 70),

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

              SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}

