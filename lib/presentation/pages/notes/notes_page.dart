import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/app_date_utils.dart';
import '../../../core/widgets/error_snackbar.dart';
import '../../../domain/entities/note.dart';
import '../../../domain/repositories/notes_repository.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final _notesRepo = Get.find<NotesRepository>();
  final _notes = <Note>[].obs;
  final _isLoading = false.obs;
  final _uuid = const Uuid();

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    _isLoading.value = true;
    final result = await _notesRepo.getAllNotes();
    result.fold(
      (failure) => showErrorSnackbar(failure.message),
      (data) => _notes.assignAll(data),
    );
    _isLoading.value = false;
  }

  void _createNote() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text('New Note'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                hintText: 'Title',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: contentController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Write your note...',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (titleController.text.trim().isEmpty) return;
              final now = DateTime.now();
              final note = Note(
                id: _uuid.v4(),
                title: titleController.text.trim(),
                content: contentController.text.trim(),
                createdAt: now,
                updatedAt: now,
              );
              final result = await _notesRepo.addNote(note);
              result.fold(
                (failure) => showErrorSnackbar(failure.message),
                (_) {
                  _notes.insert(0, note);
                  Get.back();
                  showSuccessSnackbar('Note created!');
                },
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _summarizeNote(Note note) async {
    if (note.content.isEmpty) return;

    Get.snackbar('Summarizing...', 'AI is generating a summary',
        snackPosition: SnackPosition.BOTTOM,
        showProgressIndicator: true);

    final result = await _notesRepo.summarizeNote(note.content);
    result.fold(
      (failure) => showErrorSnackbar(failure.message),
      (summary) async {
        final updated = note.copyWith(
          summary: summary,
          updatedAt: DateTime.now(),
        );
        await _notesRepo.updateNote(updated);
        final index = _notes.indexWhere((n) => n.id == note.id);
        if (index != -1) _notes[index] = updated;
        showSuccessSnackbar('Summary generated!');
      },
    );
  }

  Future<void> _deleteNote(String id) async {
    final result = await _notesRepo.deleteNote(id);
    result.fold(
      (failure) => showErrorSnackbar(failure.message),
      (_) => _notes.removeWhere((n) => n.id == id),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Smart Notes',
          style: AppTextStyles.heading3.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNote,
        child: const Icon(Icons.add),
      ),
      body: Obx(() {
        if (_isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_notes.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.note_outlined,
                    size: 64, color: AppColors.textMuted),
                const SizedBox(height: 16),
                Text(
                  'No notes yet',
                  style: AppTextStyles.heading3.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap + to create your first note',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _notes.length,
          itemBuilder: (context, index) {
            final note = _notes[index];
            return _buildNoteCard(context, note);
          },
        );
      }),
    );
  }

  Widget _buildNoteCard(BuildContext context, Note note) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  note.title,
                  style: AppTextStyles.heading3.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 16,
                  ),
                ),
              ),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert,
                    color: AppColors.textMuted, size: 20),
                onSelected: (value) {
                  if (value == 'summarize') _summarizeNote(note);
                  if (value == 'delete') _deleteNote(note.id);
                },
                itemBuilder: (_) => [
                  const PopupMenuItem(
                    value: 'summarize',
                    child: Row(
                      children: [
                        Icon(Icons.auto_awesome, size: 18),
                        SizedBox(width: 8),
                        Text('AI Summarize'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline,
                            size: 18, color: AppColors.error),
                        SizedBox(width: 8),
                        Text('Delete',
                            style: TextStyle(color: AppColors.error)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (note.content.isNotEmpty)
            Text(
              note.content.length > 150
                  ? '${note.content.substring(0, 150)}...'
                  : note.content,
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          if (note.summary != null) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.auto_awesome,
                          size: 14, color: AppColors.accent),
                      const SizedBox(width: 6),
                      Text(
                        'AI Summary',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.accent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    note.summary!,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.accent,
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 8),
          Text(
            AppDateUtils.formatRelative(note.updatedAt),
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
