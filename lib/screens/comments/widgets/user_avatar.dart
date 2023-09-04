import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:viewstories/utils/constants.dart';

class UserAvatar extends StatelessWidget {
  final String? imageUrl;
  final double? size;
  final double borderRadius;
  final double contentPadding;

  const UserAvatar({
    Key? key,
    required this.imageUrl,
    this.borderRadius = 40.0,
    this.size = 60.0,
    this.contentPadding = 2.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
          borderRadius: BorderRadius.circular(60.0),
          child: CachedNetworkImage(
            //width: width ?? 1000.0,

            ///   height: double.infinity,
            imageUrl: imageUrl ?? errorImage,
            fit: BoxFit.cover,
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                Shimmer.fromColors(
              baseColor: const Color(0xFFEBEBF4),
              highlightColor: const Color(0xFFF4F4F4),
              child: const CircleAvatar(radius: 25.0),

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: const [
              //     CircleAvatar(radius: 25.0),
              //   ],
              // ),
            ),
            //     Center(
            //   child: CircularProgressIndicator(
            //       strokeWidth: 2.0, value: downloadProgress.progress),
            // ),

            errorWidget: (context, url, error) =>
                const Center(child: Icon(Icons.error)),
          ),

          //  Image.network(
          //   imageUrl ?? errorImage,
          //   fit: BoxFit.cover,
          // ),
        ),
      ),
      // ),
    );
  }
}
