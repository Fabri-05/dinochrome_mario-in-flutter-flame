import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import '../mario_game.dart'; // Torna indietro di una cartella per comunicare con il gioco

// Estende SpriteAnimationComponent per poter gestire sequenze di immagini (animazioni)
class Mario extends SpriteAnimationComponent with HasGameRef<MarioGame>, CollisionCallbacks {
  static const double gravity = 1400;   // Forza di gravità
  static const double jumpForce = -550; // Spinta verso l'alto (valore negativo)
  
  double velocityY = 0;       // Velocità verticale attuale
  bool isGrounded = true;     // Vero se Mario si trova a terra
  late double groundY;        // Coordinata Y del pavimento

  // Contenitori in cui salvare le memorie delle animazioni
  late SpriteAnimation runningAnimation;
  late SpriteAnimation jumpingAnimation;

  Mario() : super(size: Vector2(50, 60)); // Dimensione fisica del personaggio

    @override
  Future<void> onLoad() async {
    super.onLoad();

    // 1. Carica i due singoli sprite per la corsa
    final run1 = await gameRef.loadSprite('standingmario.png');
    final run2 = await gameRef.loadSprite('mariorunning.png');

    // 2. CORRETTO: Usa SpriteAnimation() per liste di SpriteAnimationFrame
    runningAnimation = SpriteAnimation(
      [
        SpriteAnimationFrame(run1, 0.15),
        SpriteAnimationFrame(run2, 0.15),
      ],
    );

    // 3. Carica lo sprite fisso del salto (ha un solo fotogramma)
    final jumpSprite = await gameRef.loadSprite('mario_jump.png');
    
    // CORRETTO: Anche qui usa SpriteAnimation() standard
    jumpingAnimation = SpriteAnimation(
      [
        SpriteAnimationFrame(jumpSprite, 1.0),
      ],
    );

    // Imposta l'animazione iniziale di Mario (ad esempio la corsa o l'attesa)
    animation = runningAnimation;


    // Allinea Mario sopra il livello del suolo del paesaggio
    groundY = gameRef.size.y - 110;
    position = Vector2(60, groundY);
    
    // Aggiunge la scatola di collisione invisibile attorno a Mario
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Calcola la fisica di caduta se Mario è a mezz'aria
    if (!isGrounded) {
      velocityY += gravity * dt;
      position.y += velocityY * dt;

      // Se tocca il suolo, interrompe la caduta e riattiva i piedi che corrono
      if (position.y >= groundY) {
        position.y = groundY;
        velocityY = 0;
        isGrounded = true;
        animation = runningAnimation; // Ripristina l'animazione della corsa
      }
    }
  }

  // Attiva il salto e cambia lo sprite grafico
  void jump() {
    if (isGrounded) {
      velocityY = jumpForce;
      isGrounded = false;
      animation = jumpingAnimation; // Cambia l'immagine impostando quella del salto
    }
  }

  // Resetta lo stato di Mario in caso di nuova partita
  void resetPosition() {
    position.y = groundY;
    velocityY = 0;
    isGrounded = true;
    animation = runningAnimation; // Torna a correre
  }
}
