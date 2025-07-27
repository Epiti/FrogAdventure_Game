import 'package:flame/components.dart';

class CollisionBlock extends PositionComponent{
  bool isPlatform;
  CollisionBlock({
    postion, 
    size,
    this.isPlatform= false,

    }) : super (
      position: postion, 
      size: size,
      ){
       // debugMode = true;  // Turn on DEBUG MODE
      }
  
}