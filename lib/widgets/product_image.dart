import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  final String image;
  final BoxFit fit;

  const ProductImage({super.key, required this.image, this.fit = BoxFit.cover});

  @override
  Widget build(BuildContext context) {
    if (image.isEmpty) {
      return Container(
        color: Colors.grey[200],
        child: const Center(child: Icon(Icons.image_not_supported, color: Colors.grey)),
      );
    }
    
    // Handle data URIs (base64)
    if (image.startsWith('data:')) {
      try {
        final base64String = image.split(',').last;
        final Uint8List bytes = base64Decode(base64String);
        return Image.memory(
          bytes,
          fit: fit,
          errorBuilder: (context, error, stackTrace) {
             return Container(
                color: Colors.grey[200],
                child: const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
              );
          },
        );
      } catch (e) {
         return Container(
            color: Colors.grey[200],
            child: const Center(child: Icon(Icons.error_outline, color: Colors.red)),
          );
      }
    }

    if (image.startsWith('http')) {
      return Image.network(
        image,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[200],
            child: const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
      );
    }
    
    return Image.asset(
      image,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
         return Container(
            color: Colors.grey[200],
            child: const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
          );
      },
    );
  }
}
