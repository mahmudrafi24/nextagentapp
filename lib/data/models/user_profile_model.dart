import '../../domain/entities/user_profile.dart';

class UserProfileModel extends UserProfile {
  const UserProfileModel({
    super.name,
    super.preferences,
    super.habits,
    super.timezone,
  });

  factory UserProfileModel.fromMap(Map<String, dynamic> map) {
    return UserProfileModel(
      name: map['name'] as String?,
      preferences: (map['preferences'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      habits: (map['habits'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      timezone: map['timezone'] as String? ?? 'UTC',
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'preferences': preferences,
        'habits': habits,
        'timezone': timezone,
      };

  factory UserProfileModel.fromEntity(UserProfile profile) {
    return UserProfileModel(
      name: profile.name,
      preferences: profile.preferences,
      habits: profile.habits,
      timezone: profile.timezone,
    );
  }
}
