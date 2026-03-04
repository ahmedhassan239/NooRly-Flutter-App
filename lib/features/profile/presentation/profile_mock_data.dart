/// Mock data for Profile page

class ProfileMockData {
  ProfileMockData._();

  // User info
  static const String userName = 'Friend';
  static const String userRole = 'New Muslim';
  static const String userInitial = 'F';
  static const int currentDay = 7;
  static const int totalDays = 90;

  // Progress stats
  static const int streakDays = 6;
  static const int activeWeeks = 1;
  static const int daysLeft = 84;

  // Journey progress
  static const int lessonsCompleted = 6;
  static const int totalLessons = 90;
  static double get progressPercent => lessonsCompleted / totalLessons;
  static int get progressPercentInt => (progressPercent * 100).toInt();

  // Milestones
  static const List<MilestoneData> milestones = [
    MilestoneData(
      title: 'Week 1 Complete',
      status: MilestoneStatus.inProgress,
    ),
    MilestoneData(
      title: 'Week 2 Complete',
      status: MilestoneStatus.locked,
    ),
    MilestoneData(
      title: 'Week 3 Complete',
      status: MilestoneStatus.locked,
    ),
    MilestoneData(
      title: 'Week 4 Complete',
      status: MilestoneStatus.locked,
    ),
  ];

  // Personal info
  static const String? shahadaDate = null; // Not set
  static const String learningGoal = 'Understand faith basics';

  // App info
  static const String appVersion = 'v1.0.0';
}

enum MilestoneStatus {
  completed,
  inProgress,
  locked,
}

class MilestoneData {
  final String title;
  final MilestoneStatus status;

  const MilestoneData({
    required this.title,
    required this.status,
  });
}
