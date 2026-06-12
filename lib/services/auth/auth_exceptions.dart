// login Exceptions
class UserNotFoundException implements Exception {}

class WrongPasswordException implements Exception {}

//Register Exceptions

class WeakPasswordException implements Exception {}

class EmailAlreadyInUseException implements Exception {}

class InvalidEmailAuthException implements Exception {}

//Genraic Exceuptions

class GenericAuthException implements Exception {}

class UserNotLoggedInException implements Exception {}
