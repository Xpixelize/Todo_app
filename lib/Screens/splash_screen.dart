
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todoapp/Screens/dasbroad_screen.dart';
import 'package:todoapp/Themes/colours.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
@override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3),(){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context)=> DasbroadScreen()
      //     ));
          ));
    });

  }

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      body: Center(
        child: Column(
          children: [
            // top padding
            SizedBox(
              height: 200,
            ),
            // app logo splash
            Lottie.asset('assets/animations/logo.json'),
            SizedBox(
             height: 200,
            ),
            Center(
              child: Column(
                children: [
                  Text(
                    "Powered By Xpixelized",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColours.primary,
                    ),
                    ),
                    Text(
                      "Made with ❤️ in India",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColours.secondary,
                      ),
                    )
                ],
              ))

          ],
        ),
      ),
    );
  }
}