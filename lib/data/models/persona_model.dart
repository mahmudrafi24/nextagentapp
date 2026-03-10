enum PersonaMode {
  assistant,
  studyHelper,
  workAssistant,
  creativeWriter,
  casualChat,
}

class PersonaModel {
  final PersonaMode mode;
  final String name;
  final String description;
  final String icon;

  const PersonaModel({
    required this.mode,
    required this.name,
    required this.description,
    required this.icon,
  });

  static const List<PersonaModel> defaultPersonas = [
    PersonaModel(
      mode: PersonaMode.assistant,
      name: 'Smart Assistant',
      description: 'Balanced helper for everyday tasks',
      icon: '🤖',
    ),
    PersonaModel(
      mode: PersonaMode.studyHelper,
      name: 'Study Helper',
      description: 'Patient tutor that explains step-by-step',
      icon: '📚',
    ),
    PersonaModel(
      mode: PersonaMode.workAssistant,
      name: 'Work Assistant',
      description: 'Professional and productivity-focused',
      icon: '💼',
    ),
    PersonaModel(
      mode: PersonaMode.creativeWriter,
      name: 'Creative Writer',
      description: 'Imaginative storytelling partner',
      icon: '✨',
    ),
    PersonaModel(
      mode: PersonaMode.casualChat,
      name: 'Casual Chat',
      description: 'Friendly and conversational companion',
      icon: '😊',
    ),
  ];
}
