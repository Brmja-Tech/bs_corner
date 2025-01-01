import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FlexibleImage extends StatelessWidget {
  final dynamic imagePathOrData;
  final double borderRadius;
  final bool isCircular;
  final Widget? placeholder;
  final double? width;
  final double? height;

  const FlexibleImage({
    super.key,
    required this.imagePathOrData,
    this.borderRadius = 0.0,
    this.isCircular = false,
    this.placeholder,
    this.width,
    this.height,
  });

  bool _isNetworkImage(String path) {
    return Uri.tryParse(path)?.hasAbsolutePath ?? false;
  }

  bool _isFileImage(String path) {
    return File(path).existsSync();
  }

  bool _isMemoryImage(dynamic data) {
    return data is Uint8List;
  }

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;
    if (imagePathOrData is String) {
      if (_isFileImage(imagePathOrData)) {
        imageWidget = Image.file(
          File(imagePathOrData),
          fit: BoxFit.cover,
        );
      } else if (_isNetworkImage(imagePathOrData)) {
        imageWidget = CachedNetworkImage(
          imageUrl: imagePathOrData,
          placeholder: (context, url) => SizedBox(
            width: 25,
            height: 25,
            child:
                Center(child: placeholder ?? const CircularProgressIndicator()),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
          fit: BoxFit.cover,
        );
      } else {
        imageWidget = Image.asset(
          imagePathOrData,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.image_not_supported),
        );
      }
    } else if (_isMemoryImage(imagePathOrData)) {
      imageWidget = Image.memory(
        imagePathOrData,
        fit: BoxFit.cover,
      );
    } else {
      imageWidget = placeholder ?? const Icon(Icons.image);
    }

    return ClipRRect(
      borderRadius: isCircular
          ? BorderRadius.circular(1000)
          : BorderRadius.circular(borderRadius),
      child: SizedBox(
        width: width,
        height: height,
        child: imageWidget,
      ),
    );
  }
}
