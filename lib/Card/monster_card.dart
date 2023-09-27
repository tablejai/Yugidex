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

class MainDeckMonsterCard extends MonsterCard {
  final int level;
  MainDeckMonsterCard(
      Image image,
      String name,
      MonsterCardType monsterCardType,
      MonsterAttribute attribute,
      MonsterType type,
      Bool isEffectMonster,
      this.level)
      : super(image, name, monsterCardType, attribute, type, isEffectMonster);
}

class PendulumMonsterCard extends MainDeckMonsterCard {
  final int pendulumScale;
  PendulumMonsterCard(
      Image image,
      String name,
      MonsterCardType monsterCardType,
      MonsterAttribute attribute,
      MonsterType type,
      Bool isEffectMonster,
      int level,
      this.pendulumScale)
      : super(image, name, monsterCardType, attribute, type, isEffectMonster,
            level);
}

class ExtraDeckMonsterCard extends MonsterCard {
  final String summonRequirement;
  ExtraDeckMonsterCard(
      Image image,
      String name,
      MonsterCardType monsterCardType,
      MonsterAttribute attribute,
      MonsterType type,
      Bool isEffectMonster,
      this.summonRequirement)
      : super(image, name, monsterCardType, attribute, type, isEffectMonster);
}

class XYZMonsterCard extends ExtraDeckMonsterCard {
  final int rank;
  XYZMonsterCard(
      Image image,
      String name,
      MonsterAttribute attribute,
      MonsterType type,
      Bool isEffectMonster,
      String summonRequirement,
      this.rank)
      : super(image, name, MonsterCardType.xyz, attribute, type,
            isEffectMonster, summonRequirement);
}

class LinkMonsterCard extends ExtraDeckMonsterCard {
  final int linkRating;
  LinkMonsterCard(
      Image image,
      String name,
      MonsterAttribute attribute,
      MonsterType type,
      Bool isEffectMonster,
      String summonRequirement,
      this.linkRating)
      : super(image, name, MonsterCardType.link, attribute, type,
            isEffectMonster, summonRequirement);
}
