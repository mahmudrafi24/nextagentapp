import '../../core/errors/exceptions.dart';
import '../../core/errors/result.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/note.dart';
import '../../domain/repositories/notes_repository.dart';
import '../datasources/local/hive_service.dart';
import '../datasources/remote/openclaw_api_service.dart';
import '../models/note_model.dart';
import '../models/persona_prompts.dart';

class NotesRepositoryImpl implements NotesRepository {
  final HiveService _hiveService;
  final OpenClawApiService _apiService;
  final NetworkInfo _networkInfo;

  NotesRepositoryImpl({
    required HiveService hiveService,
    required OpenClawApiService apiService,
    required NetworkInfo networkInfo,
  })  : _hiveService = hiveService,
        _apiService = apiService,
        _networkInfo = networkInfo;

  @override
  Future<Result<List<Note>>> getAllNotes() async {
    try {
      final maps = _hiveService.getAllNotes();
      final notes = maps.map((m) => NoteModel.fromMap(m) as Note).toList();
      notes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      return Success(notes);
    } catch (e) {
      return Error(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> addNote(Note note) async {
    try {
      final model = NoteModel.fromEntity(note);
      await _hiveService.saveNote(model.toMap());
      return const Success(null);
    } catch (e) {
      return Error(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> updateNote(Note note) async {
    try {
      final model = NoteModel.fromEntity(note);
      await _hiveService.saveNote(model.toMap());
      return const Success(null);
    } catch (e) {
      return Error(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> deleteNote(String id) async {
    try {
      await _hiveService.deleteNote(id);
      return const Success(null);
    } catch (e) {
      return Error(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<String>> summarizeNote(String content) async {
    if (!await _networkInfo.isConnected) {
      return const Error(NetworkFailure());
    }

    try {
      final response = await _apiService.sendMessage(
        messages: [
          {'role': 'user', 'content': content},
        ],
        systemPrompt: PersonaPrompts.summarizePrompt,
        maxTokens: 512,
      );
      return Success(response);
    } on ServerException catch (e) {
      return Error(ApiFailure(e.message, statusCode: e.statusCode));
    } catch (e) {
      return Error(ApiFailure(e.toString()));
    }
  }
}
