import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quotes_app/fav_provider_model.dart';
import 'package:quotes_app/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => FavProviderModel())
        ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Motivational Quotes',
        home: SplashScreen(),
      ),
            
    );
  }
}
