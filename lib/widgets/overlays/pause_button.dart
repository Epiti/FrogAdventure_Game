import 'package:adventure_game/adventure_game.dart';
import 'package:adventure_game/widgets/overlays/pause_menu.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

class PauseButton extends StatelessWidget{
  static const String id = 'PauseButton';
  final AdventureGame game;

  const PauseButton({Key? key, required this.game}) :super(key: key);
  
  @override
  Widget build(BuildContext context) {
  return Align(
   alignment: const Alignment(0.0, -0.87), 
   child: TextButton(
    child: const Icon(
      Icons.pause_rounded,
     color: Colors.cyan,
    ) ,
  onPressed:() {
    game.pauseEngine();  // Pause the game
    game.overlays.add(PauseMenu.id);
    game.overlays.remove(PauseButton.id);
     if(game.playSounds) FlameAudio.play('click.wav', volume: game.soundVolume * 50);
     if(game.playSounds) FlameAudio.bgm.play('background.mp3', volume: game.soundVolume * 0);
  },
    ),
  );
  }
}