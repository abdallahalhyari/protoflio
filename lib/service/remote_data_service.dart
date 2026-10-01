import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;

/// Fetches JSON data from a remote URL, falling back to local assets if
/// the network request fails or times out.
class RemoteDataService {
  RemoteDataService._();
  static final RemoteDataService instance = RemoteDataService._();

  // The base URL for fetching the latest data.
  // Currently points to the raw main branch of the GitHub repository.
  // When you commit changes to assets/data/*.json, the app will automatically
  // fetch them without needing a new deployment.
  static const String _baseUrl =
      'https://raw.githubusercontent.com/abdallahalhyari/protoflio/main/';

  Future<String> fetchJson(String assetPath) async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl$assetPath'))
          .timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        return response.body;
      }
    } catch (e) {
      // Ignore network errors and silently fall back to local assets
    }

    // Fallback to local bundled asset
    return await rootBundle.loadString(assetPath);
  }
}
