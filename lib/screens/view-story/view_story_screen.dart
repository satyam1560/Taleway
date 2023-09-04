import 'package:flutter/material.dart';
import '/widgets/custom_gradient_btn.dart';
import '/widgets/show_snackbar.dart';
import '/screens/view-story/report-cubit/report_cubit.dart';
import '/utils/constants.dart';
import '/models/tag_user.dart';
import '/widgets/loading_indicator.dart';
import '/models/app_user.dart';
import '/screens/view-story/bloc/view_story_bloc.dart';
import '/screens/others-profile/others_profile_screen.dart';
import '/blocs/auth/auth_bloc.dart';
import '/repositories/story/story_repository.dart';
import '/screens/view-story/widgets/views_button.dart';
import '/widgets/avatar_widget.dart';
import '/screens/comments/comments_screen.dart';
import '/models/story.dart';
import '/widgets/display_image.dart';
import '/widgets/gradient_circle_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'widgets/report_tile.dart';
import 'widgets/share_button.dart';

class ViewStoryScreenArgs {
  final Story? story;

  const ViewStoryScreenArgs({required this.story});
}

class ViewStoryScreen extends StatefulWidget {
  final Story? story;
  static const String routeName = '/view-story';
  const ViewStoryScreen({
    Key? key,
    required this.story,
  }) : super(key: key);

  static Route route({required ViewStoryScreenArgs? args}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => MultiBlocProvider(
        providers: [
          BlocProvider<ViewStoryBloc>(
            create: (_) => ViewStoryBloc(
                storyRepository: context.read<StoryRepository>(),
                authorId: context.read<AuthBloc>().state.user?.uid),
          ),
        ],
        child: ViewStoryScreen(
          story: args?.story,
        ),
      ),
    );
  }

  @override
  State<ViewStoryScreen> createState() => _ViewStoryScreenState();
}

class _ViewStoryScreenState extends State<ViewStoryScreen> {
  Future<void> _reportPost(BuildContext context) async {
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
                                    storyId: widget.story?.storyId);
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
  void initState() {
    addStoryView();
    super.initState();
  }

  Future addStoryView() async {
    try {
      final _authBloc = context.read<AuthBloc>();

      print('Add story runs ');
      if (_authBloc.state.user?.uid != widget.story?.author?.uid) {
        print('Add story runs --2');
        await context.read<StoryRepository>().addStoryView(
              userId: context.read<AuthBloc>().state.user?.uid,
              storyId: widget.story?.storyId,
            );
      }
    } catch (error) {
      print('Error adding stories ${error.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Tagged usr --- ${widget.story?.taggedUser}');
    final _canvas = MediaQuery.of(context).size;
    return BlocConsumer<ViewStoryBloc, ViewStoryState>(
      listener: (_, state) {},
      builder: (_, state) {
        return Container(
          height: double.infinity,
          width: double.infinity,
          decoration: gradientBackground,
          child: Scaffold(
            //   backgroundColor: Colors.grey.shade900,
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                SizedBox(
                  height: double.infinity,
                  width: double.infinity,
                  child: DisplayImage(
                    imageUrl: widget.story?.storyUrl,
                    fit: BoxFit.contain,
                  ),
                ),
                Positioned(
                  top: 40.0,
                  child: Row(
                    //   crossAxisAlignment: CrossAxisAlignment.center,
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
                          widget.story?.location ?? 'N/A',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                          ),
                          // textAlign: TextAlign.start,
                        ),
                      ),
                      const SizedBox(width: 7.0),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pushNamed(
                            OthersProfileScreen.routeName,
                            arguments: OthersProfileScreenArgs(
                                othersProfileId: widget.story?.author?.uid)),
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
                      context.read<AuthBloc>().state.user?.uid ==
                              widget.story?.author?.uid
                          ? ShareButton(
                              storyUrl: widget.story?.storyUrl,
                              caption: widget.story?.caption,
                            )
                          : const SizedBox.shrink(),
                      const SizedBox(height: 15.0),
                      ViewsButton(storyId: widget.story?.storyId),
                      const SizedBox(height: 15.0),
                      GradientCircleButton(
                        size: 40.0,
                        onTap: () {
                          if (widget.story?.storyId != null) {
                            print(
                                'Tagged usrs from view -- ${widget.story?.taggedUser}');
                            // context.read<ViewStoryBloc>().add(
                            //       LoadTaggedUsers(
                            //         storyId: widget.story!.storyId!,
                            //         tagUsers: widget.story?.taggedUser ?? [],
                            //       ),
                            //     );

                            _viewTaggedUserSheet(
                              context,
                              taggedUsers: widget.story?.taggedUser ?? [],
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
                            storyId: widget.story?.storyId,
                            storyAuthorId: widget.story?.author?.uid,
                          ),
                        ),
                        icon: Icons.chat_bubble,
                      ),
                      const SizedBox(height: 15.0),
                      GradientCircleButton(
                        size: 40.0,
                        onTap: () => _reportPost(context),
                        icon: Icons.report,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _viewTaggedUserSheet(
    BuildContext ctx, {
    // required List<TagUser?> taggedUsers,
    required List<TagUser?> taggedUsers,
  }) {
    // final users = ctx.read<ViewStoryBloc>().state.taggedUsers;
    // final viewStoryBloc = ctx.read<ViewStoryBloc>();
    final _storyRepo = context.read<StoryRepository>();
    showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext _) {
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
                  }),
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
            ],
          ),
        );
      },
    );
  }
}
