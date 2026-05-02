import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import '../themes/colors.dart';

class StudyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const StudyAppBar({
    super.key,
    required this.title,
    this.onSettingsTap,
  });

  final String title;
  final VoidCallback? onSettingsTap;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: GestureDetector(
        onTap: () => Navigator.of(context).maybePop(),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: 8),
            Icon(TablerIcons.arrow_left, size: 18),
            SizedBox(width: 2),
            Text(
              'Back',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
      leadingWidth: 80,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        overflow: TextOverflow.ellipsis,
      ),
      actions: [
        IconButton(
          icon: const Icon(
            TablerIcons.adjustments_horizontal,
            color: AppColors.primary,
          ),
          onPressed: onSettingsTap,
        ),
      ],
    );
  }
}
