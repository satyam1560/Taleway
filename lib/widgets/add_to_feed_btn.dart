import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viewstories/widgets/show_snackbar.dart';
import '/blocs/add-to-lib/add_to_collection_cubit.dart';
import '/widgets/loading_indicator.dart';
import '../screens/others-profile/widgets/action_buttons.dart';
import 'custom_gradient_btn.dart';

class AddToFeedCollectionBtn extends StatelessWidget {
  final String? otherUserId;
  final String label;

  const AddToFeedCollectionBtn({
    Key? key,
    required this.otherUserId,
    this.label = 'Add to',
  }) : super(key: key);

  void _addToFeed(BuildContext context) async {
    // final List<String?> list = await context
    //     .read<UserRepository>()
    //     .getUserStoryCollection(userID: userId, collectionName: Paths.feedList);

    showBottomSheet(
      backgroundColor: Colors.grey.shade900,
      context: context,
      builder: (context) {
        return BlocConsumer<AddToCollectionCubit, AddToCollectionState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state.status == AddToCollectionStatus.succuss) {
              return Container(
                  color: Colors.grey.shade900,
                  height: 350.0,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 200.0,
                        child: ListView.builder(
                          itemCount: state.collectionNames?.length,
                          itemBuilder: (context, index) {
                            final data = state.collectionNames?[index];
                            // String selected = '';
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
                                    groupValue: state.name,
                                    onChanged: (value) => context
                                        .read<AddToCollectionCubit>()
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
                              .read<AddToCollectionCubit>()
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
                              Navigator.of(context).pop();
                              print(
                                  'Selection collectionname --- ${context.read<AddToCollectionCubit>().state.name}');

                              print(
                                  'Selection collection name --${state.name}');
                              if (state.name != null && otherUserId != null) {
                                context
                                    .read<AddToCollectionCubit>()
                                    .addToUserFeedCollection(
                                      collectionName: state.name!,
                                      otherUserId: otherUserId!,
                                    );
                                ShowSnackBar.showSnackBar(context,
                                    title: 'Added to ${state.name}');
                                //context.read<FeedBloc>().add(LoadUserFeed());

                              }
                            },
                          ),
                        ),
                      )
                    ],
                  ));
            }
            return const LoadingIndicator();
          },
        );
      },
    );

//context.read<OthersProfileBloc>().add(AddToUserFeedCollection()),
  }

  @override
  Widget build(BuildContext context) {
    print(
        'Selection collectionname --- ${context.read<AddToCollectionCubit>().state.name}');
    return ActionButtons(
      onTap: () => _addToFeed(context),
      icon: Icons.library_add,
      label: label,
    );
  }
}
