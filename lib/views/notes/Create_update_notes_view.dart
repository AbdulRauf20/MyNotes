import 'package:flutter/material.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/utilities/dialogs/cannot_share_empty_note.dart';
import 'package:mynotes/utilities/generics/get_argument.dart';
import 'package:mynotes/services/cloud/cloud_note.dart';
import 'package:mynotes/services/cloud/firebase_cloud_stroage.dart';
import 'package:share_plus/share_plus.dart';

class CreateUpdateNoteView extends StatefulWidget {
  const CreateUpdateNoteView({super.key});

  @override
  State<CreateUpdateNoteView> createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {
  CloudNote? _note;
  late final FirebaseCloudStroage _notesService;
  late final TextEditingController _textConrtoller;

  @override
  void initState() {
    super.initState();
    _notesService = FirebaseCloudStroage();
    _textConrtoller = TextEditingController();
  }

  void _textConrtollerListener() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _textConrtoller.text;
    await _notesService.updateNote(documentId: note.documentId, text: text); 
  }

  void _setupTextControllerListener() {
    _textConrtoller.removeListener(_textConrtollerListener);
    _textConrtoller.addListener(_textConrtollerListener);
  }

  Future<CloudNote> CreateOrGetExistingNote(BuildContext) async {
    final widgetNote = context.getArugment<CloudNote>();

    if (widgetNote != null) {
      _note = widgetNote;
      _textConrtoller.text = widgetNote.text;
      return widgetNote;
    }

    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }
    final currentUser = AuthService.firebase().currentUser!;
    final email = currentUser.email;
    final userID = currentUser.id;
    final newNote = await _notesService.createNewNote(ownerUserId: userID);
    _note = newNote;
    return newNote;
  }

  void _deleteNoteIfTextIsEmpty() {
    final note = _note;
    if (_textConrtoller.text.isEmpty && note != null) {
      _notesService.DeleteNote(documentId: note.documentId);
    } 
  }

  void _saveNoteIfTextNotEmpty() async {
    final note = _note;
    final text = _textConrtoller.text;
    if (note != null && text.isNotEmpty) {
      await _notesService.updateNote(documentId: note.documentId, text: text);
    }
  }

  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextNotEmpty();
    _textConrtoller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Note'),
      actions :[
        IconButton(onPressed: () async{ 
          final text = _textConrtoller.text;
          if(_note == null || text.isEmpty){
            await showCannotShareEmptyNotesDialog(context);
          }else{
            Share.share(text);
          }

        }, icon: const Icon(Icons.share))
      ],
      )
      
      ,
      body: FutureBuilder(
        future: CreateOrGetExistingNote(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _setupTextControllerListener();
              return TextField(
                controller: _textConrtoller,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: 'write your new note here....',
                ),
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
