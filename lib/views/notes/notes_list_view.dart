import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mynotes/services/crud/notes_services.dart';
import 'package:mynotes/utilities/dialog/delete_dialog.dart';

typedef DeleteNoteCallback = void Function(DatabaseNote note); 

class NotesListView extends StatelessWidget {

final List<DatabaseNote> notes;
final DeleteNoteCallback onDeleteNote;

  const NotesListView({super.key, required this.notes, required this.onDeleteNote});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
                          itemCount: notes.length,
                          itemBuilder: (context, index) {
                            final note = notes.elementAt(index);
                            return ListTile(
                              title: Text(
                                note.text,
                                maxLines: 1,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: IconButton(
                                onPressed: () async {
                                  final shouldDelete = await deleteDialog(context);
                                  if (shouldDelete) {
                                    onDeleteNote(note);
                                  }
                                }, 
                                icon: const Icon(Icons.delete),
                              ),
                            );
                          },
                        );
  }
}