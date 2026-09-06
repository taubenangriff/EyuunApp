import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

abstract class ImageService {
  Future<Uri?> uploadImage(XFile image) async {
    throw UnimplementedError();
  }

  Future<ImageProvider> getImage(Uri image) async {
    throw UnimplementedError();
  }
}

class FirebaseImageService implements ImageService {
  static const _collection = 'images';
  static const _maximumImageBytes = 900 * 1024;

  @override
  Future<ImageProvider<Object>> getImage(Uri image) async {
    if (image.scheme != 'firestore' ||
        image.host != _collection ||
        image.pathSegments.length != 1) {
      throw ArgumentError.value(
          image, 'image', 'Expected a Firestore image URI');
    }

    final snapshot = await FirebaseFirestore.instance
        .collection(_collection)
        .doc(image.pathSegments.single)
        .get();
    final data = snapshot.data();
    final bytes = data?['bytes'];
    if (!snapshot.exists || bytes is! Blob) {
      throw StateError('Image does not exist or has invalid data: $image');
    }

    return MemoryImage(bytes.bytes);
  }

  @override
  Future<Uri?> uploadImage(XFile image) async {
    try {
      final imageLength = await image.length();
      if (imageLength > _maximumImageBytes) {
        return null;
      }

      final bytes = await image.readAsBytes();
      final documentId = const Uuid().v4();
      await FirebaseFirestore.instance
          .collection(_collection)
          .doc(documentId)
          .set({
        'bytes': Blob(bytes),
        'contentType': image.mimeType,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return Uri(scheme: 'firestore', host: _collection, path: documentId);
    } on Exception {
      return null;
    }
  }
}
