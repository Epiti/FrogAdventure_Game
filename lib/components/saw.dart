import 'dart:async';

import 'package:adventure_game/adventure_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';


class Saw extends SpriteAnimationComponent with HasGameRef<AdventureGame>{
  
  final bool isVertical;
  final double offsetNegative;
  final double offsetPositive;
  
  Saw({
    this.isVertical = false,
    this.offsetNegative = 0,
    this.offsetPositive = 0,
    position, 
    size, 
    }) :super (
      position: position, 
      size: size,
      );

 static const double sawSpeed = 0.03; // Rotation speed 
 static const moveSpeed = 50;
 static const titedSize = 16;
 double moveDirection = 1;
 double rangeNeg =0 ;
 double rangePositive = 0;

 @override
  FutureOr<void> onLoad() {

   priority= -1;
   add(CircleHitbox());
   
   
  if(isVertical){
    rangeNeg = position.y - offsetNegative * titedSize;
    rangePositive = position.y + offsetPositive * titedSize;
  } else {
    rangeNeg = position.x - offsetNegative * titedSize;
    rangePositive = position.x + offsetPositive * titedSize;
  }

   animation = SpriteAnimation.fromFrameData(game.images.fromCache('Traps/Saw/On (38x38).png'), 
   SpriteAnimationData.sequenced(
    amount: 8, 
    stepTime: sawSpeed, 
    textureSize: Vector2.all(38),
    ));
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if(isVertical){
      _moveVertically(dt);
    } else {
      _moveHorizontally(dt);
    }
    super.update(dt);
  }
  

  void _moveVertically(double dt) {
    if(position.y >= rangePositive){
      moveDirection = -1;
    } else if(position.y <= rangeNeg){
      moveDirection = 1;
    }
    position.y += moveDirection * moveSpeed * dt;
  }
  
  void _moveHorizontally(double dt) {
    if(position.x >= rangePositive){
      moveDirection = -1;
    } else if(position.x <= rangeNeg) {
      moveDirection = 1;
    }
   
 position.x += moveDirection * moveSpeed * dt;
  }
}