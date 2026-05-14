class Comment {
  final String id;
  final String productId;
  final String userName;
  final String userImage;
  final double rating;
  final String text;
  final DateTime createdAt;

  const Comment({
    required this.id,
    required this.productId,
    required this.userName,
    required this.userImage,
    required this.rating,
    required this.text,
    required this.createdAt,
  });
}
