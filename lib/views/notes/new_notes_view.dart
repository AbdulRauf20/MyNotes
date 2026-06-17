import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/crud/notes_services.dart';

class NewNotesView extends StatefulWidget {
  const NewNotesView({super.key});

  @override
  State<NewNotesView> createState() => _NewNotesViewState();
}

class _NewNotesViewState extends State<NewNotesView> {


@override
void initState() {
  super.initState();
  _notesService = NotesService();
  _textConrtoller = TextEditingController();
}

void _textConrtollerListener() async {
  final note = _note;
  if (note == null) {
    return;
  }
  final text = _textConrtoller.text;
  await _notesService.updateNote(note: note, text: text);
}

void _setupTextControllerListener() {
  _textConrtoller.removeListener(_textConrtollerListener);
  _textConrtoller.addListener(_textConrtollerListener);
}

  DatabaseNote? _note;
  late final NotesService _notesService;
  late final TextEditingController _textConrtoller;

  Future<DatabaseNote> createNewNote() async {
    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }
    final currentUser = AuthService.firebase().currentUser!;
    final email = currentUser.email!;
    final owner = await _notesService.getUser(email: email);
    return await _notesService.createNote(owner: owner);
  }

  void _deleteNoteIfTextIsEmpty() {
    final note = _note;
    if (_textConrtoller.text.isEmpty && note != null) {
      _notesService..deleteNote(id: note.id);
    }
  }

  void _saveNoteIfTextNotEmpty() async {
    final note = _note;
    final text = _textConrtoller.text;
    if (note != null && text.isNotEmpty) {
      await _notesService.updateNote(note: note, text: text);
    }
  }

  @override
  void dispose(){
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextNotEmpty();
    _textConrtoller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Note')),
      body: const Text('write your new note here....'),
    );
  }
}
