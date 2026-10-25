import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'components/mario.dart';
import 'components/goomba.dart';

class MarioGame extends FlameGame with TapCallbacks, HasCollisionDetection {
  late Mario mario;
  late TextComponent scoreText;
  late TextComponent gameOverText;

  double obstacleTimer = 0;
  double score = 0;
  bool isGameOver = false;

    MarioGame() {
    images.prefix = ''; // Azzera il prefisso automatico "assets/images/" di Flame
  }
  
  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Sfondo del paesaggio di Mario
    final backgroundImage = await loadSprite('mariocastle_bg.jpg');
    add(
      SpriteComponent(
        sprite: backgroundImage,
        size: size,
        position: Vector2(0, 0),
      ),
    );

    // Aggiungiamo Mario
    mario = Mario();
    add(mario);

    // Testo del Punteggio
    scoreText = TextComponent(
      text: 'SCORE: 0',
      position: Vector2(size.x - 150, 40),
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 24,
          color: Colors.white,
          fontWeight: FontWeight.bold,
          backgroundColor: Colors.black38,
        ),
      ),
    );
    add(scoreText);

    // Testo di Game Over
    gameOverText = TextBoxComponent(
      text: 'GAME OVER\nTocca per riprovare',
      anchor: Anchor.center,
      position: size / 2,
      align: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 32,
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
      boxConfig: TextBoxConfig(
        growingBox: true,
      )
    );
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    if (isGameOver) {
      resetGame();
    } else {
      mario.jump();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isGameOver) return;

    // Incremento punteggio
    score += dt * 10;
    scoreText.text = 'SCORE: ${score.toInt()}';

    // Generazione Goomba ogni 2 secondi
    obstacleTimer += dt;
    if (obstacleTimer > 2.0) {
      add(Goomba());
      obstacleTimer = 0;
    }
  }

  void triggerGameOver() {
    isGameOver = true;
    add(gameOverText);
    pauseEngine();
  }

  void resetGame() {
    isGameOver = false;
    score = 0;
    obstacleTimer = 0;
    scoreText.text = 'SCORE: 0';
    
    remove(gameOverText);
    children.whereType<Goomba>().forEach((goomba) => goomba.removeFromParent());
    
    mario.resetPosition();
    resumeEngine();
  }
}
// TODO Implement this library.