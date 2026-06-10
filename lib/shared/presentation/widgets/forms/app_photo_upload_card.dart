import 'dart:io';

import 'package:flutter/material.dart';
import 'package:student_id/shared/presentation/theme/form_tokens.dart';

class AppPhotoUploadCard extends StatelessWidget {
  const AppPhotoUploadCard({
    super.key,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.imagePath,
    this.emptyIcon = Icons.add_a_photo_outlined,
  });

  final String title;
  final String? subtitle;
  final String? imagePath;
  final IconData emptyIcon;
  final VoidCallback onTap;

  bool get _hasImage => imagePath != null && imagePath!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(FormTokens.radiusMd),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(FormTokens.spacingMd),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(FormTokens.radiusMd),
          border: Border.all(
            color: _hasImage ? theme.colorScheme.primary : FormTokens.borderColor,
            width: _hasImage ? 1.5 : 1,
          ),
          color: FormTokens.surfaceMuted,
        ),
        child: _hasImage
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.check_circle_rounded,
                          color: theme.colorScheme.primary, size: 20),
                      const SizedBox(width: FormTokens.spacingXs),
                      Expanded(
                        child: Text(
                          title,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        'Change',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: FormTokens.spacingSm),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(FormTokens.radiusMd),
                    child: Image.file(
                      File(imagePath!),
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  Icon(
                    emptyIcon,
                    size: 40,
                    color: theme.colorScheme.primary.withValues(alpha: 0.7),
                  ),
                  const SizedBox(height: FormTokens.spacingSm),
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: FormTokens.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
      ),
    );
  }
}
