import 'package:flutter/material.dart';
import '/utils/constants.dart';
import '/screens/create-post/widgets/tag-user/bloc/tag_user_bloc.dart';
import 'widgets/tag-user/tag_user_widget.dart';
import '/repositories/user/user_repository.dart';
import '/screens/create-post/widgets/post_image.dart';
import '/widgets/custom_appbar.dart';
import '/widgets/loading_indicator.dart';
import '/blocs/auth/auth_bloc.dart';
import '/repositories/story/story_repository.dart';
import '/screens/create-post/cubit/create_post_cubit.dart';
import '/widgets/error_dialog.dart';
import '/widgets/show_snackbar.dart';
import '/widgets/custom_text_field.dart';
import '/widgets/gradient_circle_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'widgets/cubit/profile_collection_cubit.dart';
import 'widgets/select_story_collection.dart';

class CreatePostScreen extends StatefulWidget {
  static const String routeName = '/create-post';
  const CreatePostScreen({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => TagUserBloc(),
          ),
          BlocProvider<CreatePostCubit>(
            create: (context) => CreatePostCubit(
              authBloc: context.read<AuthBloc>(),
              tagUserBloc: context.read<TagUserBloc>(),
              storyRepository: context.read<StoryRepository>(),
            ),
          ),
        ],
        child: const CreatePostScreen(),
      ),
    );
  }

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();

  void _submitForm(BuildContext context, bool isSubmitting) {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate() && !isSubmitting) {
      if (context.read<CreatePostCubit>().state.postImage != null) {
        context.read<CreatePostCubit>().createPost();
        // Navigator.of(context).pop();
      } else {
        ShowSnackBar.showSnackBar(
          context,
          title: 'Please select an image to continue',
          //backgroundColor: Colors.red,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final _canvas = MediaQuery.of(context).size;
    return Container(
      height: _canvas.height,
      width: _canvas.width,
      decoration: gradientBackground,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: BlocConsumer<CreatePostCubit, CreatePostState>(
              listener: (context, state) {
                print('Current state ${state.status}');
                print('Tag users lenght --- ${state.tagUser.length}');
                if (state.status == CreatePostStatus.error) {
                  showDialog(
                    context: context,
                    builder: (context) => ErrorDialog(
                      content: state.failure.message,
                    ),
                  );
                } else if (state.status == CreatePostStatus.succuss) {
                  Navigator.of(context).pop();
                }
              },
              builder: (context, state) {
                return state.status == CreatePostStatus.submitting
                    ? const LoadingIndicator()
                    : Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 15.0,
                            horizontal: 25.0,
                          ),
                          child: ListView(
                            children: [
                              const CustomAppBar(title: 'Post'),
                              const SizedBox(height: 20.0),
                              PostImage(state: state),
                              const SizedBox(height: 25.0),
                              BlocProvider(
                                create: (context) => ProfileCollectionCubit(
                                  authBloc: context.read<AuthBloc>(),
                                  userRepository:
                                      context.read<UserRepository>(),
                                ),
                                child: const SelectStoryCollection(),
                              ),
                              const SizedBox(height: 5.0),
                              CustomTextField(
                                contentPadding:
                                    const EdgeInsets.fromLTRB(25, 8, 12, 8),
                                onChanged: (value) => context
                                    .read<CreatePostCubit>()
                                    .captionChanged(value),
                                textInputType: TextInputType.name,
                                validator: (value) => value!.isEmpty
                                    ? 'Caption can\'t be empty'
                                    : null,
                                hintText: 'Add caption',
                              ),

                              // BlocProvider<TagUserBloc>(
                              //   create: (context) => TagUserBloc(),
                              //   child: const TagUser(),
                              // ),
                              const TagUserWidget(),
                              //const NewTagUser(),
                              const SizedBox(height: 5.0),

                              CustomTextField(
                                contentPadding:
                                    const EdgeInsets.fromLTRB(25, 8, 12, 8),
                                onChanged: (value) => context
                                    .read<CreatePostCubit>()
                                    .locationChanged(value),
                                textInputType: TextInputType.name,
                                validator: (value) => value!.isEmpty
                                    ? 'Location can\'t be empty'
                                    : null,
                                hintText: 'Add location',
                              ),
                              const SizedBox(height: 20.0),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Post',
                                      style: TextStyle(
                                        fontSize: 17.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    GradientCircleButton(
                                      onTap: () => _submitForm(
                                          context,
                                          state.status ==
                                              CreatePostStatus.submitting),
                                      icon: Icons.arrow_forward,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
              },
            ),
          ),
        ),
      ),
    );
  }
}
