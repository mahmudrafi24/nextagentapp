import '../../core/errors/result.dart';
import '../entities/note.dart';

abstract class NotesRepository {
  Future<Result<List<Note>>> getAllNotes();
  Future<Result<void>> addNote(Note note);
  Future<Result<void>> updateNote(Note note);
  Future<Result<void>> deleteNote(String id);
  Future<Result<String>> summarizeNote(String content);
}
