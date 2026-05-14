class Product {
  final String id;
  final String name;
  final double price;
  final String category;
  final String image;
  final double rating;
  final int reviews;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.image,
    this.rating = 0.0,
    this.reviews = 0,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}