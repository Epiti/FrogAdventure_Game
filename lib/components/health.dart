import 'package:adventure_game/adventure_game.dart';
import 'package:adventure_game/widgets/overlays/game_over_menu.dart';
import 'package:adventure_game/widgets/overlays/pause_button.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';


class Health extends TextComponent with HasGameRef<AdventureGame>{
  late int sante = 100;
  
   @override 
  Future<void> onLoad() async{
    await super.onLoad();
    sante = gameRef.ninjaSante;
    text = 'Your Life: $sante';
    position =Vector2(400.0, 17.0);
    
  }

   @override 
  void update(double dt) {
  super.update(dt);
  sante = gameRef.ninjaSante;
  text = 'Health: $sante%';
  
  if(gameRef.ninjaSante == 0){
          gameRef.ninjaSante = 0;
           if(game.playSounds) FlameAudio.bgm.play('background.mp3', volume: game.soundVolume * 0);
          if(game.playSounds) FlameAudio.play('gameover.wav', volume: game.soundVolume);
          game.pauseEngine();
          game.overlays.remove(PauseButton.id);
          game.overlays.add(GameOverMenu.id);


  }
 
  }

  

}