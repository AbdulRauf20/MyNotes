import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;
import 'package:path/path.dart' show join;


class NotesService {
  
}


class DatabaseUser {
  final int id;
  final String email;
  const DatabaseUser({required this.id, required this.email});

  DatabaseUser.fromRow(Map<String, Object?> map)
    : id = map[idColumn] as int,
      email = map[emailColumn] as String;

  @override
  String toString() => 'Person id= $id email= $email';

  @override
  bool operator ==(covariant DatabaseUser other) => other.id == id;

  @override
  int get hashCode => id.hashCode;
}

class DatabaseNote {
  final int id;
  final int userId;
  final String text;
  final bool isSynchedWithCloud;

  DatabaseNote({
    required this.id,
    required this.userId,
    required this.text,
    required this.isSynchedWithCloud,
  });

  DatabaseNote.fromRow(Map<String, Object?> map)
    : id = map[idColumn] as int,
      userId = map[userIdColumn] as int,
      text = map[textColumn] as String,
      isSynchedWithCloud = (map[isSynchedWithCloudColumn] as int) == 1
          ? true
          : false;

  @override
  String toString() =>
      'Note id= $id, userId= $userId, text= $text, isSynchedWithCloud= $isSynchedWithCloud';

  @override
  bool operator ==(covariant DatabaseNote other) => other.id == id;

  @override
  int get hashCode => id.hashCode;
}

const dbName = 'notes.db';
const notesTable = 'notes';
const userTable = 'users';
const idColumn = 'id';
const emailColumn = 'email';
const isSynchedWithCloudColumn = 'is_synched_with_cloud';
const userIdColumn = 'user_id';
const textColumn = 'text';
