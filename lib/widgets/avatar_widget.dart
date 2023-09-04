import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

const String _errorImage =
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTjMD6Pl7n4lSFFphlDlRz7o4ULYlNrAC9KJN4sfz9mRDDgU_FzGrA-DNgLL8keHh90KJg&usqp=CAU';

class AvatarWidget extends StatelessWidget {
  final String? imageUrl;
  final double? size;
  final double borderRadius;
  final double contentPadding;

  const AvatarWidget({
    Key? key,
    required this.imageUrl,
    this.borderRadius = 40.0,
    this.size = 60.0,
    this.contentPadding = 2.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Avatar image ------ $imageUrl');
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 10.0,
      ),
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomLeft,
            colors: [
              Colors.pink,
              Colors.purpleAccent,
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(contentPadding),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child:

                // Image.network(
                //   imageUrl!,
                //   loadingBuilder: (context, widget, _) => Shimmer.fromColors(
                //     baseColor: const Color(0xFFEBEBF4),
                //     highlightColor: const Color(0xFFF4F4F4),
                //     child: const CircleAvatar(radius: 25.0),
                //   ),
                //   errorBuilder: (context, _, __) =>
                //       const Center(child: Icon(Icons.error)),
                // ),

                //  imageUrl != null
                //     ? Image.network(imageUrl!, fit: BoxFit.cover)
                //     : Image.asset('assets/images/white_bg.png', fit: BoxFit.cover)

                // FadeInImage(
                //   fit: Bo//xFit.cover,
                //   placeholder: const AssetImage('assets/images/white_bg.png'),
                //   image: imageUrl != null
                //       ? NetworkImage(imageUrl!)
                //       : NetworkImage('url')
                //     //  : AssetImage('assets/images/white_bg.png'),
                // )

                CachedNetworkImage(
              imageUrl: imageUrl ?? _errorImage,
              fit: BoxFit.cover,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Shimmer.fromColors(
                baseColor: const Color(0xFFEBEBF4),
                highlightColor: const Color(0xFFF4F4F4),
                child: const CircleAvatar(radius: 25.0),
              ),
              errorWidget: (context, url, error) =>
                  const Center(child: Icon(Icons.error)),
            ),
          ),
        ),
      ),
    );
  }
}
