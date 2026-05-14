import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swift_mart/domain/entities/comment.dart';

class CommentsCubit extends Cubit<Map<String, List<Comment>>> {
  CommentsCubit() : super({});

  void addComment(String productId, Comment comment) {
    final comments = Map<String, List<Comment>>.from(state);
    if (!comments.containsKey(productId)) {
      comments[productId] = [];
    }
    comments[productId] = [...comments[productId]!, comment];
    emit(comments);
  }

  void removeComment(String productId, String commentId) {
    final comments = Map<String, List<Comment>>.from(state);
    if (comments.containsKey(productId)) {
      comments[productId] = comments[productId]!
          .where((c) => c.id != commentId)
          .toList();
    }
    emit(comments);
  }

  List<Comment> getProductComments(String productId) {
    return state[productId] ?? [];
  }
}
