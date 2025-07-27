import 'package:adventure_game/adventure_game.dart';
import 'package:flame/components.dart';

class Score extends TextComponent with HasGameRef<AdventureGame>{
  late String score;

  @override 
  Future<void> onLoad() async{
    await super.onLoad();
    score = gameRef.ninjaEnergy.toString();
    text = 'Your Score: $score';
    position =absoluteCenter;
    
  
  }

  @override 
  void update(double dt) {
  super.update(dt);
  score = gameRef.ninjaEnergy.toString();
  text = 'Your Score: $score';
  
 
  }
}