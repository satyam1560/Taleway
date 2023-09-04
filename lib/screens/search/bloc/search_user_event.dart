part of 'search_user_bloc.dart';

abstract class SearchUserEvent extends Equatable {
  const SearchUserEvent();

  @override
  List<Object> get props => [];
}

class LoadRecentUsers extends SearchUserEvent {}

class PaginateRecentUsers extends SearchUserEvent {}
