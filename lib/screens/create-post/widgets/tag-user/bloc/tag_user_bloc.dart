import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:viewstories/models/app_user.dart';
import 'package:viewstories/models/failure.dart';
import 'package:viewstories/models/tag_user.dart';
part 'tag_user_event.dart';
part 'tag_user_state.dart';

class TagUserBloc extends Bloc<TagUserEvent, TagUserState> {
  TagUserBloc() : super(TagUserState.initial()) {
    on<TagUserEvent>((event, emit) {
      if (event is AddTagUser) {
        if (event.user != null) {
          final List<TagUser> users = List.from(state.tagUsers)
            ..add(event.user!);

          emit(state.copyWith(tagUsers: users));
        }
      } else if (event is RemoveTagUser) {
        final List<TagUser> users = List.from(state.tagUsers)
          ..remove(event.user);
        emit(state.copyWith(tagUsers: users));
      }
    });
  }
}
