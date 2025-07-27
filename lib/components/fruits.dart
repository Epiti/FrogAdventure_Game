import 'dart:async';

import 'package:adventure_game/adventure_game.dart';
import 'package:adventure_game/components/custom_hitbox.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';

class Fruit extends SpriteAnimationComponent with HasGameRef <AdventureGame>, CollisionCallbacks{
  final String fruit;
  Fruit({
  this.fruit= 'Apple', 
  position,  
  size,
  }) :super (
    position: position, 
    size: size,
    );

  final double stepTime = 0.05;
  final hitbox= CustomHitbox(
  offsetX: 10, 
  offsetY: 10, 
  width: 12, 
  height: 12,
  );
  bool collected = false;

  @override
  FutureOr<void> onLoad() {
    debugMode = false;  //debug on
    priority= -1; // fruit behind the player
    add(RectangleHitbox(
      position: Vector2(hitbox.offsetX, hitbox.offsetY),
      size: Vector2(hitbox.width, hitbox.height),
      collisionType: CollisionType.passive,
    ));
    animation = SpriteAnimation.fromFrameData(game.images.fromCache('Items/Fruits/$fruit.png'), 
    SpriteAnimationData.sequenced(
      amount: 17, 
      stepTime: stepTime, 
      textureSize: Vector2.all(32)),
      );
    return super.onLoad();
  }
  
  
  void collideWithPlayer() async { 
     if(!collected){
     collected = true;  // runs once
     if(game.playSounds) {
       FlameAudio.play('getFruit.wav', volume: game.soundVolume);
     } 
     animation = SpriteAnimation.fromFrameData(
     game.images.fromCache('Items/Fruits/Collected.png'), 
     SpriteAnimationData.sequenced(
      amount: 6, 
      stepTime: stepTime, 
      textureSize: Vector2.all(32),
      loop: false),
      );

      await animationTicker ?.completed;
      removeFromParent();
      gameRef.ninjaEnergy++;  // Score up

     }
     
    

  }
}