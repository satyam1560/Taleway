part of 'followings_bloc.dart';

abstract class FollowingsEvent extends Equatable {
  const FollowingsEvent();

  @override
  List<Object> get props => [];
}

class LoadFollowingsUsers extends FollowingsEvent {}
