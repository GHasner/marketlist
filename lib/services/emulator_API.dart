import 'package:gallery_saver/gallery_saver.dart';

class EmulatorAPI {
  static void addImageToGallery(String imgPath) {
    GallerySaver.saveImage(imgPath);
  }
}