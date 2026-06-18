class CloudStroageExceptions implements Exception {
  const CloudStroageExceptions();
}

class CouldNotCreateNoteException implements CloudStroageExceptions {}

class CouldNotGetAllNotesException implements CloudStroageExceptions {}

class CouldNotUpdateNoteException implements CloudStroageExceptions {}

class CouldNotDeleteNoteException implements CloudStroageExceptions {}
