import "package:flutter/material.dart";

enum CardType { monster, spell, trap }

class Card {
  const Card({required this.image, required this.type, required this.name});

  final Widget image;
  final CardType type;
  final String name;
}
