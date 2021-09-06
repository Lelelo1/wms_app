import 'dart:typed_data';

import 'package:google_ml_vision/google_ml_vision.dart';

class AbstractImage {
  //Object raw; // used on ios only
  //double width;
  //double height;
  GoogleVisionImageMetadata imageMetaData;
  //List<GoogleVisionImagePlaneMetadata> planeData;
  //List<Uint8List> planeBytes;
  Uint8List concatenatedPlanes;

  AbstractImage(this.imageMetaData, this.concatenatedPlanes);
}
