import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quotes_app/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(milliseconds: 500), () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Image.asset('assets/images/quote_icon.png', height: MediaQuery.sizeOf(context).height * 0.2,)),
          Text('QUOTES', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: MediaQuery.sizeOf(context).height * 0.03),)
        ],
      ),
    );
  }
}
