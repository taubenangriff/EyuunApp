import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

abstract class ImageService {
  Future<Uri?> uploadImage(XFile image) async {
    throw UnimplementedError();
  }

  Future<ImageProvider> getImage(Uri image) async {
    throw UnimplementedError();
  }
}

class FirebaseImageService implements ImageService {
  @override
  Future<ImageProvider<Object>> getImage(Uri image) {
    throw UnimplementedError();
  }

  @override
  Future<Uri?> uploadImage(XFile image) {
    throw UnimplementedError();
  }

}