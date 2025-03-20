//  GENERAL EXCEPTIONS
class OfflineException implements Exception {} // PRIMARY

class ServerDownException implements Exception {} // PRIMARY

//  AUTH EXCEPTIONS
class EmailRegistrationException implements Exception {} // PRIMARY

class CodeErrorException implements Exception {} // PRIMARY

// class ProfileNotFoundException implements Exception {} // SECONDARY
// class ProfileSubmitionFailedException implements Exception {} // SECONDARY
// class UserNotFoundException implements Exception {} // SECONDARY
// class NoMoreDataException implements Exception {} // SECONDARY

//  HTTP EXCEPTIONS
class EmptyResponseException implements Exception {} // PRIMARY

class BadRequestException implements Exception {} // PRIMARY

class SessionGenerationException implements Exception {} // PRIMARY

class DuplicateActionException implements Exception {} // PRIMARY
