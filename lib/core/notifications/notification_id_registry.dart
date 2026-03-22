/// Centralized registry of local notification IDs.
///
/// ID ranges:
///   100–104  Prayer (fajr, dhuhr, asr, maghrib, isha)
///   200–202  Adhkar (morning, evening, sleep)
///   300–302  Lessons (morning, evening-incomplete, streak)
///   400–409  Random dhikr (10 rotating slots)
///   500      Friday occasion
///   10_000+  Admin campaign app-pull (delivery id mapped into range)
library;

abstract final class NotificationIds {
  // Prayer
  static const int fajr    = 100;
  static const int dhuhr   = 101;
  static const int asr     = 102;
  static const int maghrib = 103;
  static const int isha    = 104;

  // Adhkar
  static const int morningAdhkar = 200;
  static const int eveningAdhkar = 201;
  static const int sleepAdhkar   = 202;

  // Lessons
  static const int lessonMorning  = 300;
  static const int lessonEvening  = 301;
  static const int streakReminder = 302;

  // Random dhikr — 10 rotating slots
  static const int randomDhikrBase = 400;
  static int randomDhikrSlot(int slot) => randomDhikrBase + (slot % 10);

  // Occasions
  static const int fridayReminder = 500;

  static const int _adminCampaignBase = 10000;

  /// Stable OS notification id for an admin campaign delivery (avoids clashes with scheduled IDs).
  static int adminCampaignDelivery(int deliveryId) =>
      _adminCampaignBase + (deliveryId % 2000000);
}
