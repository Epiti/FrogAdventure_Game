import 'package:adventure_game/adventure_game.dart';
import 'package:adventure_game/screens/main_menu.dart';
import 'package:adventure_game/widgets/overlays/pause_button.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

class PauseMenu extends StatelessWidget {
  static const String id = 'PauseMenu';
  final AdventureGame game;

  const PauseMenu({Key? key, required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 50.0), // all(8.0)
            child: Text(
              'Pause',
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
          ), // separes title from other text





          SizedBox(
            width: MediaQuery.of(context).size.width / 6,
            child: ElevatedButton(
              onPressed: () {
                if (game.playSounds) FlameAudio.play('click.wav', volume: game.soundVolume * 50);
                if (game.playSounds) FlameAudio.bgm.play('background.mp3');
                game.resumeEngine();
                game.overlays.remove(PauseMenu.id);
                game.overlays.add(PauseButton.id);
              },
              child: const Text('Resume'),
            ),
          ),


        SizedBox(
            width: MediaQuery.of(context).size.width / 6,
            child: ElevatedButton(
              onPressed: () {
                _showRestartConfirmationDialog(context);
              },
              child: const Text('Restart Game'),
            ),
          ),


          SizedBox(
            width: MediaQuery.of(context).size.width * 0.2,
            child: ElevatedButton(
              onPressed: () {
                if (game.playSounds) FlameAudio.bgm.play('background.mp3');
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




  
  void _showRestartConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Restart Game'),
          content: const Text('Are you sure you want to restart the game?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Restart'),
              onPressed: () {
                if (game.playSounds) FlameAudio.play('click.wav', volume: game.soundVolume * 50);
                if (game.playSounds) FlameAudio.bgm.play('background.mp3');
                game.reset();
                game.resumeEngine();
                game.overlays.remove(PauseMenu.id);
                game.overlays.add(PauseButton.id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }




}
