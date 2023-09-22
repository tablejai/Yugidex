import "dart:typed_data";

import "package:flutter_cache_manager/flutter_cache_manager.dart";
import "firebase_utils.dart";

class FirebaseCacheManager {
  final _storageRef = getStorageRef();
  final _defaultCacheManager = DefaultCacheManager();

  Future<String?> cacheImage(String imagePath) async {
    final pathRef = _storageRef.child(imagePath);

    final imageUrl = await pathRef.getDownloadURL();

    if ((await _defaultCacheManager.getFileFromCache(imageUrl))?.file == null) {
      final Uint8List? imageBytes = await pathRef.getData();

      // Put the image file in the cache
      await _defaultCacheManager.putFile(
        imageUrl,
        imageBytes!,
        fileExtension: "jpg",
      );
    }
    return imageUrl;
  }
}
