enum CardType { monster, spell, trap }

class BaseCard {
  BaseCard(this.imageUrl, this.name, this.effectText, this.cardType);

  final String imageUrl;
  final String name;
  final String effectText;
  final CardType cardType;
}
