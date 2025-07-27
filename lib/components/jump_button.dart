import 'dart:async';

import 'package:adventure_game/adventure_game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';

class JumpButton extends SpriteComponent with HasGameRef<AdventureGame>, TapCallbacks{
  JumpButton();

  final margin = 12 ;  // 32
  final buttonSize = 80;  // 64


  @override
  FutureOr<void> onLoad() {
  sprite = Sprite(game.images.fromCache('Jstick/JumpButton.png'));
  position = Vector2(
    game.size.x -margin - buttonSize + 16,
    game.size.y -margin - buttonSize ,
     );
    priority = 10;
    return super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    game.player.hasJumped = true;
    super.onTapDown(event);
  }

  @override
  void onTapUp(TapUpEvent event) {
     game.player.hasJumped = false; // when up button release, it stops jump
    super.onTapUp(event);
  }
}