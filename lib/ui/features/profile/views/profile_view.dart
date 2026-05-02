import 'package:flashcard/ui/core/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import '../view_models/profile_view_model.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProfileViewModel>();
    final profile = vm.profile;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profile settings'),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          const SizedBox(height: 24),
          // Avatar
          Center(
            child: _Avatar(initials: profile.avatarInitials),
          ),
          const SizedBox(height: 12),
          // Email
          Center(
            child: Text(
              profile.email,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 4),
          // Name
          Center(
            child: Text(
              profile.name,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(height: 20),
          // MP row
          _MpRow(mp: profile.mp),
          const SizedBox(height: 16),
          // Streak grid
          _StreakGrid(streakDays: profile.streakDays),
          const SizedBox(height: 28),
          // Divider
          const Divider(color: AppColors.divider),
          const SizedBox(height: 8),
          // Menu items
          _MenuItem(
            label: 'Preferences',
            onTap: () {},
          ),
          _MenuItem(
            label: 'Change name',
            onTap: () {},
          ),
          _MenuItem(
            label: 'Change password',
            onTap: () {},
          ),
          _MenuItem(
            label: 'Contact Us',
            onTap: () {},
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.initials});
  final String initials;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary,
      ),
      child: Center(
        child: Text(
          initials.toUpperCase(),
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _MpRow extends StatelessWidget {
  const _MpRow({required this.mp});
  final int mp;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(TablerIcons.circle_filled, color: AppColors.mpGold, size: 14),
        const SizedBox(width: 6),
        Text(
          '$mp MP',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _StreakGrid extends StatelessWidget {
  const _StreakGrid({required this.streakDays});
  final List<bool> streakDays;

  @override
  Widget build(BuildContext context) {
    // 4 rows x 7 columns = 28 days
    const int cols = 7;
    final rows = (streakDays.length / cols).ceil();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List.generate(rows, (rowIdx) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            children: List.generate(cols, (colIdx) {
              final idx = rowIdx * cols + colIdx;
              final active = idx < streakDays.length && streakDays[idx];
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: Container(
                    height: 10,
                    decoration: BoxDecoration(
                      color: active
                          ? AppColors.streakActive
                          : AppColors.streakInactive,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      }),
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            const Icon(
              TablerIcons.chevron_right,
              size: 16,
              color: AppColors.textHint,
            ),
          ],
        ),
      ),
    );
  }
}
