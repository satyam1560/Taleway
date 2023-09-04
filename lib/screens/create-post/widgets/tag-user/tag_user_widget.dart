import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viewstories/models/tag_user.dart';
import '/models/app_user.dart';
import '/repositories/user/user_repository.dart';
import '/screens/create-post/widgets/tag-user/bloc/tag_user_bloc.dart';
import '/widgets/loading_indicator.dart';
import 'tag_user_tile.dart';

class TagUserWidget extends StatefulWidget {
  const TagUserWidget({Key? key}) : super(key: key);

  @override
  State<TagUserWidget> createState() => _TagUserWidgetState();
}

class _TagUserWidgetState extends State<TagUserWidget> {
  final TextEditingController _searchController = TextEditingController();

  bool _searching = false;

  String _searchKeyword = '';

  // List<String> users = [];

  @override
  Widget build(BuildContext context) {
    final _userRepo = context.read<UserRepository>();
    // print('Users custom $users');
    return BlocConsumer<TagUserBloc, TagUserState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              children: state.tagUsers
                  .map(
                    (value) => Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 5.0,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          if (value != null) {
                            context
                                .read<TagUserBloc>()
                                .add(RemoveTagUser(user: value));
                          }
                        },
                        child: Chip(
                          backgroundColor: Colors.grey.shade800,
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                value?.username ?? '',
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(width: 4.0),
                              const Icon(
                                Icons.clear,
                                color: Colors.white,
                                size: 16.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 6.0),
            _searching
                ? SizedBox(
                    height: 200.0,
                    child: StreamBuilder<List<AppUser?>>(
                      stream: _userRepo.searchUser(_searchKeyword),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Center(
                            child: Text(
                              'Someting went wrong :(',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          );
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const LoadingIndicator();
                        }
                        return ListView.builder(
                          itemCount: snapshot.data?.length,
                          itemBuilder: (context, index) {
                            final user = snapshot.data?[index];

                            if (user == null) {
                              return Center(
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _searching = false;
                                    });
                                  },
                                  child:
                                      const Text('We Found Nothing Found :('),
                                ),
                              );
                            } else {
                              return TagUserTile(
                                user: user,
                                onTap: () {
                                  final tagUser = TagUser(
                                      userId: user.uid,
                                      username: user.username);

                                  if (!state.tagUsers.contains(tagUser)) {
                                    context
                                        .read<TagUserBloc>()
                                        .add(AddTagUser(user: tagUser));
                                  }
                                },
                              );
                            }
                          },
                        );
                      },
                    ),
                  )
                : const SizedBox.shrink(),
            SizedBox(
              height: 48.0,
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white, fontSize: 16.0),
                onChanged: (value) {
                  setState(() {
                    print(value);
                    if (value.isNotEmpty) {
                      _searchKeyword = value;
                      _searching = true;
                    } else {
                      _searching = false;
                    }

                    print(_searching);
                  });
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.fromLTRB(24, 8, 12, 8),
                  fillColor: const Color(0xff262626),
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Color(0xff262626)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Color(0xff262626)),
                  ),
                  labelStyle: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                    fontSize: 14.0,
                    letterSpacing: 1.0,
                  ),
                  suffixIcon: _searching
                      ? InkWell(
                          onTap: () {
                            _searchController.clear();
                            setState(() {
                              _searching = false;
                            });
                          },
                          child: const Icon(Icons.clear, color: Colors.white),
                        )
                      : const SizedBox.shrink(),
                  // const Icon(Icons.search, color: Colors.white),
                  hintText: 'Tag users ',

                  hintStyle: const TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
