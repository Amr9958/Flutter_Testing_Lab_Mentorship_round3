/// API constants and endpoints for The Dog API
class ApiConstants {
  // Base URLs - The Dog API
  static const String baseUrl = 'https://api.thedogapi.com/';
  static const String apiVersion = 'v1';
  static const String apiBaseUrl = '$baseUrl$apiVersion/';

  
  static const String apiKey = 'live_KeJ77Osr0irDiBVEtwX1HVV0tJ21Mmy1H6tNhd8lYLn7tvIxIUdafcC4URvxmciA'; 

  // Timeout durations
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // Endpoints - Dog API
  static const String breeds = 'breeds';
  static const String images = 'images/search';
  static  String imageById(String id) => 'images/$id';
  static const String favorites = 'favourites';
  static const String votes = 'votes';
  static const String sources = 'sources';

  // Query Parameters
  static const String limitParam = 'limit';
  static const String pageParam = 'page';
  static const String orderParam = 'order';
  static const String breedIdParam = 'breed_id';
  static const String categoryIdParam = 'category_id';
  static const String sizeParam = 'size';
  static const String mimeTypesParam = 'mime_types';
  static const String hasBreeds = 'has_breeds';

  // Headers
  static const String contentType = 'application/json';
  static const String accept = 'application/json';
  static const String apiKeyHeader = 'x-api-key';
}
