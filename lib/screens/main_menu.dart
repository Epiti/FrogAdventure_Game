import 'dart:io';

import 'package:adventure_game/screens/game_play.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class MainMenu extends StatelessWidget {

const MainMenu({Key? key}) :super(key: key);


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 50.0),  //all(8.0)
          child: Text('WELCOME TO FROGVENTURE',
          style: TextStyle(
            
            fontSize: 35, 
            shadows: [
              Shadow(
                blurRadius: 20.0,
                color: Color.fromARGB(255, 210, 218, 219),
                offset: Offset(0, 0),
              )
            ],
            ),
          ),
        ),// separes title from other text


         SizedBox(
           width: MediaQuery.of(context).size.width/6,
           child: ElevatedButton(
            onPressed: () {
              if(game.playSounds) FlameAudio.play('click.wav', volume: game.soundVolume * 50);

              Navigator.of(context).pushReplacement(
               MaterialPageRoute(
                builder: (context) => const GamePlay(),
                ),
              );
            } ,
            child: const Text('Play'),
           ),
         ),





         SizedBox(
           width: MediaQuery.of(context).size.width/6,
           child: ElevatedButton(
            onPressed: () {
              // For Options
            } ,
            child: const Text('Options'),
           ),
         ),




         
         SizedBox(
          width: MediaQuery.of(context).size.width/6,
           child: ElevatedButton(
            onPressed: () {
              _showExitConfirmationDialog(context);
            },
            child: const Text('Exit')
           ),
         ),
          ],
        ),
      ),
    );
  }



   void _showExitConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Exit Game'),
          content: const Text('Are you sure you want to exit the game?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            
            TextButton(
              child: const Text('Exit'),
              onPressed: () {
                if (Platform.isWindows || Platform.isMacOS) {
                  exit(0); // Terminate the app on desktop
                } else {
                  SystemNavigator.pop(); // Close the app on mobile
                }
              },
            ),
          ],
        );
      },
    );
  }







}