// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class AvatarHero extends StatelessWidget {
  final String tag;
  final double radius;
  final String? imageUrl;
  final bool showBorder;
  final bool isUploading;
  final VoidCallback? onEdit;

  const AvatarHero({
    super.key,
    required this.tag,
    required this.radius,
    this.imageUrl,
    this.showBorder = false,
    this.isUploading = false,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final avatar = CircleAvatar(
      radius: radius,
      backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
      backgroundColor: Colors.grey[300],
      child: imageUrl == null
          ? const Icon(Icons.person, size: 50, color: Colors.white)
          : null,
    );

    return Hero(
      tag: tag,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 🔹 Border optional
          if (showBorder)
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.orange, width: 4),
              ),
              child: avatar,
            )
          else
            avatar,

          // 🔹 Spinner saat upload
          if (isUploading)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                  ),
                ),
              ),
            ),

          // 🔹 Tombol edit (hanya kalau ada callback)
          if (onEdit != null)
            Positioned(
              bottom: 0,
              right: 0,
              child: InkWell(
                onTap: onEdit,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.orange[700],
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(Icons.edit, size: 18, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
