import 'package:adventure_game/adventure_game.dart';
import 'package:adventure_game/screens/main_menu.dart';
import 'package:adventure_game/widgets/overlays/pause_button.dart';
import 'package:adventure_game/widgets/overlays/pause_menu.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';


class GameOverMenu extends StatelessWidget{

  static const String id = 'GameOverMenu';
  final AdventureGame game;

  const GameOverMenu({Key? key, required this.game}) :super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(

        mainAxisAlignment: MainAxisAlignment.center,
          children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 50.0),  //all(8.0)
          child: Text('Game Over',
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
        ),  // separes title from other text


         SizedBox(
           width: MediaQuery.of(context).size.width/6,
           child: ElevatedButton(
            onPressed: () {
              if(game.playSounds) FlameAudio.play('click.wav', volume: game.soundVolume * 50);
              if(game.playSounds) FlameAudio.bgm.play('background.mp3');
              game.overlays.remove(GameOverMenu.id);
              game.reset();
              game.resumeEngine();
              game.overlays.remove(PauseMenu.id);
              game.overlays.add(PauseButton.id);
            
            } ,
            child: const Text('Restart'),
           ),
         ),


         
         SizedBox(
          width: MediaQuery.of(context).size.width/6,
           child: ElevatedButton(
            onPressed: () {

              game.overlays.remove(PauseMenu.id);
            


              Navigator.of(context).pushReplacement(
               MaterialPageRoute(
               builder: (context) => const MainMenu(),
                ),
              );
            },
            child: const Text('Back to Menu'),
           ),
         ),
          ],
        
      ),
    );
  }
}