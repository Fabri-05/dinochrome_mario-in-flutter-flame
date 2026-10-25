import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'mario_game.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: GameWidget.controlled(gameFactory: () => MarioGame()),
      ),
    ),
  );
}
