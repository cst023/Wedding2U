import 'package:flutter/material.dart';


class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, 'SignIn');
      },
      child: Scaffold(
        body: Stack(
          children: [
            // Fullscreen background image
            SizedBox.expand(
              child: Image.asset(
                'assets/images/wedding2u_landingpg.jpg', 
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
