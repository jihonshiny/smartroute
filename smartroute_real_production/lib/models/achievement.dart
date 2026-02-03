enum AchievementType {
  explorer, optimizer, earlyBird, nightOwl, foodie, traveler, social, consistent
}

class Achievement {
  final String id;
  final AchievementType type;
  final String title;
  final String description;
  final String icon;
  final int points;
  final bool unlocked;
  final DateTime? unlockedAt;
  final double progress;
  final double target;

  const Achievement({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.icon,
    required this.points,
    this.unlocked = false,
    this.unlockedAt,
    this.progress = 0.0,
    this.target = 1.0,
  });

  double get progressPercentage => (progress / target * 100).clamp(0, 100);
  bool get isCompleted => progress >= target;

  Achievement copyWith({
    bool? unlocked,
    DateTime? unlockedAt,
    double? progress,
  }) => Achievement(
        id: id,
        type: type,
        title: title,
        description: description,
        icon: icon,
        points: points,
        unlocked: unlocked ?? this.unlocked,
        unlockedAt: unlockedAt ?? this.unlockedAt,
        progress: progress ?? this.progress,
        target: target,
      );
}

class UserAchievements {
  final List<Achievement> achievements;
  final int totalPoints;
  final int level;
  final double levelProgress;

  const UserAchievements({
    required this.achievements,
    required this.totalPoints,
    required this.level,
    required this.levelProgress,
  });

  List<Achievement> get unlockedAchievements => achievements.where((a) => a.unlocked).toList();
  List<Achievement> get lockedAchievements => achievements.where((a) => !a.unlocked).toList();
  int get unlockedCount => unlockedAchievements.length;
}
