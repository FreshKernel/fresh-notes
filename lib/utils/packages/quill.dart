import 'dart:convert';
import 'dart:io';

import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../../core/errors/exceptions.dart';
import '../../core/log/logger.dart';
import '../../core/utils/platform_checker.dart';
import '../bool.dart';

typedef QuillDocument = quill.Document;

class QuillUtilities {
  const QuillUtilities._();

  static quill.Document getFromJsonString(String jsonDocument) =>
      quill.Document.fromJson(jsonDecode(jsonDocument));

  static Future<List<String>> saveCachedImagesToDocumentDirectory({
    required Iterable<String> cachedImages,
  }) async {
    // If we are able to create the database then we should not
    // get MissingPlatformDirectoryException but only in rare cases
    final documentsDir = await getApplicationDocumentsDirectory();

    final newImagesFutures = cachedImages.map((cachedImagePath) async {
      final cachedImageFile = File(cachedImagePath);
      final newImageFileExtensionWithDot = path.extension(cachedImagePath);
      final newImageFileName =
          'note-image-${DateTime.now().toIso8601String()}$newImageFileExtensionWithDot';
      final newImagePath = path.join(documentsDir.path, newImageFileName);
      final newImageFile = await cachedImageFile.copy(newImagePath);
      return newImageFile.path;
    });
    // Await for the saving process for each image
    final newImages = await Future.wait(newImagesFutures);
    return newImages;
  }

  // TODO: After save a note with image in it, there is a bug
  // and click on the note again to update it, and then remove the
  // image without remove the note, the note actually will not
  // deleted, I will fix that bug in the future.

  // TODO: Also don't forgot to reset cache of the app in emulator after all the tests
  // of notes functionallities and see if the images still there
  static Future<void> deleteAllImagesOfNote(String jsonDocument) async {
    final document = QuillUtilities.getFromJsonString(jsonDocument);
    final imagesPaths =
        QuillUtilities.getLocalImagesPathsFromDocument(document);
    for (final image in imagesPaths) {
      final imageFile = File(image);
      final fileExists = await imageFile.exists();
      if (!fileExists) {
        AppLogger.error(
          'We could not remove file: $image \nsince it does not exists.',
        );
        return;
      }
      final deletedFile = await imageFile.delete();
      final deletedFileStillExists = await deletedFile.exists();
      if (deletedFileStillExists) {
        throw const AppException(
          'We have successfully deleted the file and it is still exists!!',
        );
      }
      AppLogger.log('We have successfully deleted image in: $image');
    }
  }

  static Iterable<String> getLocalImagesPathsFromDocument(
    quill.Document document,
  ) {
    final images = document.root.children
        .whereType<quill.Line>()
        .where((node) {
          if (node.isEmpty) {
            return false;
          }
          final firstNode = node.children.first;
          if (firstNode is! quill.Embed) {
            return false;
          }

          if (firstNode.value.type != quill.BlockEmbed.imageType) {
            return false;
          }
          final imageSource = firstNode.value.data;
          if (imageSource is! String) {
            return false;
          }
          if (isHttpBasedUrl(imageSource)) {
            return false;
          }
          return imageSource.trim().isNotEmpty;
        })
        .toList()
        .map((e) => (e.children.first as quill.Embed).value.data as String);
    return images;
  }

  /// I'm too lazy to write comments to explain
  /// the logic, but when I work with team I will.
  static Future<Iterable<String>>
      getCachedImagePathsFromDocumentAndMakeSureItExists(
    quill.Document document,
  ) async {
    final imagePaths = getLocalImagesPathsFromDocument(document);

    final cachesImagePaths = imagePaths.where((imagePath) {
      // We don't want the not cached images to be saved again in
      // the function insertOrReplaceOne
      // Since when we update the note, we only want to save
      // The new images in the note after edit it

      // TODO: Hardcoded and could be different from platform to another
      if (PlatformChecker.isAndroid()) {
        if (!imagePath.contains('cache')) {
          return false;
        }
      }
      if (PlatformChecker.isAppleSystem()) {
        if (!imagePath.contains('tmp')) {
          return false;
        }
      }
      return true;
    }).toList();
    // Remove all the images that doesn't exists
    for (final imagePath in cachesImagePaths) {
      final file = File(imagePath);
      final exists = await file.exists();
      if (!exists) {
        AppLogger.error(
          'This path: $imagePath has index of cacges image paths in notes data service is does not exists, maybe the user deleted it in root or another way.',
          stackTrace: StackTrace.current,
        );
        final index = cachesImagePaths.indexOf(imagePath);
        if (index == -1) {
          throw AppException(
              'This path: $imagePath has index of cacges image paths in notes data service is -1');
        }
        cachesImagePaths.removeAt(index);
        cachesImagePaths.insert(
          index,
          'https://images.uncyclomedia.co/uncyclopedia/en/thumb/0/0e/No_image.PNG/300px-No_image.PNG',
        ); // TODO: Change this later or remove it
      }
    }
    return cachesImagePaths;
  }
}
