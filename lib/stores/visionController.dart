// note, don't know if 'controller' is the right appending name
// the class is supposed to be called from each page, and it will
// will call service and error handle them

import 'package:camera/camera.dart';

class VisionController {
  // should really be a 'AbstractImage' but the classes inside 'CameraImage'
  // is a bit tricky to get out and absta
  CameraImage currentImage;
}
