import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/models/app_user.dart';
import '/repositories/user/user_repository.dart';
import '/widgets/loading_indicator.dart';
import '/screens/create-post/cubit/create_post_cubit.dart';

class TagUserField extends StatefulWidget {
  const TagUserField({Key? key}) : super(key: key);

  @override
  _TagUserFieldState createState() => _TagUserFieldState();
}

class _TagUserFieldState extends State<TagUserField> {
  List<String> taggedUsers = [];

  final _tagController = TextEditingController();

  showUsersAlert(BuildContext context) async {
    final _userRepo = context.read<UserRepository>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            content: SizedBox(
          height: 200.0,
          child: StreamBuilder<List<AppUser?>>(
            stream: _userRepo.searchUser(_tagController.text),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return SimpleDialog(
                  backgroundColor: Colors.white,
                  title: const Text('GeeksforGeeks'),
                  children: <Widget>[
                    SimpleDialogOption(
                      onPressed: () {},
                      child: const Text('Option 1'),
                    ),
                    SimpleDialogOption(
                      onPressed: () {},
                      child: const Text('Option 2'),
                    ),
                  ],
                );
              }
              return const LoadingIndicator();
            },
          ),
        ));
      },
    );

    print('text in text controller -${_tagController.text}');
    // return showDialog(
    //   context: context,
    //   builder: (context) {
    //     return SizedBox(
    //       height: 300.0,
    //       child: StreamBuilder<List<AppUser?>>(
    //         stream: _userRepo.searchUser(_tagController.text),
    //         builder: (context, snapshot) {
    //           if (snapshot.connectionState == ConnectionState.done) {
    //             return ListView.builder(
    //               itemCount: snapshot.data?.length,
    //               itemBuilder: (context, index) {
    //                 final user = snapshot.data?[index];
    //                 return Text(
    //                   '${user?.name}',
    //                   style: const TextStyle(color: Colors.white),
    //                 );
    //               },
    //             );
    //           }
    //           return const LoadingIndicator();
    //         },
    //       ),
    //     );
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: TextFormField(
        controller: _tagController,
        onChanged: (value) {
          if (value.contains('@')) {
            showUsersAlert(context);
          }
        },
        style: const TextStyle(color: Colors.white, fontSize: 16.0),
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(23, 8, 12, 8),

          fillColor: const Color(0xff262626),
          filled: true,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),

          suffixIcon: InkWell(
            onTap: () {
              taggedUsers.add(_tagController.text);

              _tagController.clear();
              context.read<CreatePostCubit>().tagUserChanged(taggedUsers);
            },
            child: const Icon(
              Icons.check,
              color: Colors.green,
              size: 20.0,
            ),
          ),

          // labelText: 'Username',
          labelStyle: const TextStyle(
            color: Colors.white,
            fontFamily: 'Montserrat',
            fontSize: 14.0,
            letterSpacing: 1.0,
          ),
          hintText: 'Tag Someone',
          hintStyle: const TextStyle(color: Colors.white),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }
}
