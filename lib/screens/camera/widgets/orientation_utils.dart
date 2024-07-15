import 'dart:math';

import 'package:camerawesome/camerawesome_plugin.dart';



class OrientationUtils {
  static CameraOrientations convertRadianToOrientation(double radians) {
    late CameraOrientations orientation;
    if (radians == -pi / 2) {
      orientation = CameraOrientations.landscape_left;
    } else if (radians == pi / 2) {
      orientation = CameraOrientations.landscape_right;
    } else if (radians == 0.0) {
      orientation = CameraOrientations.portrait_up;
    } else if (radians == pi) {
      orientation = CameraOrientations.portrait_down;
    }

    return orientation;
  }

  static double convertOrientationToRadian(CameraOrientations orientation) {
    late double radians;
    switch (orientation) {
      case CameraOrientations.landscape_left:
        radians = -pi / 2;
        break;
      case CameraOrientations.landscape_right:
        radians = pi / 2;
        break;
      case CameraOrientations.portrait_up:
        radians = 0.0;
        break;
      case CameraOrientations.portrait_down:
        radians = pi;
        break;
      default:
    }
    return radians;
  }

  static bool isOnPortraitMode(CameraOrientations orientation) {
    return (orientation == CameraOrientations.portrait_down ||
        orientation == CameraOrientations.portrait_up);
  }
}
