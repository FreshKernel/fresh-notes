import 'package:flutter/material.dart';
import 'package:flutter_quill/translations.dart';
import 'package:go_router/go_router.dart';

import 'w_note_toolbar.dart';

class SelectImageSourceDialog extends StatelessWidget {
  const SelectImageSourceDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              title: Text(context.loc.gallery),
              subtitle: Text(
                context.loc.pickAPhotoFromYourGallery,
              ),
              leading: const Icon(Icons.photo_sharp),
              onTap: () => context.pop(InsertImageSource.gallery),
            ),
            ListTile(
              title: Text(context.loc.camera),
              subtitle: Text(
                context.loc.takeAPhotoUsingYourCamera,
              ),
              leading: const Icon(Icons.camera),
              onTap: () => context.pop(InsertImageSource.camera),
            ),
            ListTile(
              title: Text(context.loc.link),
              subtitle: Text(
                context.loc.pasteAPhotoUsingALink,
              ),
              leading: const Icon(Icons.link),
              onTap: () => context.pop(InsertImageSource.link),
            ),
          ],
        ),
      ),
    );
  }
}
