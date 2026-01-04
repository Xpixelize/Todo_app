import 'package:flutter/material.dart';
import 'package:todoapp/Screens/splash_screen.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
  DeviceOrientation.portraitDown,
  DeviceOrientation.portraitUp,
]);
  runApp(TODOAPP());
}

class TODOAPP extends StatelessWidget {
  const TODOAPP({super.key});

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:Scaffold(
        body: SplashScreen(),
      ) ,
    );
  }
}
