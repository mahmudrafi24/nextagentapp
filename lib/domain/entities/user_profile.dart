class UserProfile {
  final String? name;
  final List<String> preferences;
  final List<String> habits;
  final String timezone;

  const UserProfile({
    this.name,
    this.preferences = const [],
    this.habits = const [],
    this.timezone = 'UTC',
  });

  UserProfile copyWith({
    String? name,
    List<String>? preferences,
    List<String>? habits,
    String? timezone,
  }) {
    return UserProfile(
      name: name ?? this.name,
      preferences: preferences ?? this.preferences,
      habits: habits ?? this.habits,
      timezone: timezone ?? this.timezone,
    );
  }
}
