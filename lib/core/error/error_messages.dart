/// Centralized error messages for the application
class ErrorMessages {
  // Network errors
  static const String noInternetConnection = 'No internet connection. Please check your network.';
  static const String timeoutError = 'Request timeout. Please try again.';
  static const String connectionError = 'Connection error. Please try again.';

  // Server errors
  static const String serverError = 'Server error. Please try again later.';
  static const String badRequest = 'Invalid request. Please check your input.';
  static const String unauthorized = 'Unauthorized access. Please login again.';
  static const String forbidden = 'Access forbidden.';
  static const String notFound = 'Resource not found.';
  static const String internalServerError = 'Internal server error. Please try again later.';

  // Cache errors
  static const String cacheError = 'Failed to load cached data.';
  static const String cacheWriteError = 'Failed to save data locally.';

  // Validation errors
  static const String validationError = 'Validation error. Please check your input.';
  static const String emptyField = 'This field cannot be empty.';

  // Unknown errors
  static const String unknownError = 'An unexpected error occurred. Please try again.';

  // Success messages
  static const String success = 'Operation completed successfully.';
  static const String dataLoaded = 'Data loaded successfully.';

  // Pet-specific errors
  static const String petNotFound = 'Pet not found.';
  static const String failedToLoadPets = 'Failed to load pets. Please try again.';
  static const String failedToToggleFavorite = 'Failed to update favorite status.';
}
