import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;

class ShareService {
  static Future<void> shareImage({
    required String? storyUrl,
    required String? text,
  }) async {
    try {
      // _storyController.pause();
      if (storyUrl != null) {
        final response = await http.get(Uri.parse(storyUrl));

        final bytes = response.bodyBytes;
        final temp = await getTemporaryDirectory();
        final imagePath = '${temp.path}/image.jpg';
        File(imagePath).writeAsBytesSync(bytes);
        print('Image path --$imagePath');

        await Share.shareFiles([imagePath], text: text ?? '');
        // _storyController.play();
      }
    } catch (error) {
      print('Error sharing story');
    }
  }
}
