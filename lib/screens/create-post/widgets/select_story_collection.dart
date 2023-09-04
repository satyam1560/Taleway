import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viewstories/widgets/custom_gradient_btn.dart';
import '/screens/create-post/widgets/cubit/profile_collection_cubit.dart';
import '/widgets/loading_indicator.dart';
import '/screens/create-post/cubit/create_post_cubit.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';

enum SingingCharacter { closeFriends, celebrities, twitterFriends }

class SelectStoryCollection extends StatefulWidget {
  const SelectStoryCollection({
    Key? key,
  }) : super(key: key);

  @override
  State<SelectStoryCollection> createState() => _SelectStoryCollectionState();
}

class _SelectStoryCollectionState extends State<SelectStoryCollection> {
  // SingingCharacter? _character = SingingCharacter.closeFriends;
  final GlobalKey<ExpansionTileCardState> cardA = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCollectionCubit, ProfileCollectionState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state.status == ProfileCollectionStatus.succuss) {
          // final collectionNames = state.collectionNames;
          return ExpansionTileCard(
            baseColor: const Color(0xff262626),
            shadowColor: const Color(0xff262626),
            expandedColor: const Color(0xff262626),
            trailing: const Icon(
              Icons.expand_more,
              color: Colors.white,
            ),
            key: cardA,
            title: Padding(
              padding: const EdgeInsets.only(left: 7.0),
              child: Text(
                context.read<ProfileCollectionCubit>().state.newColName ??
                    'Select your collection',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            children: [
              Container(
                color: Colors.grey.shade900,
                height: 300.0,
                // height: collectionNames?.length != null
                //     ? collectionNames!.length * 250
                //     : 200,

                child: Column(
                  children: [
                    SizedBox(
                      height: 170.0,
                      // height: collectionNames?.length != null
                      //     ? collectionNames!.length * 100
                      //     : 200,
                      child: ListView.builder(
                        itemCount: state.collectionNames?.length,
                        itemBuilder: (context, index) {
                          final data = state.collectionNames?[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 3.0,
                              horizontal: 20.0,
                            ),
                            child: ListTile(
                              title: Text(
                                data ?? 'N/A',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.1,
                                ),
                              ),
                              trailing: Theme(
                                data: Theme.of(context).copyWith(
                                  unselectedWidgetColor: Colors.white,
                                  disabledColor: Colors.blue,
                                ),
                                child: Radio<String>(
                                  value: data ?? 'N/A',
                                  groupValue: state.newColName,
                                  onChanged: (value) => context
                                      .read<ProfileCollectionCubit>()
                                      .collectionNameChanged(name: value!),

                                  // (String? value) {
                                  //   // setState(() {
                                  //   //   _character = value;
                                  //   // });
                                  // },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35.0),
                      child: TextField(
                        style: const TextStyle(color: Colors.white),
                        onChanged: (value) => context
                            .read<ProfileCollectionCubit>()
                            .collectionNameChanged(name: value),
                        decoration: const InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.cyan),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.cyan),
                          ),
                          hintText: 'Add new collection',
                          hintStyle: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 32.0),
                        child: CustomGradientBtn(
                          label: 'Done',
                          onTap: () {
                            print(
                                'Selection collectionname --- ${context.read<ProfileCollectionCubit>().state.newColName}');
                            final collName = context
                                .read<ProfileCollectionCubit>()
                                .state
                                .newColName;
                            if (collName != null) {
                              context
                                  .read<CreatePostCubit>()
                                  .addToCollectionChanged(collName);
                            }

                            cardA.currentState?.collapse();
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
        }
        return const LoadingIndicator();
      },
    );

    //  ExpandableNotifier(
    //   // <-- Provides ExpandableController to its children
    //   child: Column(
    //     children: [
    //       Expandable(
    //         // <-- Driven by ExpandableController from ExpandableNotifier
    //         collapsed: ExpandableButton(
    //           // <-- Expands when tapped on the cover photo
    //           child: Container(
    //             decoration: BoxDecoration(
    //               color: const Color(0xff262626),
    //               borderRadius: BorderRadius.circular(8.0),
    //             ),
    //             height: 46.0,
    //             width: double.infinity,
    //             child: Padding(
    //               padding: const EdgeInsets.only(
    //                 right: 12.0,
    //                 left: 25.0,
    //               ),
    //               child: Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                 children: [
    //                   Text(
    //                     context
    //                             .read<CreatePostCubit>()
    //                             .state
    //                             .addToCollection
    //                             .isEmpty
    //                         ? 'Add to'
    //                         : context
    //                             .read<CreatePostCubit>()
    //                             .state
    //                             .addToCollection,
    //                     style: const TextStyle(
    //                       color: Colors.white,
    //                       fontSize: 16.0,
    //                     ),
    //                   ),
    //                   const Icon(
    //                     Icons.arrow_drop_down,
    //                     color: Colors.white,
    //                   )
    //                 ],
    //               ),
    //             ),
    //           ),
    //         ),
    //         expanded: Column(
    //           children: [
    //             Container(
    //               padding: const EdgeInsets.symmetric(
    //                   vertical: 10.0, horizontal: 15.0),
    //               height: 220.0,
    //               width: double.infinity,
    //               color: const Color(0xff262626),
    //               child: Theme(
    //                 data: Theme.of(context).copyWith(
    //                   unselectedWidgetColor: Colors.white,
    //                   disabledColor: Colors.blue,
    //                 ),
    //                 child: Column(
    //                   mainAxisAlignment: MainAxisAlignment.start,
    //                   children: [
    //                     ListTile(
    //                       title: const Text(
    //                         'Close Friends',
    //                         style: TextStyle(
    //                           color: Colors.white,
    //                         ),
    //                       ),
    //                       trailing: Radio<SingingCharacter>(
    //                         value: SingingCharacter.closeFriends,
    //                         groupValue: _character,
    //                         onChanged: (SingingCharacter? value) {
    //                           context
    //                               .read<CreatePostCubit>()
    //                               .addToCollectionChanged(
    //                                   'Close Friends');

    //                           setState(() {
    //                             _character = value;
    //                           });
    //                         },
    //                       ),
    //                     ),
    //                     ListTile(
    //                       trailing: Radio<SingingCharacter>(
    //                         value: SingingCharacter.celebrities,
    //                         groupValue: _character,
    //                         onChanged: (SingingCharacter? value) {
    //                           context
    //                               .read<CreatePostCubit>()
    //                               .addToCollectionChanged('Celebrities');
    //                           setState(() {
    //                             _character = value;
    //                           });
    //                         },
    //                       ),
    //                       title: const Text(
    //                         'Celebrities',
    //                         style: TextStyle(
    //                           color: Colors.white,
    //                         ),
    //                       ),
    //                     ),
    //                     ListTile(
    //                       title: const Text(
    //                         'Twitter Friends',
    //                         style: TextStyle(
    //                           color: Colors.white,
    //                         ),
    //                       ),
    //                       trailing: Radio<SingingCharacter>(
    //                         value: SingingCharacter.twitterFriends,
    //                         groupValue: _character,
    //                         onChanged: (SingingCharacter? value) {
    //                           context
    //                               .read<CreatePostCubit>()
    //                               .addToCollectionChanged(
    //                                   'Twitter Friends');
    //                           setState(() {
    //                             _character = value;
    //                           });
    //                         },
    //                       ),
    //                     ),
    //                     Align(
    //                       alignment: Alignment.bottomRight,
    //                       child: Padding(
    //                         padding: const EdgeInsets.only(right: 30.0),
    //                         child: ExpandableButton(
    //                           // <-- Collapses when tapped on
    //                           child: const Icon(
    //                             Icons.arrow_drop_up,
    //                             color: Colors.white,
    //                           ),
    //                         ),
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ],
    //   ),
    // );
    //});
  }
}



// import 'package:flutter/material.dart';

// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:expandable/expandable.dart';
// import '/screens/create-post/cubit/create_post_cubit.dart';

// enum SingingCharacter { closeFriends, celebrities, twitterFriends }

// class SelectStoryCollection extends StatefulWidget {
//   const SelectStoryCollection({
//     Key? key,
//   }) : super(key: key);

//   @override
//   State<SelectStoryCollection> createState() => _SelectStoryCollectionState();
// }

// class _SelectStoryCollectionState extends State<SelectStoryCollection> {
//   SingingCharacter? _character = SingingCharacter.closeFriends;
//   @override
//   Widget build(BuildContext context) {
//     return ExpandableNotifier(
//       // <-- Provides ExpandableController to its children
//       child: Column(
//         children: [
//           Expandable(
//             // <-- Driven by ExpandableController from ExpandableNotifier
//             collapsed: ExpandableButton(
//               // <-- Expands when tapped on the cover photo
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: const Color(0xff262626),
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//                 height: 46.0,
//                 width: double.infinity,
//                 child: Padding(
//                   padding: const EdgeInsets.only(
//                     right: 12.0,
//                     left: 25.0,
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         context
//                                 .read<CreatePostCubit>()
//                                 .state
//                                 .addToCollection
//                                 .isEmpty
//                             ? 'Add to'
//                             : context
//                                 .read<CreatePostCubit>()
//                                 .state
//                                 .addToCollection,
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 16.0,
//                         ),
//                       ),
//                       const Icon(
//                         Icons.arrow_drop_down,
//                         color: Colors.white,
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             expanded: Column(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                       vertical: 10.0, horizontal: 15.0),
//                   height: 220.0,
//                   width: double.infinity,
//                   color: const Color(0xff262626),
//                   child: Theme(
//                     data: Theme.of(context).copyWith(
//                       unselectedWidgetColor: Colors.white,
//                       disabledColor: Colors.blue,
//                     ),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         ListTile(
//                           title: const Text(
//                             'Close Friends',
//                             style: TextStyle(
//                               color: Colors.white,
//                             ),
//                           ),
//                           trailing: Radio<SingingCharacter>(
//                             value: SingingCharacter.closeFriends,
//                             groupValue: _character,
//                             onChanged: (SingingCharacter? value) {
//                               context
//                                   .read<CreatePostCubit>()
//                                   .addToCollectionChanged('Close Friends');

//                               setState(() {
//                                 _character = value;
//                               });
//                             },
//                           ),
//                         ),
//                         ListTile(
//                           trailing: Radio<SingingCharacter>(
//                             value: SingingCharacter.celebrities,
//                             groupValue: _character,
//                             onChanged: (SingingCharacter? value) {
//                               context
//                                   .read<CreatePostCubit>()
//                                   .addToCollectionChanged('Celebrities');
//                               setState(() {
//                                 _character = value;
//                               });
//                             },
//                           ),
//                           title: const Text(
//                             'Celebrities',
//                             style: TextStyle(
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                         ListTile(
//                           title: const Text(
//                             'Twitter Friends',
//                             style: TextStyle(
//                               color: Colors.white,
//                             ),
//                           ),
//                           trailing: Radio<SingingCharacter>(
//                             value: SingingCharacter.twitterFriends,
//                             groupValue: _character,
//                             onChanged: (SingingCharacter? value) {
//                               context
//                                   .read<CreatePostCubit>()
//                                   .addToCollectionChanged('Twitter Friends');
//                               setState(() {
//                                 _character = value;
//                               });
//                             },
//                           ),
//                         ),
//                         Align(
//                           alignment: Alignment.bottomRight,
//                           child: Padding(
//                             padding: const EdgeInsets.only(right: 30.0),
//                             child: ExpandableButton(
//                               // <-- Collapses when tapped on
//                               child: const Icon(
//                                 Icons.arrow_drop_up,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
