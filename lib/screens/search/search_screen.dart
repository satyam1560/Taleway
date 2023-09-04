import 'package:flutter/material.dart';
import '/screens/search/widgets/recent_users.dart';
import '/screens/search/bloc/search_user_bloc.dart';
import '/utils/constants.dart';
import '/models/app_user.dart';
import '/repositories/user/user_repository.dart';
import '/widgets/gradient_circle_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/widgets/loading_indicator.dart';
import 'widgets/search_user_tile.dart';

class SearchScreen extends StatefulWidget {
  static const String routeName = '/search';
  const SearchScreen({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => BlocProvider(
        create: (context) =>
            SearchUserBloc(userRepository: context.read<UserRepository>())
              ..add(LoadRecentUsers()),
        child: const SearchScreen(),
      ),
    );
  }

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  bool _searching = false;
  String _searchKeyword = '';

  @override
  Widget build(BuildContext context) {
    final _userRepo = context.read<UserRepository>();
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: gradientBackground,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15.0,
              vertical: 20.0,
            ),
            child: Column(
              children: [
                const SizedBox(height: 20.0),
                Row(
                  children: [
                    GradientCircleButton(
                      size: 40.0,
                      onTap: () => Navigator.of(context).pop(),
                      icon: Icons.arrow_back,
                    ),
                    const SizedBox(width: 14.0),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 16.0),
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
                          // contentPadding: contentPadding,
                          fillColor: const Color(0xff262626),
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide:
                                const BorderSide(color: Color(0xff262626)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide:
                                const BorderSide(color: Color(0xff262626)),
                          ),
                          prefixIcon:
                              const Icon(Icons.search, color: Colors.white),
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
                                  child: const Icon(Icons.clear),
                                )
                              : const Icon(Icons.search, color: Colors.white),
                          hintText: 'Search by username ',
                          hintStyle: const TextStyle(color: Colors.white),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                _searching
                    ? StreamBuilder<List<AppUser?>>(
                        stream:
                            _userRepo.searchUser(_searchKeyword.toLowerCase()),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const Expanded(
                              child: Center(
                                child: Text(
                                  'Someting went wrong :(',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Expanded(
                              child: LoadingIndicator(),
                            );
                          }
                          return Expanded(
                            child: ListView.builder(
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
                                      child: const Text(
                                          'We Found Nothing Found :('),
                                    ),
                                  );
                                } else {
                                  return SearchUserTile(user: user);
                                }
                              },
                            ),
                          );
                        })
                    : const Expanded(child: RecentUsers()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
