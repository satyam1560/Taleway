import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:uuid/uuid.dart';
import '/screens/create-post/widgets/tag-user/bloc/tag_user_bloc.dart';
import '/blocs/auth/auth_bloc.dart';
import '/models/failure.dart';
import '/models/story.dart';
import '/repositories/story/story_repository.dart';
import '/utils/image_util.dart';
part 'create_post_state.dart';

class CreatePostCubit extends Cubit<CreatePostState> {
  final StoryRepository _storyRepository;
  final AuthBloc _authBloc;
  final TagUserBloc _tagUserBloc;

  CreatePostCubit({
    required StoryRepository storyRepository,
    required AuthBloc authBloc,
    required TagUserBloc tagUserBloc,
  })  : _storyRepository = storyRepository,
        _authBloc = authBloc,
        _tagUserBloc = tagUserBloc,
        super(CreatePostState.initial());

  void captionChanged(String value) {
    emit(state.copyWith(caption: value, status: CreatePostStatus.initial));
  }

  void addToCollectionChanged(String value) {
    emit(state.copyWith(
        addToCollection: value, status: CreatePostStatus.initial));
  }

  void storyCollectionChanged(String value) {
    emit(state.copyWith(caption: value, status: CreatePostStatus.initial));
  }

  void clearTagUser(String value) {
    state.tagUser.remove(value);
    emit(state.copyWith(
      tagUser: state.tagUser,
    ));
    emit(state.copyWith(
      tagUser: state.tagUser,
    ));
  }

  void addUserToTag(String value) {
    if (!(state.tagUser.contains(value))) {
      state.tagUser.add(value);
      emit(state.copyWith(tagUser: state.tagUser));
    }
  }

  void refresh() {
    emit(state.copyWith(status: CreatePostStatus.initial));
  }

  void tagUserChanged(List<String> value) {
    emit(state.copyWith(tagUser: value, status: CreatePostStatus.initial));
  }

  void locationChanged(String value) {
    emit(state.copyWith(location: value, status: CreatePostStatus.initial));
  }

  void imagePicked(Uint8List? image) {
    emit(state.copyWith(postImage: image, status: CreatePostStatus.initial));
  }

  void createPost() async {
    if (!state.isFormValid || state.status == CreatePostStatus.submitting) {
      return;
    }

    emit(state.copyWith(status: CreatePostStatus.submitting));
    try {
      print('Email ${state.caption}');
      print('Password ${state.location}');
      final userId = _authBloc.state.user?.uid;

      final storyId = const Uuid().v4();

      if (userId != null && state.postImage != null) {
        final String? downloadUrl = await ImageUtil.uploadStoryImageToStorage(
          'stories',
          state.postImage!,
          false,
          storyId,
        );

        // final userDoc = await FirebaseFirestore.instance
        //     .collection(Paths.users)
        //     .doc(_authBloc.state.user?.uid)
        //     .get();

        //     final user = AppUser.fromMap(map)

        print('tagged usrs -------- ${_tagUserBloc.state.tagUsers}');

        final story = Story(
          author: _authBloc.state.user,
          storyUrl: downloadUrl,
          //taggedUser: state.tagUser,
          taggedUser: _tagUserBloc.state.tagUsers,
          caption: state.caption,
          location: state.location,
          storyId: storyId,
          date: DateTime.now(),
          collectionName: state.addToCollection,
          expireAt: DateTime.now().add(const Duration(days: 1)),
        );

        await _storyRepository.createStory(
          userId: userId,
          story: story,
          collectionName: state.addToCollection,
          //storyId: storyId,
        );
        emit(state.copyWith(status: CreatePostStatus.succuss));
      }
    } on Failure catch (err) {
      emit(state.copyWith(failure: err, status: CreatePostStatus.error));
    }
  }
}
