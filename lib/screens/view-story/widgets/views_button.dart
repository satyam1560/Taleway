import 'package:flutter/material.dart';
import '/models/views.dart';
import '/repositories/story/story_repository.dart';
import '/widgets/avatar_widget.dart';
import '/widgets/gradient_circle_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewsButton extends StatelessWidget {
  final String? storyId;

  const ViewsButton({Key? key, required this.storyId}) : super(key: key);

  void _viewTaggedUserSheet(
    BuildContext context, {
    required String? storyId,
  }) {
    showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0XFF060609),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(28.0),
              topRight: Radius.circular(28.0),
            ),
          ),
          height: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 12.0),
              InkWell(
                onTap: () => Navigator.pop(context),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      stops: [
                        0.02,
                        0.1,
                        0.5,
                      ],
                      colors: [
                        Colors.purple,
                        Colors.purple,
                        Colors.pink,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(70.0),
                  ),
                  height: 10.0,
                  width: 91.0,
                  //color: Colors.red,
                ),
              ),
              const SizedBox(height: 10.0),
              SizedBox(
                height: 220,
                child: FutureBuilder<Views?>(
                    future: context
                        .read<StoryRepository>()
                        .getStoriesViews(storyId: storyId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        final view = snapshot.data;
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Icon(
                                  Icons.visibility,
                                  color: Colors.white,
                                  size: 16.0,
                                ),
                                const SizedBox(width: 10.0),
                                Text(
                                  '${view?.viewsCount ?? 0}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 20.0),
                              ],
                            ),
                            SizedBox(
                              height: 200.0,
                              child: ListView.builder(
                                itemCount: view?.viewers.length,
                                itemBuilder: (context, index) {
                                  final viewer = view?.viewers[index];
                                  // final username = story?.taggedUser?[index];
                                  return Row(
                                    children: [
                                      AvatarWidget(
                                        size: 42.0,
                                        imageUrl: viewer?.profilePic,
                                      ),
                                      const SizedBox(width: 10.0),
                                      Text(
                                        viewer?.username ?? 'N/A',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 1.1,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GradientCircleButton(
      size: 40.0,
      onTap: () => _viewTaggedUserSheet(context, storyId: storyId),
      icon: Icons.visibility,
    );
  }
}
