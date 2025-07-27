import 'dart:async';
import 'package:adventure_game/components/checkpoint.dart';
import 'package:adventure_game/components/chicken.dart';
import 'package:adventure_game/components/collision_block.dart';
import 'package:adventure_game/components/custom_hitbox.dart';
import 'package:adventure_game/components/fruits.dart';
import 'package:adventure_game/components/saw.dart';
import 'package:adventure_game/components/tools.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/services.dart';
import 'package:adventure_game/adventure_game.dart';




enum PlayerState{idle, running, jumping, falling, hit, appearing, disappear}      // different states of player (animations)





class Player extends SpriteAnimationGroupComponent with HasGameRef<AdventureGame>, KeyboardHandler,CollisionCallbacks {
 
 final double stepTime = 0.05;
 late final SpriteAnimation bougePas;             // create animation that do nothing
 late final SpriteAnimation moveAnimation;        // create animation that can move
 late final SpriteAnimation jumpingAnimation;
 late final SpriteAnimation fallingAnimation;
 late final SpriteAnimation hitAnimation;
 late final SpriteAnimation appearingAnimation;
 late final SpriteAnimation disappearAnimation;

 
 
 //Constructor
 Player({position, this.character =''}) : super(position: position);  // got the player's postion from spiteanimation 
 String character;



 final double _gravity = 9.8;
 final double _jumpForce = 300 ;  // 460 for mobile ?
 final double _terminalVelocity = 300;
 double horizontaleMovement = 0;             //deplacement of palyer
 double moveSpeed = 100;
 Vector2 startingPosition = Vector2.zero();
 Vector2 velocity = Vector2.zero();        // 0 on x and y
 bool isOnGround = false;
 bool hasJumped = false;
 bool gothit = false;
 bool reachCheckPoint = false;
 List<CollisionBlock> collisionBlocks= [];
 CustomHitbox hitbox = CustomHitbox(
  offsetX: 10, 
  offsetY: 4, 
  width: 14, 
  height: 28,
  );

   double fixedDeltaTime = 1 / 60;
   double accumulatedTime = 0;


 
  @override // OnLoad
  FutureOr<void> onLoad() {
    _loadAnimation();                    // create Loadanimation (Like a function) to load animation
    //debugMode = true;                   //TURN OF DUBUG MODE
    startingPosition = Vector2(position.x, position.y);


    add(RectangleHitbox(
     position: Vector2(hitbox.offsetX, hitbox.offsetX),
     size: Vector2(hitbox.width, hitbox.height),
    ));
    return super.onLoad();
  }


 @override        // updates frame each time
  void update(double dt) {
    accumulatedTime += dt;

    while(accumulatedTime >= fixedDeltaTime){

     if(!gothit && !reachCheckPoint){
    _updatePlayerState();
    _updatePlayerMovement(fixedDeltaTime);
    _checkHorizontalCollisions();
    _applyGravity(fixedDeltaTime);
    _checkVerticalCollision();
    }

    accumulatedTime -= fixedDeltaTime;
    }

    super.update(dt);
  }


  @override   // controls key movement
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontaleMovement = 0;
    final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA)||
     keysPressed.contains(LogicalKeyboardKey.arrowLeft);

    final isRightKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD)||
     keysPressed.contains(LogicalKeyboardKey.arrowRight);
    
    horizontaleMovement += isLeftKeyPressed ? -1 : 0;
    horizontaleMovement += isRightKeyPressed ? 1 : 0;
    hasJumped = keysPressed.contains(LogicalKeyboardKey.space);   // space to jump
  

    return super.onKeyEvent(event, keysPressed);
  }



// Player collision with objects

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    if(!reachCheckPoint){
      if(other is Fruit) other.collideWithPlayer();
      if(other is Saw) _respawn();
      if(other is Chicken) other.collideWithPlayer();
      if(other is Checkpoint && !reachCheckPoint) _reachCheckPoint();
    super.onCollision(intersectionPoints, other);
    }
    super.onCollisionStart(intersectionPoints, other);
  }







  

  //definition of BougePas and LoadAnimation
  void _loadAnimation() {
  bougePas =  _MyAnimation('Idle', 11);
  moveAnimation = _MyAnimation ('Run', 12);
  jumpingAnimation = _MyAnimation('Jump', 1);
  fallingAnimation = _MyAnimation('Fall', 1);
  hitAnimation = _MyAnimation('Hit', 7)..loop = false;
  appearingAnimation = _specialAnimation('Appearing', 7);
  disappearAnimation = _specialAnimation('Desappearing', 7);



   //List of all animations
  animations = {
    PlayerState.idle: bougePas,
    PlayerState.running: moveAnimation,
    PlayerState.jumping: jumpingAnimation,
    PlayerState.falling: fallingAnimation,
    PlayerState.hit: hitAnimation,
    PlayerState.appearing: appearingAnimation,
    PlayerState.disappear: disappearAnimation,

  }; // for Bougepas animation is idle. and running for moveanimation

  current = PlayerState.idle; // set the current state(to run or be idle)

  }



