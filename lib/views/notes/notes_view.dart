import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/enums/menu_action.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/cloud/cloud_note.dart';
import 'package:mynotes/services/cloud/firebase_cloud_stroage.dart';
import 'package:mynotes/utilities/dialog/logOut_dialog.dart';
import 'package:mynotes/views/notes/notes_list_view.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final FirebaseCloudStroage _notesService;
  String get userID => AuthService.firebase().currentUser?.id ?? '';

  @override
  void initState() {
    _notesService = FirebaseCloudStroage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Notes'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(createUpdateNoteRoute);
            },
            icon: const Icon(Icons.add),
          ),

          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final ShouldLogOut = await showLogOutDialog(context);
                  if (ShouldLogOut) {
                    context.read<AuthBloc>().add(const AuthEventLogOut());
                  }
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text("Logout"),
                ),
              ];
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _notesService.allNotes(ownerUserId: userID),
        builder: (context, notesSnapshot) {
          switch (notesSnapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (notesSnapshot.hasData) {
                final allNotes = notesSnapshot.data as Iterable<CloudNote>;
                return NotesListView(
                  notes: allNotes.toList(),
                  onDeleteNote: (note) async {
                    await _notesService.DeleteNote(documentId: note.documentId);
                  },
                  onTap: (note) {
                    Navigator.of(
                      context,
                    ).pushNamed(createUpdateNoteRoute, arguments: note);
                  },
                );
              } else {
                return const CircularProgressIndicator();
              }
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
