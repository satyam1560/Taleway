import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '/blocs/auth/auth_bloc.dart';
import '/models/app_user.dart';
import '/models/comment.dart';
import '/models/failure.dart';
import '/models/story.dart';
import '/repositories/comment/comment_repository.dart';

part 'comments_event.dart';
part 'comments_state.dart';

class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  final CommentsRepository _commentsRepository;
  final AuthBloc _authBloc;
  // TODO: change story to storyId
  final String? _storyId;
  final String? _storyAuthorId;
  StreamSubscription<List<Future<Comment?>>>? _commentsSubscription;

  CommentsBloc({
    required CommentsRepository commentsRepository,
    required AuthBloc authBloc,
    required String? storyId,
    required String? storyAuthorId,
  })  : _commentsRepository = commentsRepository,
        _storyId = storyId,
        _authBloc = authBloc,
        _storyAuthorId = storyAuthorId,
        super(CommentsState.initial()) {
    print('Story id -- $storyId');
    on<CommentsEvent>((event, emit) async {
      if (event is CommentsFetchComments) {
        try {
          emit(state.copyWith(status: CommentsStatus.loading));
          _commentsSubscription?.cancel();
          _commentsSubscription = _commentsRepository
              .getPostComments(storyId: event.storyId)
              .listen((comments) async {
            final allComments = await Future.wait(comments);
            add(CommentsUpdateComments(comments: allComments));
          });
          emit(state.copyWith(status: CommentsStatus.loaded));
        } catch (error) {
          emit(
            state.copyWith(
              status: CommentsStatus.error,
              failure: const Failure(
                message: 'We were unable to load this post\'s comments.',
              ),
            ),
          );
        }
      } else if (event is CommentsUpdateComments) {
        emit(state.copyWith(comments: event.comments));
      } else if (event is CommentsPostComment) {
        emit(state.copyWith(status: CommentsStatus.submitting));
        try {
          final author =
              AppUser.emptyUser.copyWith(uid: _authBloc.state.user?.uid);
          final comment = Comment(
            storyId: _storyId,
            author: author,
            content: event.content,
            date: DateTime.now(),
          );

          await _commentsRepository.createComment(
              currentUserId: _authBloc.state.user?.uid,
              comment: comment,
              storyAuthorId: _storyAuthorId);

          emit(state.copyWith(status: CommentsStatus.loaded));
        } catch (err) {
          emit(
            state.copyWith(
              status: CommentsStatus.error,
              failure: const Failure(
                message: 'Comment failed to post',
              ),
            ),
          );
        }
      } else if (event is DeleteComment) {
        await _commentsRepository.deleteComment(
            storyId: _storyId, commentId: event.commentId);
      }
    });
  }

  @override
  Future<void> close() {
    _commentsSubscription?.cancel();
    return super.close();
  }
}
