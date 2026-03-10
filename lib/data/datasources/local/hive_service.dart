import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/constants/storage_keys.dart';

class HiveService {
  Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox<String>(HiveBoxes.chatHistory);
    await Hive.openBox<String>(HiveBoxes.todos);
    await Hive.openBox<String>(HiveBoxes.notes);
  }

  // Chat History
  Box<String> get _chatBox => Hive.box<String>(HiveBoxes.chatHistory);

  Future<void> saveChatMessage(
      String conversationId, Map<String, dynamic> message) async {
    final key = '${conversationId}_${message['id']}';
    await _chatBox.put(key, jsonEncode(message));
  }

  List<Map<String, dynamic>> getChatHistory(String conversationId) {
    final messages = <Map<String, dynamic>>[];
    for (final key in _chatBox.keys) {
      if (key.toString().startsWith('${conversationId}_')) {
        final data = _chatBox.get(key);
        if (data != null) {
          messages.add(jsonDecode(data) as Map<String, dynamic>);
        }
      }
    }
    messages.sort((a, b) =>
        (a['timestamp'] as String).compareTo(b['timestamp'] as String));
    return messages;
  }

  Future<void> clearChatHistory(String conversationId) async {
    final keysToDelete = _chatBox.keys
        .where((key) => key.toString().startsWith('${conversationId}_'))
        .toList();
    for (final key in keysToDelete) {
      await _chatBox.delete(key);
    }
  }

  List<String> getConversationIds() {
    final ids = <String>{};
    for (final key in _chatBox.keys) {
      final parts = key.toString().split('_');
      if (parts.isNotEmpty) {
        ids.add(parts[0]);
      }
    }
    return ids.toList();
  }

  // Todos
  Box<String> get _todoBox => Hive.box<String>(HiveBoxes.todos);

  Future<void> saveTodo(Map<String, dynamic> todo) async {
    await _todoBox.put(todo['id'], jsonEncode(todo));
  }

  List<Map<String, dynamic>> getAllTodos() {
    return _todoBox.values
        .map((e) => jsonDecode(e) as Map<String, dynamic>)
        .toList();
  }

  Future<void> deleteTodo(String id) async {
    await _todoBox.delete(id);
  }

  // Notes
  Box<String> get _notesBox => Hive.box<String>(HiveBoxes.notes);

  Future<void> saveNote(Map<String, dynamic> note) async {
    await _notesBox.put(note['id'], jsonEncode(note));
  }

  List<Map<String, dynamic>> getAllNotes() {
    return _notesBox.values
        .map((e) => jsonDecode(e) as Map<String, dynamic>)
        .toList();
  }

  Future<void> deleteNote(String id) async {
    await _notesBox.delete(id);
  }

  // Clear all
  Future<void> clearAll() async {
    await _chatBox.clear();
    await _todoBox.clear();
    await _notesBox.clear();
  }
}
