import 'dart:ffi';

import 'base_card.dart';
import "package:flutter/material.dart";

// TODO: Think of a better name for this kinds of stuff (Kinda colliding with moster type)
enum MonsterCardType {
  normal,
  effect,
  fusion,
  ritual,
  synchron,
  xyz,
  pendulum,
  link,
}

enum MonsterAttribute { dark, divine, earth, fire, light, water, wind }

enum MonsterType {
  // TODO: Extract the complete list of monster types
  dragon,
  spellcaster,
  warrior
}

class MonsterCard extends BaseCard {
  MonsterCard(Image image, String name, this.monsterCardType, this.attribute,
      this.type, this.isEffectMonster)
      : super(image, name, CardType.monster);

  final MonsterCardType monsterCardType;
  final MonsterAttribute attribute;
  final MonsterType type;
  final Bool isEffectMonster;
}
