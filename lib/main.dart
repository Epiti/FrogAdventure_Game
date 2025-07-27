import 'package:adventure_game/screens/main_menu.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   await Flame.device.fullScreen();
   await Flame.device.setLandscape();

 
  runApp(
     MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
              brightness: Brightness.dark,
              fontFamily: 'BungeeInline',
              scaffoldBackgroundColor: const Color.fromARGB(255, 41, 136, 147),
      ),

      home: const MainMenu(),
    ),
   
      );





}



