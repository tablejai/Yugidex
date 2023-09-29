import 'package:flutter/material.dart';

import 'base_card.dart';

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

// TODO: Complete this map here
Map monsterCardTypeEnumToString = {
  MonsterCardType.normal: "Normal",
  MonsterCardType.effect: "Effect"
};

enum MonsterAttribute { dark, divine, earth, fire, light, water, wind }

enum MonsterType {
  // TODO: Extract the complete list of monster types
  dragon,
  spellcaster,
  warrior
}

Map monsterTypeEnumToString = {
  MonsterType.dragon: "Dragon",
  MonsterType.spellcaster: "Spellcaster",
};

class MonsterCard extends BaseCard {
  MonsterCard(
      String imageUrl,
      String name,
      this.monsterCardType,
      this.attribute,
      this.type,
      this.isEffectMonster,
      this.atk,
      this.def,
      String effectText,
      this.systemValue)
      : super(imageUrl, name, effectText, CardType.monster);

  final int systemValue;
  final MonsterCardType monsterCardType;
  final MonsterAttribute attribute;
  final MonsterType type;
  final bool isEffectMonster;
  final int atk;
  final int def;
}

class MainDeckMonsterCard extends MonsterCard {
  MainDeckMonsterCard(
      String imageUrl,
      String name,
      MonsterCardType monsterCardType,
      MonsterAttribute attribute,
      MonsterType type,
      bool isEffectMonster,
      int atk,
      int def,
      String effectText,
      int systemValue)
      : super(imageUrl, name, monsterCardType, attribute, type, isEffectMonster,
            atk, def, effectText, systemValue);
}

class PendulumMonsterCard extends MainDeckMonsterCard {
  final int pendulumScale;
  PendulumMonsterCard(
      String imageUrl,
      String name,
      MonsterCardType monsterCardType,
      MonsterAttribute attribute,
      MonsterType type,
      bool isEffectMonster,
      int atk,
      int def,
      String effectText,
      int systemValue,
      this.pendulumScale)
      : super(imageUrl, name, monsterCardType, attribute, type, isEffectMonster,
            atk, def, effectText, systemValue);
}

class ExtraDeckMonsterCard extends MonsterCard {
  final String summonRequirement;
  ExtraDeckMonsterCard(
      String imageUrl,
      String name,
      MonsterCardType monsterCardType,
      MonsterAttribute attribute,
      MonsterType type,
      bool isEffectMonster,
      int atk,
      int def,
      String effectText,
      int systemValue,
      this.summonRequirement)
      : super(imageUrl, name, monsterCardType, attribute, type, isEffectMonster,
            atk, def, effectText, systemValue);
}

class XYZMonsterCard extends ExtraDeckMonsterCard {
  XYZMonsterCard(
      String imageUrl,
      String name,
      MonsterAttribute attribute,
      MonsterType type,
      bool isEffectMonster,
      String summonRequirement,
      int atk,
      int def,
      String effectText,
      int systemValue)
      : super(
            imageUrl,
            name,
            MonsterCardType.xyz,
            attribute,
            type,
            isEffectMonster,
            atk,
            def,
            effectText,
            systemValue,
            summonRequirement);
}

class LinkMonsterCard extends ExtraDeckMonsterCard {
  LinkMonsterCard(
    String imageUrl,
    String name,
    MonsterAttribute attribute,
    MonsterType type,
    bool isEffectMonster,
    String summonRequirement,
    int atk,
    int def,
    String effectText,
    int systemValue,
  ) : super(
            imageUrl,
            name,
            MonsterCardType.link,
            attribute,
            type,
            isEffectMonster,
            atk,
            def,
            effectText,
            systemValue,
            summonRequirement);
}

Image getMonsterSystemLogo(MonsterCard inputCard) {
  if (inputCard is LinkMonsterCard) {
    return Image.asset("images/MonsterCard/Systems/LevelStar.png");
  } else if (inputCard is XYZMonsterCard) {
    return Image.asset("images/MonsterCard/Systems/RankStar.png");
  } else {
    return Image.asset("images/MonsterCard/Systems/LevelStar.png");
  }
}

Image getMonsterAttributeImage(MonsterCard inputCard) {
  Map attributeToImg = {
    MonsterAttribute.fire:
        Image.asset("images/MonsterCard/Attributes/Fire.png"),
    MonsterAttribute.water:
        Image.asset("images/MonsterCard/Attributes/Water.png"),
    MonsterAttribute.earth:
        Image.asset("images/MonsterCard/Attributes/Earth.png"),
    MonsterAttribute.wind:
        Image.asset("images/MonsterCard/Attributes/Wind.png"),
    MonsterAttribute.light:
        Image.asset("images/MonsterCard/Attributes/Light.png"),
    MonsterAttribute.dark:
        Image.asset("images/MonsterCard/Attributes/Dark.png"),
    MonsterAttribute.divine:
        Image.asset("images/MonsterCard/Attributes/Divine.png")
  };
  return attributeToImg[inputCard.attribute];
}
