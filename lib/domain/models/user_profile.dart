class UserProfile {
  const UserProfile({
    required this.name,
    required this.email,
    required this.mp,
    required this.streakDays,
    required this.avatarInitials,
  });

  final String name;
  final String email;
  final int mp;
  // List of 28 booleans indicating study activity for each day (last 4 weeks)
  final List<bool> streakDays;
  final String avatarInitials;
}
