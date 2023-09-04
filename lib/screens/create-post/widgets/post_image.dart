import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import '/screens/create-post/cubit/create_post_cubit.dart';
import '/utils/image_util.dart';
import '/widgets/gradient_circle_button.dart';

class PostImage extends StatelessWidget {
  final CreatePostState state;
  const PostImage({
    Key? key,
    required this.state,
  }) : super(key: key);

  Future<void> _pickImage(BuildContext context) async {
    final pickedImage = await ImageUtil.pickImageFromGallery(
        cropStyle: CropStyle.rectangle,
        context: context,
        imageQuality: 60,
        title: 'Pick your story');

    context
        .read<CreatePostCubit>()
        .imagePicked(await pickedImage?.readAsBytes());
  }

  @override
  Widget build(BuildContext context) {
    final _canvas = MediaQuery.of(context).size;

    return Container(
      height: 250.0,
      width: _canvas.width * 0.92,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.0),
        color: Colors.grey.shade800,
      ),
      child: state.postImage != null
          ? Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.memory(
                    state.postImage!,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 5.0,
                  right: 3.0,
                  // alignment: Alignment.topRight,
                  child: GradientCircleButton(
                    iconSize: 16.0,
                    size: 32.0,
                    onTap: () => _pickImage(context),
                    icon: Icons.edit,
                  ),
                )
              ],
            )
          : Center(
              child: IconButton(
                icon: const Icon(
                  Icons.add_photo_alternate,
                  color: Colors.white,
                  size: 30.0,
                ),
                onPressed: () => _pickImage(context),
              ),
            ),
    );
  }
}
