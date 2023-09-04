part of 'tag_user_bloc.dart';

abstract class TagUserEvent extends Equatable {
  const TagUserEvent();

  @override
  List<Object> get props => [];
}

class AddTagUser extends TagUserEvent {
  final TagUser? user;

  const AddTagUser({
    required this.user,
  });
}

class RemoveTagUser extends TagUserEvent {
  final TagUser user;

  const RemoveTagUser({
    required this.user,
  });
}

class Searching extends TagUserEvent {}

class NotSearcing extends TagUserEvent {}

class SearchKeyWordChanged extends TagUserEvent {
  final String keyword;

  const SearchKeyWordChanged({required this.keyword});
}