//Definition of MyAnimation for each animation
SpriteAnimation _MyAnimation(String State, int number_amount){
  return SpriteAnimation.fromFrameData(game.images.fromCache('Main Characters/$character/$State (32x32).png'),
   SpriteAnimationData.sequenced(
    amount: number_amount, 
    stepTime: stepTime, 
    textureSize: Vector2.all(32),
    ),
    );
}


//Definition of specialAnimation for each animation
SpriteAnimation _specialAnimation(String State, int number_amount){
  return SpriteAnimation.fromFrameData(game.images.fromCache('Main Characters/$State (96x96).png'),
   SpriteAnimationData.sequenced(
    amount: number_amount, 
    stepTime: stepTime, 
    textureSize: Vector2.all(96),
    loop: false,
    ),
    );
}




// move to left or right?
  void _updatePlayerState() {
    PlayerState playerState = PlayerState.idle;
    if(velocity.x < 0 && scale.x > 0){
      flipHorizontallyAroundCenter();
    } else if(velocity.x > 0 && scale.x < 0){
      flipHorizontallyAroundCenter();
    }
  // if move, make it runs
    if(velocity.x > 0 || velocity.x < 0) playerState = PlayerState.running;

    // if fall set to falling
    if(velocity.y >0) playerState = PlayerState.falling;

    // if jump set to jumping
    if(velocity.y < 0) playerState = PlayerState.jumping;

  
    current = playerState;
  }

  


  void _updatePlayerMovement(double dt) {

    if(hasJumped && isOnGround) _playerJump(dt);
     velocity.x  = horizontaleMovement * moveSpeed;
     position.x += velocity.x * dt;   // delta time (Updates frame every time)
  }

  void _playerJump(double dt) {
    if(game.playSounds) FlameAudio.play('jump.wav', volume: game.soundVolume * .5);  // * by .5 to lower the sound
    velocity.y = -_jumpForce;
    position.y += velocity.y * dt;
    isOnGround = false;
    hasJumped = false; 

  }
  


  void _checkHorizontalCollisions() {
    for(final block in collisionBlocks){
      if(!block.isPlatform){
        if(checkCollision(this, block)){
          if(velocity.x > 0){              // going to the right
            velocity.x = 0;
            position.x = block.x - hitbox.offsetX - hitbox.width;      // width of player
            break;
          }
          if(velocity.x < 0){
            velocity.x = 0;
            position.x = block.x + block.width + hitbox.width + hitbox.offsetX;
            break;
          }
        }
      }
    }
  }
  


  void _applyGravity(double dt) {
    velocity.y += _gravity;
    velocity.y = velocity.y.clamp(-_jumpForce, _terminalVelocity); // range of gravity 
    position.y += velocity.y * dt;
  }
  


  void _checkVerticalCollision() {
    for(final block in collisionBlocks){
      if(block.isPlatform){
        if(checkCollision(this, block)){
          if(velocity.y > 0){ 
            velocity.y = 0;
            position.y = block.y - hitbox.height - hitbox.offsetY;
            isOnGround= true;
            break;
          }

        }
        
      } else {
        if(checkCollision(this, block)){
          if(velocity.y > 0){   // if the player falls
            velocity.y = 0;
            position.y = block.y - hitbox.height - hitbox.offsetY;
            isOnGround= true;
            break;
          }
          if(velocity.y < 0){   // not going up
            velocity.y = 0;
            position.y = block.y + block.height - hitbox.offsetY;
          }
        }
      } 
    }
  }
  


  void _respawn() async {

        gameRef.ninjaSante -= 10;
        if(gameRef.ninjaSante < 0){
          gameRef.ninjaSante = 0;
    } 

    if(game.playSounds){
    FlameAudio.play('hithurt.wav', volume: game.soundVolume * 10);
    } 
    
    const canMoveDuration = Duration(microseconds: 400);
    gothit = true;
    current = PlayerState.hit;

    await animationTicker ?.completed;  // wait for animation to be completed and run the next one
    animationTicker ?.reset();
     scale.x= 1;  // player face right after hiting Saw
     position = startingPosition - Vector2.all(32);
     current = PlayerState.appearing;

    await animationTicker ?.completed;
    animationTicker ?.reset();
      velocity = Vector2.zero();
      position = startingPosition;
      _updatePlayerState();
      
      Future.delayed(canMoveDuration, () => gothit = false);
      
      
    }


       

  
  void _reachCheckPoint() async {
    reachCheckPoint = true;
    if(game.playSounds) {
      FlameAudio.play('nextLevel.wav', volume: game.soundVolume); 
    }
    if(scale.x > 0){
      position = position - Vector2.all(32);
    } else if(scale.x < 0){
      position = position + Vector2(32, -32);
    }
    current = PlayerState.disappear;


      await animationTicker ?.completed;
      animationTicker?.reset();

      reachCheckPoint = false;
      position = Vector2.all(-650);        // Diseappear out of screen


      const waitForNextLevel = Duration(seconds: 3);
      Future.delayed(waitForNextLevel,(){
      game.loadNextLevel();    //Next  level
      
    });

    }


    void collideWithEnemy(){
      _respawn();
    }
  

}