import 'dart:async';
import 'dart:ui';

import 'package:adventure_game/adventure_game.dart';
import 'package:adventure_game/components/player.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';

enum State{idle, run, hit }

class Chicken extends SpriteAnimationGroupComponent with HasGameRef<AdventureGame> , CollisionCallbacks {
  final double offNeg;
  final double offPos;
  

  Chicken({
    super.position, 
    super.size, 
    this.offNeg = 0, 
    this.offPos = 0,
    });

    static const stepTime = 0.5;
    static const tileSize = 16;
    static const runSpeed = 80;
    static const _bounceHeight = 260.0;
    final textureSize = Vector2(32, 34);
    Vector2 velocity = Vector2.zero();
    double rangeNeg = 0;
    double rangePos = 0;
    double moveDirection = 1;
    double targetDirection = -1;
    bool gotHit = false; // chicken got hit
    

    late final Player player; // This Player have reference of player (Main character)
   
  


    //  Animation for Chicken
    late final SpriteAnimation _idleAnimation;
    late final SpriteAnimation _runAnimation;
    late final SpriteAnimation _hitAnimation;


    @override
  FutureOr<void> onLoad() {
    //debugMode = true;
    player = game.player; // get player

    add( // for the degubMode
      RectangleHitbox(
        position: Vector2(4, 6),
        size: Vector2(24, 26),

    )
    );
    _loadAllAnimations();
    _calculateRange();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if(!gotHit){
       _updateState();
    _mouvement(dt);
    }
    super.update(dt);
  }
  

  // definition of animations
  void _loadAllAnimations() {
   _idleAnimation = _spriteAnimation('Idle', 13);
   _runAnimation = _spriteAnimation('Run', 14);
   _hitAnimation = _spriteAnimation('Hit', 15) ..loop = false;

  animations = {
    State.idle :_idleAnimation,
    State.run : _runAnimation,
    State.hit : _hitAnimation,
  };

  current = State.idle; // state by default

  }



 SpriteAnimation _spriteAnimation(String state, int amount){
  return SpriteAnimation.fromFrameData(game.images.fromCache('Enemies/Chicken/$state (32x34).png'), 
  SpriteAnimationData.sequenced(
    amount: amount, 
    stepTime: stepTime, 
    textureSize: textureSize
    ));
 }
 

 // The range that chicken can see player 
  void _calculateRange() {

   rangeNeg = position.x - offNeg * tileSize;   
   rangePos = position.x + offPos * tileSize;

  }
  
  void _mouvement(dt) {
    velocity.x = 0;
    double playerOffset = (player.scale.x > 0) ? 0 : -player.width;  // player face left or right 
    double chickenOffset = (scale.x > 0) ? 0 : -width;  

    if(playerInRange()){
     // when player is in range
     targetDirection = (player.x + playerOffset < position.x + chickenOffset) ? -1 : 1; //chicken catch player
     velocity.x = targetDirection * runSpeed ;
    }
     
    moveDirection = lerpDouble(moveDirection, targetDirection, 0.1) ?? 1;  // does something over a period of time (use 1 if it fails)
      
    position.x += velocity.x * dt;

  }

  bool playerInRange(){
    double playerOffset = (player.scale.x > 0) ? 0 : -player.width;

    // check if the player is in the chicken's range
    return player.x + playerOffset >= rangeNeg &&
           player.x + playerOffset <= rangePos &&

           // the top of player and buttom of player are above the top of chicken
           player.y + player.height > position.y &&
           // top of player above the buttom of chicken
           player.y < position.y + height;

  }
  
  void _updateState() {
    current = (velocity.x != 0) ? State.run : State.idle;
    // if move to right and face right 
    if((moveDirection > 0 && scale.x > 0) || (moveDirection < 0 && scale.x < 0)){
      flipHorizontallyAroundCenter(); // flip the cchicken
    }
  }

  void collideWithPlayer() {

    // if player falls and  buttom of player > top chicken when collide
    if(player.velocity.y > 0 && player.y + player.height > position.y){
      if(game.playSounds){
        FlameAudio.play('ennemyJump.wav', volume: game.soundVolume);
      }
        gotHit = true; 
        current = State.hit;
        player.velocity.y = - _bounceHeight; // make chicken bounce
        removeFromParent();
    }
     else{
      player.collideWithEnemy();
    }

  }
  
 
}