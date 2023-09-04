import 'package:uuid/uuid.dart';
import '/utils/constants.dart';
import '/widgets/gradient_circle_button.dart';

import '/screens/comments/widgets/comment_tile.dart';
import '/repositories/comment/comment_repository.dart';
import '/blocs/auth/auth_bloc.dart';
import '/widgets/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/comments_bloc.dart';

class CommentsScreenArgs {
  final String? storyId;
  final String? storyAuthorId;

  const CommentsScreenArgs({
    required this.storyId,
    required this.storyAuthorId,
  });
}

class CommentsScreen extends StatefulWidget {
  static const String routeName = '/comments';
  const CommentsScreen({Key? key}) : super(key: key);

  static Route route({required CommentsScreenArgs args}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) {
        return BlocProvider(
          create: (_) => CommentsBloc(
            commentsRepository: context.read<CommentsRepository>(),
            authBloc: context.read<AuthBloc>(),
            storyId: args.storyId,
            storyAuthorId: args.storyAuthorId,
          )..add(CommentsFetchComments(storyId: args.storyId)),
          child: const CommentsScreen(),
        );
      },
    );
  }

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _authBloc = context.read<AuthBloc>();
    return BlocConsumer<CommentsBloc, CommentsState>(
      listener: (context, state) {
        if (state.status == CommentsStatus.error) {
          showDialog(
            context: context,
            builder: (context) => ErrorDialog(content: state.failure.message),
          );
        }
      },
      builder: (context, state) {
        return Container(
          decoration: gradientBackground,
          child: Scaffold(
            backgroundColor: Colors.transparent,

            //appBar: AppBar(title: const Text('Comments')),
            body: Padding(
              padding: const EdgeInsets.symmetric(
                ///  horizontal: 15.0,
                vertical: 20.0,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                    child: Row(
                      children: [
                        GradientCircleButton(
                          onTap: () => Navigator.of(context).pop(),
                          icon: Icons.arrow_back,
                        ),
                        const SizedBox(width: 14.0),
                        const Text(
                          'Comments',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.1,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 60.0),
                      itemCount: state.comments.length,
                      itemBuilder: (BuildContext context, int index) {
                        final comment = state.comments[index];
                        return _authBloc.state.user?.uid == comment?.author?.uid
                            ? Dismissible(
                                direction: DismissDirection.endToStart,
                                onDismissed: (_) => context
                                    .read<CommentsBloc>()
                                    .add(DeleteComment(
                                        commentId: comment?.commentId)),
                                background: SizedBox(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: const [
                                      Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 20.0)
                                    ],
                                  ),
                                ),
                                key: Key(
                                    comment?.commentId ?? const Uuid().v4()),
                                child: CommentTile(comment: comment),
                              )
                            : CommentTile(comment: comment);
                      },
                    ),
                  ),
                ],
              ),
            ),
            bottomSheet: Container(
              color: Colors.grey.shade700,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (state.status == CommentsStatus.submitting)
                      const LinearProgressIndicator(),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            style: const TextStyle(color: Colors.white),
                            controller: _commentController,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration.collapsed(
                              fillColor: Colors.grey.shade700,
                              filled: true,
                              hintText: 'Write a comment...',
                              hintStyle: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.send, color: Colors.white),
                          onPressed: () {
                            final content = _commentController.text.trim();
                            if (content.isNotEmpty) {
                              FocusScope.of(context).unfocus();
                              context
                                  .read<CommentsBloc>()
                                  .add(CommentsPostComment(content: content));
                              _commentController.clear();
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
