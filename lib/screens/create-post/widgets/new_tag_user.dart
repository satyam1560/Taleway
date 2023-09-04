// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:viewstories/models/app_user.dart';
// import 'package:viewstories/repositories/user/user_repository.dart';
// import 'package:viewstories/screens/create-post/widgets/tag_user_tile.dart';
// import 'package:viewstories/screens/search/widgets/search_user_tile.dart';
// import 'package:viewstories/widgets/loading_indicator.dart';

// class NewTagUser extends StatefulWidget {
//   const NewTagUser({Key? key}) : super(key: key);

//   @override
//   State<NewTagUser> createState() => _NewTagUserState();
// }

// class _NewTagUserState extends State<NewTagUser> {
//   final TextEditingController _searchController = TextEditingController();

//   bool _searching = false;
//   String _searchKeyword = '';

//   @override
//   Widget build(BuildContext context) {
//     final _userRepo = context.read<UserRepository>();
//     print('aaaaa ${_searchController.text.isNotEmpty}');
//     print('Search value ${_searchController.text}');
//     return Column(
//       children: [
//         _searching
//             ? SizedBox(
//                 height: 200.0,
//                 child: StreamBuilder<List<AppUser?>>(
//                     stream: _userRepo.searchUser(_searchKeyword),
//                     builder: (context, snapshot) {
//                       if (snapshot.hasError) {
//                         return const Center(
//                           child: Text(
//                             'Someting went wrong :(',
//                             style: TextStyle(
//                               color: Colors.white,
//                             ),
//                           ),
//                         );
//                       }
//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         return const LoadingIndicator();
//                       }
//                       return ListView.builder(
//                         itemCount: snapshot.data?.length,
//                         itemBuilder: (context, index) {
//                           final user = snapshot.data?[index];

//                           if (user == null) {
//                             return Center(
//                               child: TextButton(
//                                 onPressed: () {
//                                   setState(() {
//                                     _searching = false;
//                                   });
//                                 },
//                                 child: const Text('We Found Nothing Found :('),
//                               ),
//                             );
//                           } else {
//                             return TagUserTile(user: user);
//                           }
//                         },
//                       );
//                     }),
//               )
//             : const SizedBox.shrink(),
//         TextField(
//           controller: _searchController,
//           style: const TextStyle(color: Colors.white, fontSize: 16.0),
//           onChanged: (value) {
//             setState(() {
//               print(value);
//               if (value.isNotEmpty) {
//                 _searchKeyword = value;
//                 _searching = true;
//               } else {
//                 _searching = false;
//               }

//               print(_searching);
//             });
//           },
//           decoration: InputDecoration(
//             // contentPadding: contentPadding,
//             fillColor: const Color(0xff262626),
//             filled: true,
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10.0),
//               borderSide: const BorderSide(color: Color(0xff262626)),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10.0),
//               borderSide: const BorderSide(color: Color(0xff262626)),
//             ),
//             prefixIcon: const Icon(Icons.search, color: Colors.white),
//             labelStyle: const TextStyle(
//               color: Colors.white,
//               fontFamily: 'Montserrat',
//               fontSize: 14.0,
//               letterSpacing: 1.0,
//             ),
//             suffixIcon: _searching
//                 ? InkWell(
//                     onTap: () {
//                       _searchController.clear();
//                       setState(() {
//                         _searching = false;
//                       });
//                     },
//                     child: const Icon(Icons.clear),
//                   )
//                 : const Icon(Icons.search, color: Colors.white),
//             hintText: 'Search ',
//             hintStyle: const TextStyle(color: Colors.white),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10.0),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// // import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:searchfield/searchfield.dart';
// // import 'package:viewstories/models/app_user.dart';
// // import 'package:viewstories/repositories/user/user_repository.dart';
// // import 'package:viewstories/widgets/loading_indicator.dart';

// // class NewTagUser extends StatefulWidget {
// //   const NewTagUser({Key? key}) : super(key: key);

// //   @override
// //   State<NewTagUser> createState() => _NewTagUserState();
// // }

// // class _NewTagUserState extends State<NewTagUser> {
// //   final _searchController = TextEditingController();
// //   @override
// //   Widget build(BuildContext context) {
// //     final _userRepo = context.read<UserRepository>();
// //     return StreamBuilder<List<AppUser?>>(
// //       stream: _userRepo.searchUser(_searchController.text),
// //       builder: (context, snapshot) {
// //         if (snapshot.connectionState == ConnectionState.done) {
// //           final users = snapshot.data;
// //           return SearchField(
// //             controller: _searchController,
// //             suggestions: users!
// //                 .map((user) => SearchFieldListItem(user?.name ?? ''))
// //                 .toList(),
// //             suggestionState: Suggestion.expand,
// //             textInputAction: TextInputAction.next,
// //             hint: 'SearchField Example 2',
// //             hasOverlay: false,
// //             searchStyle: TextStyle(
// //               fontSize: 18,
// //               color: Colors.black.withOpacity(0.8),
// //             ),
// //             validator: (x) {
// //               //   if (!_statesOfIndia.contains(x) || x!.isEmpty) {
// //               //    return 'Please Enter a valid State';
// //               //   }
// //               // return null;
// //             },
// //             searchInputDecoration: InputDecoration(
// //               focusedBorder: OutlineInputBorder(
// //                 borderSide: BorderSide(
// //                   color: Colors.black.withOpacity(0.8),
// //                 ),
// //               ),
// //               border: const OutlineInputBorder(
// //                 borderSide: BorderSide(color: Colors.red),
// //               ),
// //             ),
// //             maxSuggestionsInViewPort: 6,
// //             itemHeight: 50,
// //             onTap: (x) {},
// //           );
// //         }
// //         return const LoadingIndicator();
// //       },
// //     );
// //   }
// // }
