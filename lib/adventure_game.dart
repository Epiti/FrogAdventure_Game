import 'dart:async';
import 'package:adventure_game/components/jump_button.dart';
import 'package:adventure_game/screens/game_play.dart';
import 'package:adventure_game/widgets/overlays/pause_button.dart';
import 'package:adventure_game/widgets/overlays/pause_menu.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/input.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:adventure_game/components/player.dart';
import 'package:adventure_game/components/level.dart';





class AdventureGame extends FlameGame with 
HasKeyboardHandlerComponents, 
DragCallbacks, 
HasCollisionDetection, 
TapCallbacks {
  

  @override
  Color backgroundColor() => const Color(0xFF211F30);

 late CameraComponent cam;
 Player player = Player(character: 'Ninja Frog');       // add character in the game
 late JoystickComponent joystick;
 bool showControls = false;
 bool playSounds = true; // sound on/off
 double soundVolume = 1.0;
 int ninjaEnergy = 0;          // for score
 int ninjaSante = 100;
 List <String> levelNames = [
  'Level_04',
  'Level_000', 
  'Level_001', 
  'Level_01',
  'Level_02', 
  'Level_03',
  'Level_03A', 
  'Level_100'
  ];  // list of Levels
  
 int currentLevelIndex = 0;         // starts with first level                                                                                   




  @override
  FutureOr<void> onLoad() async {

    // Load all images into cache
    await images.loadAllImages();

    _loadLevel();                          // Load Different Levels

    
    
    if(showControls){
      addJoystick();                     //  joystick to the game
      add(JumpButton());
    }

    

    if(game.playSounds) FlameAudio.bgm.play('background.mp3');

  
    return super.onLoad();



  }
  


@override
  void update(double dt) {
    if(showControls){
      updateJoystick();
    }
    super.update(dt);
  }


 // change state on phone

     @override
  void lifecycleStateChange(AppLifecycleState state) {
   switch (state) {
     case AppLifecycleState.resumed:
       break;
     case AppLifecycleState.inactive:
     case AppLifecycleState.paused:
     case AppLifecycleState.detached:
      if(game.playSounds) FlameAudio.bgm.play('background.mp3', volume: game.soundVolume * 0);
     if(ninjaSante > 0){
        pauseEngine();
        overlays.remove(PauseButton.id);
        overlays.add(PauseMenu.id);
     }
       
       break;
       
     default:
   }
    super.lifecycleStateChange(state);
  }




  // RESET WHEN GAME OVER
  void reset(){
    ninjaSante = 100;    
    ninjaEnergy = 0;      
   // game.overlays.add(PauseButton.id);

     removeWhere((component) => component is Level);

    // Reload the initial level
      currentLevelIndex = 0;
    _loadLevel();

    
  }



   
  // definition of joystick
    void addJoystick() {
    joystick = JoystickComponent(
      priority: 10,
      knob: SpriteComponent(
      size:Vector2(50, 50),
      sprite: Sprite(
        images.fromCache('Jstick/Knob.png')
      ),
      ),

      
      knobRadius: 80, 
      background: SpriteComponent(
      size: Vector2(70, 70),
      sprite: Sprite(images.fromCache('Jstick/Joystick.png')),
     ),

        margin: const EdgeInsets.only(left : 5, bottom: 32),
    );

    add(joystick);
   
  }
  



  void updateJoystick() {
    switch (joystick.direction) {
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
      player.horizontaleMovement = -1;

        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
       player.horizontaleMovement = 1;
        
        break;
      default:
      player.horizontaleMovement = 0;
      break;
    }
  }
  



  void loadNextLevel(){
    removeWhere((component) => component is Level);

    if(currentLevelIndex < levelNames.length - 1){
      currentLevelIndex ++;
      _loadLevel();
      
    } else{ 
      //end of level go back to the first level
      currentLevelIndex = 0;
      _loadLevel();
    }
  }




  void _loadLevel() {
  Future.delayed(const Duration(seconds: 1), () {

  Level world =Level( 
  player: player,       
  levelName: levelNames [currentLevelIndex],       // add level in game
 ); 




    cam = CameraComponent.withFixedResolution( 
    world: world, 
    width: 640, 
    height: 360,
    );
    cam.viewfinder.anchor = Anchor.topLeft;

    addAll([cam, world]);  // add camera to look at the level

   
 });
 
             
  
  }





  
}
