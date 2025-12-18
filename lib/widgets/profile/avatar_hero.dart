// lib/widgets/profile/avatar_hero.dart
// unified AvatarHero (supports optional edit + Hero animation)
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
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final onPrimary = theme.colorScheme.onPrimary;
    final onSurfaceVariant = theme.colorScheme.onSurfaceVariant;

    // Base avatar
    final avatar = CircleAvatar(
      radius: radius,
      backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
      backgroundColor: theme.colorScheme.surfaceContainerHighest,
      child: imageUrl == null
          ? Icon(Icons.person, size: radius * 0.9, color: onSurfaceVariant)
          : null,
    );

    // If showBorder, wrap with a circular border container
    final widgetAvatar = showBorder
        ? Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: primary, width: 3),
            ),
            child: ClipOval(child: avatar),
          )
        : avatar;

    return Hero(
      tag: tag,
      child: Material(
        type: MaterialType.transparency,
        child: SizedBox(
          width: radius * 2,
          height: radius * 2,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // avatar (with optional border)
              widgetAvatar,

              // loading overlay when uploading
              if (isUploading)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.35),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: SizedBox(
                        width: radius * 0.6,
                        height: radius * 0.6,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation(primary),
                        ),
                      ),
                    ),
                  ),
                ),

              // edit button (only shown if onEdit != null)
              if (onEdit != null)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Material(
                    color: Colors.transparent,
                    shape: const CircleBorder(),
                    child: InkWell(
                      onTap: isUploading ? null : onEdit,
                      customBorder: const CircleBorder(),
                      child: Container(
                        width: radius * 0.38,
                        height: radius * 0.38,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: primary,
                          border: Border.all(
                            color: theme.colorScheme.surface,
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons.edit,
                          size: radius * 0.18,
                          color: onPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
