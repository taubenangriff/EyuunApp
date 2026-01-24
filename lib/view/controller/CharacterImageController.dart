import 'package:cross_file_image/cross_file_image.dart';
import 'package:eyuunapp/services/ImageService.dart';
import 'package:eyuuncore/components/CharacterBase.dart';
import 'package:eyuuncore/GetIt.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class CharacterImageController {
  ImageProvider? image;
  XFile? imageFile;

  final CharacterBaseComponent characterBase;

  CharacterImageController(this.characterBase);

  changeImage(XFile file){
    image = XFileImage(file);
    imageFile = file;
  }

  hasImage() => image != null;

  finalize() async {
    if(imageFile == null){
      throw StateError("Cannot finalize without having picked an image!!");
    }
    var uri = await locator<ImageService>().uploadImage(imageFile!);
    characterBase.image = uri;
  }
}