import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:story_view/story_view.dart';
import 'package:viewstories/widgets/custom_gradient_btn.dart';
import 'package:viewstories/widgets/show_snackbar.dart';
import '/services/services.dart';
import '/utils/constants.dart';
import '/blocs/auth/auth_bloc.dart';
import '/models/views.dart';
import '/models/app_user.dart';
import '/models/tag_user.dart';
import '/widgets/loading_indicator.dart';
import '/repositories/story/story_repository.dart';
import '/screens/view-story/bloc/view_story_bloc.dart';
import '/models/story.dart';
import '/screens/comments/comments_screen.dart';
import '/screens/others-profile/others_profile_screen.dart';
import '/widgets/avatar_widget.dart';
import '/widgets/display_image.dart';
import '/widgets/gradient_circle_button.dart';
import 'report-cubit/report_cubit.dart';
import 'widgets/report_tile.dart';

class StoryScreenArgs {
  final String? authorId;

  StoryScreenArgs({required this.authorId});
}

class StoryScreen extends StatefulWidget {
  static const routeName = '/story-screen';
  final String? authorId;

  const StoryScreen({
    Key? key,
    required this.authorId,
  }) : super(key: key);

  static Route route({required StoryScreenArgs args}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => BlocProvider(
        create: (context) => ViewStoryBloc(
            authorId: args.authorId,
            storyRepository: context.read<StoryRepository>())
          ..add(LoadStories()),
        child: StoryScreen(
          authorId: args.authorId,
        ),
      ),
    );
  }

  @override
  _StoryScreenState createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen>
    with SingleTickerProviderStateMixin {
  void _viewTaggedUserSheet(
    BuildContext context, {
    required List<TagUser?> taggedUsers,
    required Story? story,
  }) async {
    final _storyRepo = context.read<StoryRepository>();
    final result = await showModalBottomSheet<bool>(
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
          height: 200.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 12.0),
              Container(
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
              const SizedBox(height: 10.0),
              FutureBuilder<List<AppUser?>>(
                  future: _storyRepo.getTaggedUsers(taggUsers: taggedUsers),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return SizedBox(
                        height: 150.0,
                        child: ListView.builder(
                          itemCount: taggedUsers.length,
                          itemBuilder: (context, index) {
                            final user = snapshot.data?[index];
                            return Row(
                              children: [
                                AvatarWidget(
                                    size: 42.0, imageUrl: user?.profilePic),
                                const SizedBox(width: 10.0),
                                Text(
                                  user?.username ?? 'N/A',
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
                      );
                    }
                    return const LoadingIndicator();
                  })
            ],
          ),
        );
      },
    );

    if (result == null) {
      _storyController.play();
    }

    print('Model sheet result $result');
  }

  void _viewPostViews(
    BuildContext context, {
    required String? storyId,
  }) async {
    final result = await showModalBottomSheet<bool>(
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
              Container(
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
                      return const LoadingIndicator();
                    }),
              ),
            ],
          ),
        );
      },
    );

    if (result == null) {
      _storyController.pause();
    }
  }

  Future<void> _share({
    required String? storyUrl,
    required String? text,
  }) async {
    try {
      _storyController.pause();
      if (storyUrl != null) {
        await ShareService.shareImage(storyUrl: storyUrl, text: text);
      }

      _storyController.play();

      // _storyController.pause();
      // if (storyUrl != null) {
      //   final response = await http.get(Uri.parse(storyUrl));

      //   final bytes = response.bodyBytes;
      //   final temp = await getTemporaryDirectory();
      //   final imagePath = '${temp.path}/image.jpg';
      //   File(imagePath).writeAsBytesSync(bytes);
      //   print('Image path --$imagePath');

      //   await Share.shareFiles([imagePath], text: text ?? '');
      //   _storyController.play();
      // }
    } catch (error) {
      print('Error sharing story');
    }
  }

  @override
  void dispose() {
    _storyController.dispose();

    super.dispose();
  }

  Future _addStoryView({required String? storyId}) async {
    try {
      print('Story id for view  ----$storyId');

      print('App user id --- ${context.read<AuthBloc>().state.user?.uid}');
      print('imported usr is --- ${widget.authorId}');
      final _appUserId = context.read<AuthBloc>().state.user?.uid;
      final _authorId = widget.authorId;

      if (_appUserId != _authorId) {
        await context.read<StoryRepository>().addStoryView(
            userId: context.read<AuthBloc>().state.user?.uid, storyId: storyId);
      }
    } catch (error) {
      print('Error adding stories ${error.toString()}');
    }
  }

  final _storyController = StoryController();
  int _currentIndex = 0;
  List<StoryItem> _storyItems = [];

  Future<void> _reportPost(BuildContext context,
      {required Story? story}) async {
    try {
      showModalBottomSheet<void>(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          return BlocProvider(
            create: (context) => ReportCubit(
              storyRepository: context.read<StoryRepository>(),
              authBloc: context.read<AuthBloc>(),
            ),
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0XFF060609),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28.0),
                  topRight: Radius.circular(28.0),
                ),
              ),
              height: 340.0,
              child: BlocConsumer<ReportCubit, ReportState>(
                listener: (context, state) {},
                builder: (context, state) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15.0,
                      vertical: 15.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        //const SizedBox(height: 10.0),
                        const Text(
                          'Report Post',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 5.0),
                        const Text(
                          'Let\'s us if someting wrong is happening',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10.0),

                        Theme(
                          data: ThemeData(
                            //here change to your color
                            unselectedWidgetColor: Colors.white,
                          ),
                          child: SizedBox(
                            height: 205.0,
                            child: ListView.builder(
                              itemCount: reports.length,
                              itemBuilder: (context, index) {
                                return ReportTile(
                                  value: reports[index].reportPost,
                                  label: reports[index].reportString,
                                  onTap: (value) => context
                                      .read<ReportCubit>()
                                      .changeReport(value, reports[index]),
                                  reportPost: state.reportPost,
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),

                        Center(
                          child: CustomGradientBtn(
                              onTap: () {
                                context.read<ReportCubit>().reportPost(
                                    report: state.report,
                                    storyId: story?.storyId);
                                Navigator.of(context).pop();
                                ShowSnackBar.showSnackBar(context,
                                    title: 'Story Reported ');
                              },
                              label: 'Submit'),
                        ),
                        const SizedBox(height: 5.0),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        },
      );
    } catch (error) {
      print('Error in report post ${error.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final _canvas = MediaQuery.of(context).size;

    return BlocConsumer<ViewStoryBloc, ViewStoryState>(
      listener: (context, state) {
        if (state.status == ViewStoryStatus.succuss) {
          print('Stories from stor screen ${state.stories}');
          if (state.stories.isEmpty) {
            Navigator.of(context).pushReplacementNamed(
                OthersProfileScreen.routeName,
                arguments:
                    OthersProfileScreenArgs(othersProfileId: widget.authorId));
          } else {
            if (state.status == ViewStoryStatus.succuss) {
              _storyItems = state.stories
                  .map(
                    (story) => StoryItem(
                      Container(
                        height: double.infinity,
                        width: double.infinity,
                        decoration: gradientBackground,
                        // color: Colors.black,
                        // height: double.infinity,
                        // width: double.infinity,
                        child: DisplayImage(
                          imageUrl: story?.storyUrl,
                          fit: BoxFit.contain,
                        ),
                      ),
                      duration: const Duration(seconds: 5),
                    ),
                  )
                  .toList();

              _currentIndex = state.currentIndex;
            }
          }
        }
      },
      builder: (context, state) {
        if (state.status == ViewStoryStatus.succuss) {
          final stories = state.stories;
          if (stories.isEmpty) {
            return Container(
              decoration: gradientBackground,
              child: const LoadingIndicator(),
            );
          }

          return Scaffold(
            body: Stack(
              children: [
                StoryView(
                  onStoryShow: (s) async {
                    await _addStoryView(
                        storyId: stories[_currentIndex]?.storyId);
                    int index = _storyItems.indexOf(s);
                    print('Curent index $index');

                    if (index > 0) {
                      setState(() {
                        _currentIndex = index;
                      });

                      // context
                      //     .read<ViewStoryBloc>()
                      //     .add(PageIndexChanged(index: index));
                    }
                  },
                  onComplete: () => Navigator.of(context).pop(),
                  onVerticalSwipeComplete: (direction) {
                    if (direction == Direction.down) {
                      Navigator.pop(context);
                    }
                  },
                  storyItems: _storyItems,
                  controller: _storyController,
                ),
                Positioned(
                  top: 60.0,
                  child: Row(
                    children: [
                      const SizedBox(width: 10.0),
                      GradientCircleButton(
                        size: 40.0,
                        onTap: () => Navigator.of(context).pop(),
                        icon: Icons.arrow_back,
                      ),
                      const SizedBox(width: 15.0),
                      const Icon(Icons.location_on, color: Colors.white),
                      const SizedBox(width: 5.0),
                      SizedBox(
                        width: _canvas.width * 0.63,
                        child: Text(
                          stories[_currentIndex]?.location ?? 'N/A',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                      const SizedBox(width: 7.0),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pushNamed(
                            OthersProfileScreen.routeName,
                            arguments: OthersProfileScreenArgs(
                                othersProfileId:
                                    stories[_currentIndex]?.author?.uid)),
                        child: const Icon(
                          Icons.account_circle,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
                Positioned(
                  bottom: 80.0,
                  right: 12.0,
                  child: Column(
                    children: [
                      GradientCircleButton(
                        size: 40.0,
                        onTap: () => _share(
                            storyUrl: stories[_currentIndex]?.storyUrl,
                            text: stories[_currentIndex]?.caption),
                        icon: Icons.share,
                      ),

                      const SizedBox(height: 15.0),
                      GradientCircleButton(
                        size: 40.0,
                        onTap: () {
                          _storyController.pause();
                          _viewPostViews(context,
                              storyId: stories[_currentIndex]?.storyId);
                        },
                        icon: Icons.visibility,
                      ),
                      //  ViewsButton(storyId: stories[_currentIndex]?.storyId),
                      const SizedBox(height: 15.0),
                      GradientCircleButton(
                        size: 40.0,
                        onTap: () {
                          if (stories[_currentIndex]?.storyId != null) {
                            _storyController.pause();
                            _viewTaggedUserSheet(
                              context,
                              taggedUsers:
                                  stories[_currentIndex]?.taggedUser ?? [],
                              story: stories[_currentIndex],
                            );
                          }
                        },
                        icon: Icons.group,
                      ),
                      const SizedBox(height: 15.0),
                      GradientCircleButton(
                        size: 40.0,
                        onTap: () => Navigator.of(context).pushNamed(
                          CommentsScreen.routeName,
                          arguments: CommentsScreenArgs(
                            storyId: stories[_currentIndex]?.storyId,
                            storyAuthorId: stories[_currentIndex]?.author?.uid,
                          ),
                        ),
                        icon: Icons.chat_bubble,
                      ),
                      const SizedBox(height: 15.0),
                      GradientCircleButton(
                        size: 40.0,
                        onTap: () {
                          _storyController.pause();
                          _reportPost(context, story: stories[_currentIndex]);
                        },
                        icon: Icons.report,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        return Container(
          decoration: gradientBackground,
          child: const LoadingIndicator(),
        );
      },
    );
  }
}
