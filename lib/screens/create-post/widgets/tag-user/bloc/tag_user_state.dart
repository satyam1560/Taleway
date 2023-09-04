part of 'tag_user_bloc.dart';

enum TagUserStatus { initial, loading, succuss, error }

class TagUserState extends Equatable {
  final List<TagUser?> tagUsers;
  final TagUserStatus status;
  final List<AppUser?> users;
  final Failure? failure;
  final bool searching;
  final List<AppUser?> searchDeals;
  final String? searchKeyWord;

  const TagUserState({
    required this.tagUsers,
    required this.status,
    required this.users,
    this.failure,
    this.searching = false,
    this.searchDeals = const [],
    this.searchKeyWord,
  });

  factory TagUserState.initial() => const TagUserState(
        tagUsers: [],
        status: TagUserStatus.initial,
        users: [],
        failure: Failure(),
        searching: false,
        searchDeals: [],
        searchKeyWord: '',
      );

  @override
  List<Object?> get props => [
        tagUsers,
        status,
        users,
        failure,
        searching,
        searchDeals,
        searchKeyWord,
      ];

  TagUserState copyWith({
    List<TagUser?>? tagUsers,
    TagUserStatus? status,
    List<AppUser?>? users,
    Failure? failure,
    bool? searching,
    String? searchKeyWord,
  }) {
    return TagUserState(
      tagUsers: tagUsers ?? this.tagUsers,
      status: status ?? this.status,
      users: users ?? this.users,
      failure: failure ?? this.failure,
      searching: searching ?? this.searching,
      searchKeyWord: searchKeyWord ?? this.searchKeyWord,
    );
  }
}
