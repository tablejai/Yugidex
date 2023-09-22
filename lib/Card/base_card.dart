import "package:flutter/material.dart";

enum CardType { monster, spell, trap }

class BaseCard {
  BaseCard(this.image, this.name, this.cardType);

  final Image image;
  final String name;
  final CardType cardType;
}
