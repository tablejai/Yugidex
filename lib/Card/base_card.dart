enum CardType { monster, spell, trap }

class BaseCard {
  BaseCard(this.imageUrl, this.name, this.cardType);

  final String imageUrl;
  final String name;
  final CardType cardType;
}
