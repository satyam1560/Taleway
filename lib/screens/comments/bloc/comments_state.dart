part of 'comments_bloc.dart';

enum CommentsStatus { initial, loading, loaded, submitting, error }

class CommentsState extends Equatable {
  // final Story? story;
  final List<Comment?> comments;
  final CommentsStatus status;
  final Failure failure;

  const CommentsState({
    // required this.story,
    required this.comments,
    required this.status,
    required this.failure,
  });

  factory CommentsState.initial() {
    return const CommentsState(
      // story: null,
      comments: [],
      status: CommentsStatus.initial,
      failure: Failure(),
    );
  }

  @override
  List<Object?> get props => [comments, status, failure];

  CommentsState copyWith({
    Story? story,
    List<Comment?>? comments,
    CommentsStatus? status,
    Failure? failure,
  }) {
    return CommentsState(
      // story: story ?? this.story,
      comments: comments ?? this.comments,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
