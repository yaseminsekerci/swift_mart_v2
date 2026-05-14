import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swift_mart/domain/entities/comment.dart';
import 'package:swift_mart/domain/entities/product.dart';
import 'package:swift_mart/presentation/cubit/comments_cubit.dart';

class CommentsPage extends StatefulWidget {
  final Product product;

  const CommentsPage({super.key, required this.product});

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final _commentController = TextEditingController();
  double _selectedRating = 5.0;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitComment() {
    if (_commentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen bir yorum yazınız')),
      );
      return;
    }

    final comment = Comment(
      id: 'c_${DateTime.now().millisecondsSinceEpoch}',
      productId: widget.product.id,
      userName: 'Kullanıcı',
      userImage:
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
      rating: _selectedRating,
      text: _commentController.text,
      createdAt: DateTime.now(),
    );

    context.read<CommentsCubit>().addComment(widget.product.id, comment);
    _commentController.clear();
    _selectedRating = 5.0;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Yorumunuz eklendi')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ürün Yorumları'),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<CommentsCubit, Map<String, List<Comment>>>(
              builder: (context, comments) {
                final productComments =
                    comments[widget.product.id] ?? [];

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: productComments.length,
                  itemBuilder: (context, index) {
                    final comment = productComments[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.shade200,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundImage:
                                    NetworkImage(comment.userImage),
                                radius: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      comment.userName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        ...List.generate(
                                          5,
                                          (i) => Icon(
                                            Icons.star,
                                            size: 14,
                                            color: i <
                                                    comment.rating
                                                        .toInt()
                                                ? const Color(0xFFFFB800)
                                                : Colors.grey.shade300,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          comment.rating.toStringAsFixed(1),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close,
                                    color: Colors.red, size: 20),
                                onPressed: () {
                                  context
                                      .read<CommentsCubit>()
                                      .removeComment(
                                        widget.product.id,
                                        comment.id,
                                      );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            comment.text,
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${comment.createdAt.day}.${comment.createdAt.month}.${comment.createdAt.year}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Satın aldınız mı? Yorum yapın',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text('Puanı: '),
                    const SizedBox(width: 8),
                    ...List.generate(
                      5,
                      (i) => GestureDetector(
                        onTap: () {
                          setState(() => _selectedRating = (i + 1).toDouble());
                        },
                        child: Icon(
                          Icons.star,
                          size: 28,
                          color: i < _selectedRating.toInt()
                              ? const Color(0xFFFFB800)
                              : Colors.grey.shade300,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _commentController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Yorumunuzu yazın...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _submitComment,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: const Text('Yorumu Gönder'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
