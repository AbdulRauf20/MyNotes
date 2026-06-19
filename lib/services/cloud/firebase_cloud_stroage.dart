import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynotes/services/cloud/cloud_Stroage_constants.dart';
import 'package:mynotes/services/cloud/cloud_Stroage_exceptions.dart';
import 'package:mynotes/services/cloud/cloud_note.dart';

class FirebaseCloudStroage {
  final notes = FirebaseFirestore.instance.collection('notes');

  Future<void> DeleteNote({required String documentId}) async {
    try {
      await notes.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteNoteException();
    }
  }

  Future<void> updateNote({
    required String documentId,
    required String text,
  }) async {
    try {
      await notes.doc(documentId).update({textfieldName: text});
    } catch (e) {
      throw CouldNotUpdateNoteException();
    }
  }

  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) =>
      notes.snapshots().map(
        (event) => event.docs
            .map((doc) => CloudNote.fromSnapshot(doc))
            .where((note) => note.ownerUserId == ownerUserId),
      );

  Future<Iterable<CloudNote>> getAllNotes({required String ownerUserId}) async {
    try {
      return await notes
          .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
          .get()
          .then(
            (value) => value.docs.map((doc) => CloudNote.fromSnapshot(doc)),
          );
    } catch (e) {
      throw CouldNotGetAllNotesException();
    }
  }

  Future<CloudNote> createNewNote({required String ownerUserId}) async {
    final document = await notes.add({
      ownerUserIdFieldName: ownerUserId,
      textfieldName: '',
    });
    final fetchedNote = await document.get();
    return CloudNote(
      documentId: fetchedNote.id,
      ownerUserId: ownerUserId,
      text: "",
    );
  }

  static final FirebaseCloudStroage _shared =
      FirebaseCloudStroage._sharedInstance();
  FirebaseCloudStroage._sharedInstance();
  factory FirebaseCloudStroage() => _shared;
}
