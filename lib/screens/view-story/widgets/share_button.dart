import 'package:flutter/material.dart';
import '/services/services.dart';
import '/widgets/gradient_circle_button.dart';

class ShareButton extends StatelessWidget {
  final String? storyUrl;
  final String? caption;
  const ShareButton({
    Key? key,
    required this.storyUrl,
    required this.caption,
  }) : super(key: key);

  Future<void> _share() async {
    try {
      if (storyUrl != null) {
        await ShareService.shareImage(storyUrl: storyUrl, text: caption);
      }
    } catch (error) {
      print('Error sharing story');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientCircleButton(
      size: 40.0,
      onTap: _share,
      icon: Icons.share,
    );
  }
}
