import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/blocs/auth/auth_bloc.dart';
import '/screens/others-profile/others_profile_screen.dart';
import '/screens/profile/profile_screen.dart';
import '/screens/search/bloc/search_user_bloc.dart';
import '/widgets/avatar_widget.dart';
import '/widgets/error_dialog.dart';
import '/widgets/loading_indicator.dart';

class RecentUsers extends StatefulWidget {
  const RecentUsers({Key? key}) : super(key: key);

  @override
  State<RecentUsers> createState() => _RecentUsersState();
}

class _RecentUsersState extends State<RecentUsers> {
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.offset >=
                _scrollController.position.maxScrollExtent &&
            !_scrollController.position.outOfRange &&
            context.read<SearchUserBloc>().state.status !=
                SearchUserStatus.paginating) {
          context.read<SearchUserBloc>().add(LoadRecentUsers());
        }
      });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _authBloc = context.read<AuthBloc>();
    final _canvas = MediaQuery.of(context).size;
    return BlocConsumer<SearchUserBloc, SearchUserState>(
      listener: (context, state) {
        if (state.status == SearchUserStatus.error) {
          showDialog(
            context: context,
            builder: (context) => ErrorDialog(content: state.failure.message),
          );
        } else if (state.status == SearchUserStatus.paginating) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Theme.of(context).primaryColor,
              duration: const Duration(seconds: 1),
              content: const Text('Fetching More Users...'),
            ),
          );
        }
      },
      builder: (context, state) {
        print('Recent users status --- ${state.recentUsers.length}');
        print('canvas height --- ${_canvas.height}');
        switch (state.status) {
          case SearchUserStatus.loaded:
            final users = state.recentUsers;
            users.removeWhere(
                (element) => element?.uid == _authBloc.state.user?.uid);

            return RefreshIndicator(
              onRefresh: () async {
                context.read<LoadRecentUsers>();
              },
              child: GridView.builder(
                controller: _scrollController,
                itemCount: state.recentUsers.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisExtent: 130.0,
                  // mainAxisExtent: _canvas.height * 0.20,
                  mainAxisSpacing: 5.0,
                  crossAxisCount: 3,
                  crossAxisSpacing: 5.0,
                ),
                itemBuilder: (context, index) {
                  final user = users[index];

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                          onTap: () {
                            if (_authBloc.state.user?.uid == user?.uid) {
                              Navigator.of(context)
                                  .pushNamed(ProfileScreen.routeName);
                            } else {
                              Navigator.of(context).pushNamed(
                                OthersProfileScreen.routeName,
                                arguments: OthersProfileScreenArgs(
                                    othersProfileId: user?.uid),
                              );
                            }
                          },
                          child: AvatarWidget(imageUrl: user?.profilePic)),
                      Text(
                        user?.name ?? 'N/A',
                        style: const TextStyle(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  );
                },
              ),
            );

          default:
            return const LoadingIndicator();
        }
      },
    );
  }
}
