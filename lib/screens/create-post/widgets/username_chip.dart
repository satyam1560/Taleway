import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viewstories/screens/create-post/cubit/create_post_cubit.dart';

class UserNameChip extends StatelessWidget {
  const UserNameChip({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreatePostCubit, CreatePostState>(
      builder: (context, state) {
        return Wrap(
          // children: context
          //     .read<CreatePostCubit>()
          //     .state
          //     .tagUser
          children: state.tagUser
              .map(
                (value) => Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 5.0,
                  ),
                  child: Chip(
                    backgroundColor: Colors.grey.shade800,
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          value ?? '',
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(width: 4.0),
                        GestureDetector(
                          onTap: () {
                            if (value != null) {
                              context
                                  .read<CreatePostCubit>()
                                  .clearTagUser(value);
                            }
                          },
                          child: const Icon(
                            Icons.clear,
                            color: Colors.white,
                            size: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}
