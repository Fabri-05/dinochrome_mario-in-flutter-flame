import 'package:flame/collisions.dart' show RectangleHitbox, CollisionCallbacks;
import 'package:flame/components.dart';
import '../mario_game.dart';
import 'mario.dart'; // Torna indietro di una cartella per comunicare con il gioco

class Goomba extends SpriteComponent with HasGameRef<MarioGame>, CollisionCallbacks {
  static const double speed = 270; // Velocità di spostamento

  Goomba() : super(size: Vector2(40, 40)); // Dimensione del Goomba

  @override
  Future<void> onLoad() async {
    super.onLoad();
    
    // Carica l'immagine fissa del Goomba
    sprite = await gameRef.loadSprite('goomba.png');
    
    // Lo posiziona fuori dallo schermo a destra, allineato al terreno
    position = Vector2(gameRef.size.x, gameRef.size.y - 90);
    
    // Aggiunge la scatola di collisione invisibile attorno al Goomba
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    // Muove il Goomba verso sinistra sottraendo pixel sulla X
    position.x -= speed * dt;

    // Se esce dallo schermo a sinistra, lo elimina per non intasare la memoria
    if (position.x < -size.x) {
      removeFromParent();
    }
  }

  // Rileva lo scontro fisico
  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    
    // Se l'oggetto colpito è proprio la classe Mario, lancia il Game Over
    if (other is Mario) {
      gameRef.triggerGameOver();
    }
  }
}
