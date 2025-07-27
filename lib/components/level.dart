import 'dart:async';
import 'package:adventure_game/adventure_game.dart';
import 'package:adventure_game/components/background_tile.dart';
import 'package:adventure_game/components/checkpoint.dart';
import 'package:adventure_game/components/chicken.dart';
import 'package:adventure_game/components/collision_block.dart';
import 'package:adventure_game/components/fruits.dart';
import 'package:adventure_game/components/health.dart';
import 'package:adventure_game/components/player.dart';
import 'package:adventure_game/components/saw.dart';
import 'package:adventure_game/components/score.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';






class Level extends World with HasGameRef<AdventureGame>{

Level({required this.levelName, required this.player}); // level constructor
final String levelName;
final Player player;
late TiledComponent level;
int ninjaEnergy = 0; // for score
int ninjaSante = 100;

List<CollisionBlock> collisionBlocks =[];

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load('$levelName.tmx', Vector2.all(16)); //make level


   add(level); // add level
   add(Score()); //add score
   add(Health()); // Lfe in game
  
   



  _scrollingBackground();
  _spwaningObjects();
  _addCollisions();


  
    
    return super.onLoad();
  }
  


  void _scrollingBackground() {
    final BackgroundLayer = level.tileMap.getLayer('background');
   

    if(BackgroundLayer != null){
      final backgroundColor = BackgroundLayer.properties.getValue('BackgroundColor');
      final backgroundTile = BackgroundTile(
       color: backgroundColor ?? 'Gray',
       position: Vector2(0, 0),
     );
      add(backgroundTile);

      
      }

      
      
  }

  


  // take objects from titled
  void _spwaningObjects() {
    
    final PointLayer = level.tileMap.getLayer<ObjectGroup>('StartPoint');  // get object (startpoint) from tiled
    
    if(PointLayer != null){

      for(final StartPoint in PointLayer.objects) // look for each Startpoint in pointLayer if yes get object
     {
      switch (StartPoint.class_) {
        case 'Player':  // class Player from tiled
        player.position  = Vector2(StartPoint.x, StartPoint.y);
        player.scale.x = 1;
        add(player); //add player in level
          break;
          
        case 'Fruit':
        final fruit= Fruit(
          fruit: StartPoint.name ,  // pass the fruit in the game
          position: Vector2(StartPoint.x, StartPoint.y),
          size: Vector2(StartPoint.width, StartPoint.height),


        );
        add(fruit); // add fruit
        break;
    
        case 'Saw':   // first create fie Saw in file saw
        final izVertical = StartPoint.properties.getValue('isVertical');
        final offsetNeg = StartPoint.properties.getValue('offsetNegative');
        final offsetPos = StartPoint.properties.getValue('offsetPositive');
        

        final saw = Saw(
          isVertical: izVertical,   // pass the value
          offsetNegative: offsetNeg,
          offsetPositive: offsetPos,
          position: Vector2(StartPoint.x, StartPoint.y),
          size: Vector2(StartPoint.width, StartPoint.height),
          
        );
        add(saw); // add 


        break;

        case 'CheckPoint' :
        final ckpoint = Checkpoint (
          position: Vector2(StartPoint.x, StartPoint.y),
          size: Vector2(StartPoint.width, StartPoint.height),
        );
        add(ckpoint);

        break;

        case'Chicken' :
         final offNeg = StartPoint.properties.getValue('offNeg');   //get the proprieties of chicken
         final offPos = StartPoint.properties.getValue('offPos');
      

         final chicken = Chicken(
          position: Vector2(StartPoint.x, StartPoint.y),
          size: Vector2(StartPoint.width, StartPoint.height),
          offNeg: offNeg,
          offPos: offPos,
        
         );
         add(chicken);

        break;


        default:
      }
     }
    }
  }
  



  void _addCollisions() {
      final collisionLayer= level.tileMap.getLayer<ObjectGroup>('Kollisions');    // get object (Collision) fron tiled

     if (collisionLayer != null) {
     for(final Kollisions in collisionLayer.objects){
        switch (Kollisions.class_) {
          case 'Platform':
          final Platform = CollisionBlock(
            postion: Vector2(Kollisions.x, Kollisions.y),
            size: Vector2(Kollisions.width, Kollisions.height),
            isPlatform: true,

          );
          collisionBlocks.add(Platform);
          add(Platform);

            
            break;
          default:
          final block = CollisionBlock(
            postion: Vector2(Kollisions.x, Kollisions.y),
            size: Vector2(Kollisions.width, Kollisions.height),

          );
          collisionBlocks.add(block);
          add(block);
        }
      }
     }
      
    player.collisionBlocks= collisionBlocks;
  }
}