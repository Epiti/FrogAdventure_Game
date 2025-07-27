import 'package:adventure_game/adventure_game.dart';
import 'package:adventure_game/widgets/overlays/game_over_menu.dart';
import 'package:adventure_game/widgets/overlays/pause_button.dart';
import 'package:adventure_game/widgets/overlays/pause_menu.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

AdventureGame game = AdventureGame();

class GamePlay extends StatelessWidget {

const GamePlay({Key? key}) :super(key: key);

  @override
  Widget build(BuildContext context) {
     
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async => false,   // on phone press back dont exit the game
        child: GameWidget(
          initialActiveOverlays: const [PauseButton.id],  // pause button when game starts 
          overlayBuilderMap: {

            PauseButton.id:(BuildContext context, AdventureGame game) =>  PauseButton(
              
              game: game,
            ),
            PauseMenu.id:(BuildContext context, AdventureGame game) =>  PauseMenu(
              game: game,
            ),
           GameOverMenu.id:(BuildContext context, AdventureGame game) =>  GameOverMenu(
              game: game,
            ),
          
          },
          game: kDebugMode? AdventureGame(): game),
      ),
    );
  }


 
}