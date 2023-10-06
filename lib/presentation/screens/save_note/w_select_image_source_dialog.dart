import 'package:flutter/material.dart';
import 'package:flutter_quill_extensions/embeds/embed_types.dart';

class SelectImageSourceDialog extends StatelessWidget {
  const SelectImageSourceDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              title: const Text('Gallery'),
              subtitle: const Text(
                'Pick a photo from your gallery',
              ),
              leading: const Icon(Icons.photo_sharp),
              onTap: () => Navigator.of(context).pop(MediaPickSetting.Gallery),
            ),
            ListTile(
              title: const Text('Camera'),
              subtitle: const Text(
                'Take a photo using your phone camera',
              ),
              leading: const Icon(Icons.camera),
              onTap: () => Navigator.of(context).pop(MediaPickSetting.Camera),
            ),
            ListTile(
              title: const Text('Link'),
              subtitle: const Text(
                'Paste a photo using https link',
              ),
              leading: const Icon(Icons.link),
              onTap: () => Navigator.of(context).pop(MediaPickSetting.Link),
            ),
          ],
        ),
      ),
    );
  }
}
