import 'dart:async';

import 'package:adventure_game/adventure_game.dart';
import 'package:adventure_game/components/player.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Checkpoint extends SpriteAnimationComponent with HasGameRef<AdventureGame>, CollisionCallbacks  { //CollisionCallbacks detects collision
  Checkpoint({
    position, 
    size,
  }):super(position: position, size: size,
  );


 @override
  FutureOr<void> onLoad() {
   //debugMode = true; 
   add(RectangleHitbox(
    position: Vector2(5, 25),
    size: Vector2(20, 18),
    collisionType: CollisionType.passive, // only looks for active objects(collisions) 
   ));

    animation = SpriteAnimation.fromFrameData(game.images.fromCache('Items/Checkpoints/Checkpoint/Checkpoint (No Flag).png'),
     SpriteAnimationData.sequenced(
      amount: 1, 
      stepTime: 1, 
      textureSize: Vector2.all(64),    // 64 size of checkpoint animation
      ));
    return super.onLoad();
  }

 
  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    if(other is Player) _reachCheckPoint();   // if player hit Checkpoint do reachcheckpoint
    super.onCollisionStart(intersectionPoints, other);
  }
  

  void _reachCheckPoint() async {
    animation =  animation = SpriteAnimation.fromFrameData(game.images.fromCache('Items/Checkpoints/Checkpoint/Checkpoint (Flag Out) (64x64).png'),
     SpriteAnimationData.sequenced(
      amount: 26, 
      stepTime: 0.05, 
      textureSize: Vector2.all(64),    // 64 size of checkpoint animation
      loop: false,
      
      ),
      );

      await animationTicker ?.completed;  
      animation =  animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Items/Checkpoints/Checkpoint/Checkpoint (Flag Idle)(64x64).png'),
     SpriteAnimationData.sequenced(
      amount: 10, 
      stepTime: 0.05, 
      textureSize: Vector2.all(64),    
      
      ),
      );

  }

}